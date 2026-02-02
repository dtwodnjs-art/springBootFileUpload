<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>T1 Shop | Item Update</title>
<style>
:root {
	--t1-red: #E2012D;
	--t1-red-hover: #ff1a4a;
	--t1-black: #0a0a0a;
	--t1-gray: #161616;
	--t1-gold: #C69C6D;
	--t1-white: #eeeeee;
	--transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

body {
	background-color: var(--t1-black);
	background-image: radial-gradient(circle at 50% -20%, #3a000a 0%, #0a0a0a 80%);
	font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui,
		Roboto, sans-serif;
	color: var(--t1-white);
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
	margin: 0;
	padding: 20px;
}

.write-container {
	width: 100%;
	max-width: 650px;
	background: rgba(22, 22, 22, 0.8);
	backdrop-filter: blur(10px);
	padding: 50px;
	border-radius: 20px;
	border: 1px solid rgba(226, 1, 45, 0.3);
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5), 0 0 20px
		rgba(226, 1, 45, 0.1);
	position: relative;
	overflow: hidden;
}

.write-container::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 4px;
	background: linear-gradient(90deg, transparent, var(--t1-red), transparent);
}

.header {
	text-align: center;
	margin-bottom: 45px;
}

.header h1 {
	font-size: 2.2rem;
	font-weight: 800;
	letter-spacing: 2px;
	margin: 0;
	text-shadow: 0 0 15px rgba(226, 1, 45, 0.4);
}

.header span {
	color: var(--t1-red);
}

.form-group {
	margin-bottom: 28px;
}

.form-group label {
	display: block;
	font-size: 0.85rem;
	color: var(--t1-gold);
	margin-bottom: 10px;
	letter-spacing: 1px;
	font-weight: 600;
}

input[type="text"], input[type="number"], textarea {
	width: 100%;
	padding: 14px 18px;
	background: rgba(0, 0, 0, 0.3);
	border: 1px solid #333;
	border-radius: 8px;
	color: #fff;
	font-size: 1rem;
	box-sizing: border-box;
	transition: var(--transition);
}

textarea {
	height: 140px;
	resize: none;
	line-height: 1.6;
}

input:focus, textarea:focus {
	border-color: var(--t1-red);
	outline: none;
	background: rgba(226, 1, 45, 0.05);
	box-shadow: 0 0 15px rgba(226, 1, 45, 0.2);
}

.current-img-box {
	margin-bottom: 15px;
	border-radius: 8px;
	overflow: hidden;
	border: 1px solid #333;
	width: fit-content;
}

.file-upload-wrapper {
	position: relative;
}

.file-input {
	display: none;
}

.file-label {
	display: flex;
	align-items: center;
	background: rgba(0, 0, 0, 0.3);
	border: 1px solid #333;
	border-radius: 8px;
	cursor: pointer;
	overflow: hidden;
	transition: var(--transition);
}

.file-label:hover {
	border-color: var(--t1-gold);
}

.file-btn {
	background: #222;
	color: var(--t1-gold);
	padding: 14px 25px;
	font-size: 0.85rem;
	font-weight: bold;
	border-right: 1px solid #333;
}

.file-name-text {
	padding: 0 20px;
	color: #888;
	font-size: 0.9rem;
}

.btn-area {
	display: grid;
	grid-template-columns: 1fr 2fr 1fr;
	gap: 12px;
	margin-top: 40px;
}

.btn {
	padding: 16px;
	font-size: 0.95rem;
	font-weight: 700;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	transition: var(--transition);
	text-transform: uppercase;
	text-align: center;
	text-decoration: none;
	display: flex;
	align-items: center;
	justify-content: center;
}

.btn-submit {
	background: var(--t1-red);
	color: #fff;
	box-shadow: 0 4px 15px rgba(226, 1, 45, 0.3);
}

.btn-submit:hover {
	background: var(--t1-red-hover);
	transform: translateY(-2px);
}

.btn-list, .btn-cancel {
	background: #252525;
	color: #bbb;
}

.bottom-deco {
	margin-top: 40px;
	font-size: 11px;
	color: #444;
	text-align: center;
	letter-spacing: 2px;
	text-transform: uppercase;
}
</style>
</head>
<body>

	<div class="write-container">
		<div class="header">
			<h1>ITEM <span>UPDATE</span></h1>
		</div>

		<form action="/item/update" method="post" enctype="multipart/form-data">
			<div class="form-group">
				<label for="id">상품 ID</label> 
				<input type="text" id="id" name="id" value="${item.id}" readonly>
			</div>

			<div class="form-group">
				<label for="name">상품명</label> 
				<input type="text" id="name" name="name" value="${item.name}" required>
			</div>

			<div class="form-group">
				<label for="price">상품가격(KRW)</label> 
				<input type="number" id="price" name="price" value="${item.price}" required>
			</div>

			<div class="form-group">
				<label>기존 상품 이미지</label>
				<div class="current-img-box">
					<img src="/item/display?id=${item.id}" width="200" alt="상품이미지" onerror="this.src='/resources/img/no-image.png'">
				</div>
			</div>

			<div class="form-group">
				<label>새 이미지로 교체</label>
				<div class="file-upload-wrapper">
					<input type="file" id="picture" name="picture" class="file-input" onchange="updateFileName(this)"> 
					<label for="picture" class="file-label"> 
						<span class="file-btn">파일 선택</span> 
						<span id="file-name" class="file-name-text">이미지 변경 시에만 선택하세요</span>
					</label>
				</div>
			</div>

			<div class="form-group">
				<label for="description">상품 상세 설명</label>
				<textarea id="description" name="description" placeholder="상품 상세 설명을 입력하세요">${item.description}</textarea>
			</div>

			<div class="btn-area">
				<a href="/item/list" class="btn btn-list">상품 목록</a>
				<button type="submit" class="btn btn-submit">상품 수정</button>
				<button type="reset" class="btn btn-cancel">취소</button>
			</div>
		</form>

		<div class="bottom-deco">[ SYSTEM: MULTIPART DATA READY TO UPDATE ]</div>
	</div>

	<script>
		function updateFileName(input) {
			const fileNameDisplay = document.getElementById('file-name');
			if (input.files && input.files.length > 0) {
				const name = input.files[0].name;
				fileNameDisplay.innerText = name;
				fileNameDisplay.style.color = "#ffffff";
			} else {
				fileNameDisplay.innerText = "이미지 변경 시에만 선택하세요";
				fileNameDisplay.style.color = "#888";
			}
		}
	</script>
</body>
</html>