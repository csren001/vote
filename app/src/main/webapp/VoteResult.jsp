<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="application.InvokeQuery" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Result</title>
    <script type="text/javascript">
	  function toDoVote(){
	      var url = "DoVote.jsp";
	      window.location.href= url;
	  }
    </script>
</head>
<body>
<table align="center">
	<caption>投票结果</caption>
	<thead>
		<tr>
			<th>ID</th>
			<th>描述</th>
			<th>票数</th>
			<th >操作</td>
		</tr>
	</thead>
<%
String voteName = request.getParameter("name");
String re = InvokeQuery.doQuery("Org1","user01","Query",voteName);
JSONObject jsonObject = JSONObject.parseObject(re);
for(String key:jsonObject.keySet()){
%><tr>
<td><%=key %></td>
<td>无</td>
<td><%=jsonObject.get(key) %></td>
<td><a href=<%= "DoVote.jsp?voteName="+voteName+"&candidate="+key %>>投票</a></td>
</tr>
<% } %></table>
</body>
</html>

