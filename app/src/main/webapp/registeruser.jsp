<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="application.RegisterUser" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String ORGNAME_ORG1 = "Org1";
String ADMINNAME_ORG1 = "admin";
String ADMINPWD_ORG1 = "adminpw";
String CA_CERT_ORG1 = "/home/csren/vote/app/profiles/" + ORGNAME_ORG1 + "/tls/" + "ca.org1.example.com-cert.pem";
String MSPID_ORG1 = "Org1MSP";
	
String ORGNAME_ORG2 = "Org2";
String ADMINNAME_ORG2 = "admin";
String ADMINPWD_ORG2 = "adminpw";
String CA_CERT_ORG2 = "/home/csren/vote/app/profiles/" + ORGNAME_ORG2 + "/tls/" + "ca.org2.example.com-cert.pem";
String MSPID_ORG2 = "Org2MSP";

RegisterUser.doRegisterUser("Org1","user01","user01pw",MSPID_ORG1,ADMINNAME_ORG1,CA_CERT_ORG1);
%>
<%= "\u7528\u6237\u6ce8\u518c\u6210\u529f" %>
</body>
</html>