<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>hello</title>
</head>
<body>
	<form action="VoteResult.jsp" method="post">
		<table align="center" width="100">
			<tr>
				<td><input type="text" name="name" /></td>
				<td align="right"><input type="submit" value="查询"></td>
			</tr>
			<tr>
				<td><a href="CreateVote.jsp">创建投票</a></td>
			</tr>
			<tr>
				<td><a href="registeruser.jsp">注册普通用户</a></td>
			</tr>
		</table>
	</form>
</body>
</html>
