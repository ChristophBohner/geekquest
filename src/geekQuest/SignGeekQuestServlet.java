package geekQuest;


import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class SignGeekQuestServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        // We have one entity group per Guestbook with all Greetings residing
        // in the same entity group as the Guestbook to which they belong.
        // This lets us run a transactional ancestor query to retrieve all
        // Greetings for a given Guestbook.  However, the write rate to each
        // Guestbook should be limited to ~1/second.
        String geekQuestName = req.getParameter("geekQuestName");
        Key geekQuestKey = KeyFactory.createKey("GeekQuest", geekQuestName);
        String name = req.getParameter("name");
        String characterType = req.getParameter("characterType");
        String health = req.getParameter("health");
        Date date = new Date();
        Entity player = new Entity("Player", geekQuestKey);
        player.setProperty("user", user);
        player.setProperty("date", date);
        player.setProperty("name", name);
        player.setProperty("health", health);
        player.setProperty("characterType", characterType);
        

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(player);

        resp.sendRedirect("/GeekQuest.jsp?geekQuestName=" + geekQuestName);
    }
}