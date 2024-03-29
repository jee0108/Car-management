<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>GENESIS</title>
<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1" />
<!-- css-->
<link rel="stylesheet" href="resources/css/main.css">
</head>
<body>

	<jsp:include page="common/header.jsp" />

	<div class="mainOuter">

		<swiper-container class="mySwiper" pagination="true"
			pagination-dynamic-bullets="true" autoplay="true" delay="3000">
		<swiper-slide>
		<img
			src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbIQeYG%2FbtqC2udDXIC%2FzermYkdXGyvvXrQfXYKxR0%2Fimg.jpg" width="2000" height="730"></swiper-slide>
		<swiper-slide>
		<img
			src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FyVaHX%2FbtqC1HqA5pd%2FHpLHwKESZig33HQRwPXQXK%2Fimg.jpg" width="2000" height="730"></swiper-slide>
		<swiper-slide>
		<img
			src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbWzi06%2FbtqC6PfLRAA%2FAh0QFCskLr35JnfsaAaiIk%2Fimg.jpg" width="2000" height="730"></swiper-slide>
		</swiper-container>

		<script
			src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-element-bundle.min.js"></script>

	</div>

	<jsp:include page="common/footer.jsp" />

</body>
</html>
