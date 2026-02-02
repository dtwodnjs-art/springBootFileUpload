<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>T1 Community | Board List</title>
<style>
    :root {
        --t1-red: #E2012D;
        --t1-black: #0f0f0f;
        --t1-gray: #1a1a1a;
        --t1-gold: #C69C6D;
        --t1-table-hover: #252525;
    }

    body {
        background-color: var(--t1-black);
        font-family: 'Pretendard', sans-serif;
        color: #ffffff;
        margin: 0;
        padding: 50px 0;
    }

    .container {
        max-width: 1000px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .header-box {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        border-bottom: 3px solid var(--t1-red);
        padding-bottom: 15px;
        margin-bottom: 30px;
    }

    .header-box h1 {
        font-size: 2.5rem;
        font-weight: 900;
        margin: 0;
        letter-spacing: -1.5px;
    }

    .header-box h1 span { color: var(--t1-red); }

    .btn-write {
        background: var(--t1-red);
        color: white;
        text-decoration: none;
        padding: 10px 25px;
        font-weight: bold;
        border-radius: 4px;
        transition: 0.3s;
        text-transform: uppercase;
    }

    .btn-write:hover {
        background: white;
        color: var(--t1-red);
        box-shadow: 0 0 15px rgba(255, 255, 255, 0.3);
    }

    /* Table Styles */
    .t1-table {
        width: 100%;
        border-collapse: collapse;
        background: var(--t1-gray);
        border-radius: 10px 10px 0 0;
        overflow: hidden;
    }

    .t1-table th {
        background: #222;
        color: var(--t1-gold);
        padding: 15px;
        font-size: 0.9rem;
        text-transform: uppercase;
        border-bottom: 1px solid #333;
    }

    .t1-table td {
        padding: 15px;
        text-align: center;
        border-bottom: 1px solid #222;
        font-size: 0.95rem;
    }

    .t1-table tr:last-child td { border-bottom: none; }

    /* Hover Effect */
    .t1-table tbody tr { transition: 0.2s; cursor: pointer; }
    .t1-table tbody tr:hover {
        background-color: var(--t1-table-hover);
        color: var(--t1-red);
    }

    .title-cell { text-align: left !important; padding-left: 30px !important; }
    .title-cell a { color: inherit; text-decoration: none; font-weight: 500; }

    /* Pagination / Footer */
    .table-footer {
        margin-top: 20px;
        text-align: right;
        font-size: 0.8rem;
        color: #555;
        font-family: monospace;
    }
    /* Search Bar Styles */
    .search-container {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 20px;
        gap: 10px;
    }

    .search-form {
        display: flex;
        background: var(--t1-gray);
        border: 1px solid #333;
        border-radius: 5px;
        padding: 5px;
        transition: 0.3s;
    }

    .search-form:focus-within {
        border-color: var(--t1-red);
        box-shadow: 0 0 10px rgba(226, 1, 45, 0.3);
    }

    .search-select {
        background: transparent;
        color: var(--t1-gold);
        border: none;
        outline: none;
        padding: 5px 10px;
        font-weight: bold;
        cursor: pointer;
    }

    .search-input {
        background: transparent;
        border: none;
        border-left: 1px solid #333;
        color: white;
        padding: 8px 15px;
        width: 200px;
        outline: none;
    }

    .btn-search {
        background: transparent;
        border: none;
        color: var(--t1-red);
        font-weight: 800;
        cursor: pointer;
        padding: 0 15px;
        transition: 0.3s;
    }

    .btn-search:hover {
        color: white;
        text-shadow: 0 0 5px var(--t1-red);
    }
</style>
</head>
<body>
    
    <div class="container">
    <div class="header-box">
        <h1>MEMBER <span>LIST</span></h1>
        <a href="/item/list" class="btn-write">상품목록리스트</a>
        <a href="/item/createForm" class="btn-write">상품등록</a>
    </div>
       

    <table class="t1-table">
        <thead>
            <tr>
                <th width="10%">ID</th>
                <th width="10%">NAME</th>
                <th width="10%">PRICE</th>
                <th width="70%">URL</th>
              
                
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty itemList}">
                    <c:forEach var="item" items="${itemList}">
                        <tr>
                            <td>${item.id}</td>
                            <td class="title-cell">
                                <a href="/item/detail?id=${item.id}">${item.name}</a>
                            </td>
                            <td>${item.price}</td>
                            <td>${item.url}</td>
                          
                           
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="4" style="padding: 50px; color: #555;">등록된 상품목록이 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="table-footer">
        [ SYSTEM: CONNECTED TO JDBCBOARD_SEQ.NEXTVAL ]
    </div>
</div>

</body>
</html>