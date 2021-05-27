<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="application.InvokeVote" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DoVote</title>
</head>
<body>
<%
String voteName = request.getParameter("voteName");
String candidate = request.getParameter("candidate");
InvokeVote.doVote("Org1","user01","Vote",voteName,candidate);
response.sendRedirect("VoteResult.jsp?name=" + voteName);
%>
</body>
</html>