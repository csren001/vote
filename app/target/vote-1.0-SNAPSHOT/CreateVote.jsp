<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Vote</title>
<script type="text/javascript">
	function check(form){
		with(form){
			if(name.value == ""){
				alert("投票名称不能为空");
				return false;
			}
			if(candidate1.value == ""){
				alert("选项不能少于两个");
				return false;
			}
			if(candidate2.value == ""){
				alert("选项不能少于两个");
				return false;
			}
			return true;
		}
	}
</script>
</head>
<body>
	<form action="DoCreate.jsp" method="post" onsubmit="return check(this);">
		<table align="center" width="450">
			<tr>
				<td align="center" colspan="2">
					<h2>创建投票</h2>
					<hr>
				</td>
			</tr>
			<tr>
				<td align="right">投票名称：</td>
				<td><input type="text" name="name" /></td>
			</tr>
			<tr>
				<td align="right">候选1：</td>
				<td><input type="text" name="candidate1" /></td>
			</tr>
			<tr>
				<td align="right">候选2：</td>
				<td><input type="text" name="candidate2" /></td>
			</tr>
			<tr>
				<td align="left" colspan="2">
					<input type="submit" value="创    建">
				</td>
				<td align="right" colspan="2">
					<input type="reset" value="重　置">					
				</td>
			</tr>
			<tr>
				<td align="right" colspan="2">
					<a href="">查看投票</a></td>
			</tr>
		</table>
	</form>
</body>
</html>