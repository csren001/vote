<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="application.InvokeQuery" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Result</title>
</head>
<body>
<table>
	<caption>投票结果</caption>
	<thead>
		<tr>
			<th>ID</th>
			<th>描述</th>
			<th>票数</th>
			<th >操作</td>
		</tr>
	</thead>
</table>
<% String re = InvokeQuery.doQuery("Org1","user01","Query","vote01");%>
<%= re %>
<script type="text/javascript" language="javascript">
    
    var result = InvokeQuery.doQuery("Org1","user01","Query","vote01");
    var jsonResult= eval('(' + result + ')');
    var tbl = document.createElement("table");
    for(id in jsonResult){
    	var tr = document.createElement("tr");
   		var td = document.createElement("td");
   		td.appendChild(document.createTextNode(id));
   		tr.appendChild(td);
   		td.appendChild(document.createTextNode("描述"));
   		tr.appendChild(td);
   		td.appendChild(document.createTextNode(jsonResult[id]));
   		tr.appendChild(td);
   		td.appendChild(document.createTextNode("操作"));
   		tr.appendChild(td);
    	tbl.appendChild(tr);
    }
    var body = document.getElementsByTagName("body");
    body[0].appendChild(tbl);
</script>
</body>
</html>

