<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>

  <body>

<%
    String geekQuestName = request.getParameter("geekQuestName");
    if (geekQuestName == null) {
        geekQuestName = "default";
    }
    pageContext.setAttribute("geekQuestName", geekQuestName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
    
%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

    <form action="/sign" method="post">
      <label for="name">Name: </label>
      <div><input type="text" name="name" rows="1" cols="60" value="${fn:escapeXml(player)}"></textarea></div>
      <label for="characterType">Character Type: </label>
      <div><select name="characterType">
      			<option>hobbit</option>
      			<option>dwarf</option>
      			<option>mage</option>
      			<option>elve</option>
      		</select>
      </div>
      <label for="health">Health: </label>
      <div><p>10</p></div>
      <div><input type="submit" value="Speichern" /></div>
      <input type="hidden" name="geekQuestName" value="${fn:escapeXml(geekQuestName)}"/>
    </form>
<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to create your Character.</p>
<%
    }
%>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key geekQuestKey = KeyFactory.createKey("GeekQuest", geekQuestName);
    Query query = new Query("Player", geekQuestKey).addSort("date", Query.SortDirection.DESCENDING);
%>



  </body>
</html>