<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="application.InvokeCreateVote" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
正在创建投票<%= request.getParameter("name") %>……
<% 
String voteName = request.getParameter("name");
String candidate1 = request.getParameter("candidate1");
String candidate2 = request.getParameter("candidate2");
JSONObject jsonObject = new JSONObject();
jsonObject.put(candidate1, "0");
jsonObject.put(candidate2, "0");
InvokeCreateVote.doCreateVote("Org1","user01","CreateVote",voteName,jsonObject.toString());
response.sendRedirect("VoteResult.jsp?name=" + voteName);
%>
</body>
</html>