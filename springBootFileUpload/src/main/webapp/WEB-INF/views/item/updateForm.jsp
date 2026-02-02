<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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

/* Form Styles */
.form-group {
	margin-bottom: 25px;
}

.form-group label {
	display: block;
	font-size: 0.9rem;
	color: var(--t1-gold);
	margin-bottom: 8px;
	text-transform: uppercase;
	font-weight: bold;
}

input[type="text"], textarea {
	width: 100%;
	padding: 12px 15px;
	background: #0b0b0b;
	border: 1px solid #333;
	border-radius: 5px;
	color: #fff;
	font-size: 1rem;
	box-sizing: border-box;
	transition: 0.3s;
}

input[type="text"]:focus, textarea:focus {
	border-color: var(--t1-red);
	outline: none;
	box-shadow: 0 0 10px rgba(226, 1, 45, 0.3);
}

textarea {
	resize: none;
	height: 250px;
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
	/* 중앙 정렬 핵심 속성 */
	display: flex;
	justify-content: center; /* 가로 중앙 */
	align-items: center; /* 세로 중앙 */
	text-decoration: none; /* 링크 밑줄 제거 */
	text-align: center;
	box-sizing: border-box; /* 패딩이 너비에 영향을 주지 않도록 설정 */
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

/* Decoration */
.bottom-deco {
	margin-top: 30px;
	font-size: 12px;
	color: #444;
	text-align: center;
	font-family: monospace;
}
</style>
</head>
<body>

	<div class="write-container">
		<div class="header">
			<h1>${member.name}님수정화면</h1>
		</div>
	    <form:form modelAttribute="member" action="/member/update" method="post">
			<div class="form-group">
				<label for="no">회원번호</label> <input type="text" id="no" name="no"
					value="${member.no}" readonly>
			</div>
			<div class="form-group">
				<label for="id">회원아이디</label> <input type="text" id="id" name="id"
					value="${member.id}" readonly>
			</div>
			<div class="form-group">
				<label for="name">이름</label> <input type="text" id="name"
					name="name" value="${member.name}" required>
			</div>

			<div class="form-group">
				<label for="pw">암호</label> <input type="password" id="pw" name="pw"
					value="${member.pw}" required>
			</div>
			<div class="form-group">
					<form:select path="authList[0].auth" >
						<form:option value="" label="=== 선택해 주세요 ===" />
						<form:option value="ROLE_USER" label="사용자" />
						<form:option value="ROLE_MEMBER" label="회원" />
						<form:option value="ROLE_ADMIN" label="관리자" />
					</form:select>
					<form:select path="authList[1].auth" >
						<form:option value="" label="=== 선택해 주세요 ===" />
						<form:option value="ROLE_USER" label="사용자" />
						<form:option value="ROLE_MEMBER" label="회원" />
						<form:option value="ROLE_ADMIN" label="관리자" />
					</form:select>
					<form:select path="authList[2].auth" >
						<form:option value="" label="=== 선택해 주세요 ===" />
						<form:option value="ROLE_USER" label="사용자" />
						<form:option value="ROLE_MEMBER" label="회원" />
						<form:option value="ROLE_ADMIN" label="관리자" />
					</form:select>
			</div>
			<div class="btn-area">
				<a href="/member/memberList" class="btn btn-cancel">회원리스트</a>
				<button type="submit" class="btn btn-cancel">회원수정전송</button>
				<button type="reset" class="btn btn-cancel">회원수정취소</button>
			</div>
		</form:form>
	</div>
</body>
</html>