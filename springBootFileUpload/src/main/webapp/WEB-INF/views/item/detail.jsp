<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>T1 Community | Mission Detail</title>
<style>
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
	margin: 0;
	padding: 50px 0;
}

.detail-container {
	max-width: 800px;
	margin: 0 auto;
	background: var(--t1-gray);
	border: 2px solid var(--t1-red);
	border-radius: 15px;
	box-shadow: 0 0 30px rgba(226, 1, 45, 0.2);
	overflow: hidden;
}

/* 상단 헤더 영역 */
.detail-header {
	background: #222;
	padding: 30px;
	border-bottom: 1px solid #333;
}

.detail-header .post-no {
	color: var(--t1-red);
	font-weight: bold;
	font-size: 0.9rem;
	margin-bottom: 10px;
	display: block;
}

.detail-header h1 {
	margin: 0;
	font-size: 1.8rem;
	letter-spacing: -1px;
}

.post-info {
	margin-top: 15px;
	font-size: 0.9rem;
	color: #888;
	display: flex;
	gap: 20px;
}

.post-info span b {
	color: var(--t1-gold);
}

/* 본문 영역 */
.detail-content {
	padding: 40px 30px;
	min-height: 300px;
	line-height: 1.8;
	font-size: 1.1rem;
	white-space: pre-wrap; /* 줄바꿈 유지 */
	border-bottom: 1px solid #333;
}

/* 하단 버튼 영역 */
.btn-area {
	padding: 20px 30px;
	background: #151515;
	display: flex;
	justify-content: space-between;
}

.btn {
	padding: 10px 25px;
	font-weight: bold;
	border-radius: 5px;
	text-decoration: none;
	transition: 0.3s;
	cursor: pointer;
	border: none;
	font-size: 0.9rem;
}

.btn-list {
	background: #333;
	color: #fff;
}

.btn-list:hover {
	background: #444;
}

.btn-group {
	display: flex;
	gap: 10px;
}

.btn-edit {
	background: var(--t1-gold);
	color: #000;
}

.btn-delete {
	background: var(--t1-red);
	color: #fff;
}

.btn:hover {
	transform: translateY(-2px);
	opacity: 0.9;
}

/* 데코레이션 */
.footer-deco {
	padding: 15px;
	text-align: center;
	font-size: 0.75rem;
	color: #444;
	background: #0f0f0f;
}
</style>
</head>
<body>

	<div class="detail-container">
		<div class="detail-header">
			<span class="post-no">회원번호 ${member.no}</span>
			<h1>${member.id}</h1>
			<div class="post-info">
				<span>name: <b>${member.name}</b></span> <span>DATE: <b><fmt:formatDate
							value="${member.regDate}" pattern="yyyy.MM.dd HH:mm" /></b></span>
			</div>
		</div>

		<div class="btn-area">
			<form:form modelAttribute="member">
				<form:select path="authList[0].auth" disabled="true">
					<form:option value="" label="=== 선택해 주세요 ===" />
					<form:option value="ROLE_USER" label="사용자" />
					<form:option value="ROLE_MEMBER" label="회원" />
					<form:option value="ROLE_ADMIN" label="관리자" />
				</form:select>
				<form:select path="authList[1].auth" disabled="true">
					<form:option value="" label="=== 선택해 주세요 ===" />
					<form:option value="ROLE_USER" label="사용자" />
					<form:option value="ROLE_MEMBER" label="회원" />
					<form:option value="ROLE_ADMIN" label="관리자" />
				</form:select>
				<form:select path="authList[2].auth" disabled="true">
					<form:option value="" label="=== 선택해 주세요 ===" />
					<form:option value="ROLE_USER" label="사용자" />
					<form:option value="ROLE_MEMBER" label="회원" />
					<form:option value="ROLE_ADMIN" label="관리자" />
				</form:select>
			</form:form>
		</div>

		<div class="btn-area">
			<a href="/member/memberList" class="btn btn-list">회원리스트</a>
			<div class="btn-group">
				<a href="/member/updateForm?no=${member.no}" class="btn btn-edit">수정하기</a>
				<a href="/member/delete?no=${member.no}" class="btn btn-delete"
					onclick="return confirm('정말 삭제하시겠습니까?')">삭제하기</a>
			</div>
		</div>

		<div class="footer-deco">[ DATA ARCHIVE: T1 COMMUNITY SECURE
			TERMINAL ]</div>
	</div>

</body>
</html>