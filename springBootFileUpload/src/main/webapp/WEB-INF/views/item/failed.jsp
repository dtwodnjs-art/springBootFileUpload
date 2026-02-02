<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>T1 Community | Write</title>
<style>
/* T1 Official Theme */
:root {
	--t1-red: #E2012D;
	--t1-black: #0f0f0f;
	--t1-gray: #1a1a1a;
	--t1-gold: #C69C6D;
}

body {
	background-color: var(--t1-black);
	font-family: 'Pretendard', sans-serif;
	color: #ffffff;
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
	margin: 0;
}

.write-container {
	width: 100%;
	max-width: 700px;
	background: var(--t1-gray);
	padding: 40px;
	border-radius: 15px;
	border: 2px solid var(--t1-red);
	box-shadow: 0 0 30px rgba(226, 1, 45, 0.2);
}

.header {
	text-align: center;
	margin-bottom: 40px;
}

.header h1 {
	font-size: 2rem;
	font-weight: 900;
	letter-spacing: -1px;
}

.header span {
	color: var(--t1-red);
}
/* Buttons */
.btn-area {
	display: flex;
	gap: 15px;
	margin-top: 30px;
}

.btn {
	flex: 1;
	padding: 15px;
	font-size: 1rem;
	font-weight: bold;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	transition: 0.3s;
	text-transform: uppercase;
}

.btn-submit {
	background: var(--t1-red);
	color: #fff;
}

.btn-submit:hover {
	background: #ff1a4a;
	transform: translateY(-3px);
	box-shadow: 0 5px 15px rgba(226, 1, 45, 0.5);
}

.btn-cancel {
	background: #333;
	color: #bbb;
}

.btn-cancel:hover {
	background: #444;
	color: #fff;
}
</style>
</head>
<body>

	<div class="write-container">
		<div class="header">
			<h1>${message}</h1>
		</div>
		<div class="btn-area">
			<a href="/item/createForm"><button class="btn">상품등록</button></a>
			<a href="/item/list"><button class="btn">상품리스트</button></a>
		</div>
	</div>
</body>
</html>