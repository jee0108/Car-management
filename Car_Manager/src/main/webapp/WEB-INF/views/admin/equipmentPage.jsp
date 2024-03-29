<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>품목관리</title>
<!-- css-->
<link rel="stylesheet" href="resources/css/equipment.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- bootstrap -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<style>
    .delivery { color: red; } /* 납품일에 대한 스타일 */
    .reception { color: green; } /* 입고일에 대한 스타일 */
</style>

</head>
<body>

	<jsp:include page="../common/adminHeader.jsp" />
	
	<div class="main-wrap" style="height: 825px;">

		<div class="items" style="height: 720px;">
			<div class="items-inner"  style="width: 1200px;">
				<div class="inner">
					<label>비품 구분&nbsp;&nbsp;</label>
					<select name="itemCode" id="item">
						<option value="EN">엔진타입</option>
						<option value="DV">구동타입</option>
						<option value="WH">휠타이어</option>
						<option value="ID">내장디자인</option>
						<option value="OP">옵션</option>
					</select>
					&nbsp;&nbsp;<button onclick="selectItem();" class="btn btn-sm btn-default">조회</button>

					<script>
						function selectItem(){
							
							$.ajax({
								url: 'selectItem',
								data: {
									itemCode: $('#item').val()
									},
								success:result=>{
									console.log(result.pi);
                                    var invenList = result.invenList;
                                    var pi = result.pi;

                                    let value= '';

                                    for(let i in invenList){
										value += '<tr>'
											  +  '<td>' + invenList[i].itemName + '</td>'
											  +  '<td>' + invenList[i].invenCode + '</td>'
											  +  '<td>' + invenList[i].invenName + '</td>'
											  +  '<td>' + invenList[i].finalNum  + '</td>'
                                              +  '<td>' + invenList[i].invenDate + '</td>'
											  +  '<td style="display:none;">' + invenList[i].invenNum + '</td>'
											  +  '<td style="display:none;">' + invenList[i].totalStockNum + '</td>'
											  +  '<td style="display:none;">' + invenList[i].totalDeloveryNum + '</td>'
											  +  '</tr>'
									}
                                    $('#items-list tbody').html(value);

                                    $('#pagingArea').hide(); 
                                    $('#pagingArea').val();
								},
								error:()=>{
									console.log('실패');
								}
							});
						}
					</script>
					<button class="btn btn-sm btn-end btn-default" data-toggle="modal" data-target="#myModal">비품등록</button>
                    <button class="btn btn-sm btn-warning" data-toggle="modal" data-target="#stock">입고</button>
					<br><br>

					<div id="items-list">
						<table class="table table-hover table-size">
							<thead>
								<tr>
									<th>구분</th>
									<th>비품코드</th>
									<th>비품이름</th>
									<th>재고현황</th>
                                    <th>일자</th>
								</tr>
							</thead>

							<tbody>
								<c:if test="${empty list}">
									<tr>
										<td colspan="5" style="text-align: center;">조회 결과가 없습니다.</td>
									</tr>
								</c:if>

								<c:forEach items="${list}" var="i">
									<tr data-toggle="modal" href="#resultModal">
										<td class="itemName">${i.itemName}</td>
										<td class="invenPk">${i.invenCode}</td>
										<td class="invenName">${i.invenName}</td>
										<td class="invenNum">${i.finalNum}</td>
                                        <td class="invenDate">${i.invenDate}</td>
                                        <td class="invenNum" style="display:none;">${i.invenNum}</td>
                                        <td class="invenDate" style="display:none;">${i.totalStockNum}</td>
                                        <td class="invenDate" style="display:none;">${i.totalDeloveryNum}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>

                        <!-- Modal -->
                        <div id="stock" class="modal fade" role="dialog">
                            <div class="modal-dialog">
                        
                                <form method="post" action="enroll-stock">
                                <!-- Modal content-->
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                        <h4 class="modal-title">입고</h4>
                                    </div>
                                    <div class="modal-body">
                                        <table>
                                            <tr style="height: 40px;">
                                                <th width="100">구분</th>
                                                <td>
                                                    <select name="invenCode" id="insertItem">
                                                        <c:forEach items="${insertList}" var="i">  
                                                            <option value="${i.invenCode}" class="searchCode">${i.invenCode} / ${i.invenName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                            </tr>

                                            <tr style="height: 40px;">
                                                <th>입고량</th>
                                                <td><input type="number" name="stockNum" min="1" value="1"></td>
                                            </tr>
                        
                                        </table>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="submit" class="btn btn-sm btn-primary">추가</button>
                                    </div>
                                </div>
                                </form>
                                
                            </div>
                        </div>


                        <!-- Modal -->
                        <div id="myModal" class="modal fade" role="dialog">
                            <div class="modal-dialog">
                        
                                <form method="post" action="enroll-invenType">
                                <!-- Modal content-->
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                        <h4 class="modal-title">항목 추가</h4>
                                    </div>
                                    <div class="modal-body">
                                        <table>
                                            <tr style="height: 40px;">
                                                <th width="100">구분</th>
                                                <td>
                                                    <select name="itemCode" id="insertItem">
                                                        <option value="EN">엔진타입</option>
                                                        <option value="DV">구동타입</option>
                                                        <option value="WH">휠타이어</option>
                                                        <option value="ID">내장디자인</option>
                                                        <option value="OP">옵션</option>
                                                    </select>
                                                </td>
                                            </tr>

                                            <tr style="height: 40px;">
                                                <th>비품코드</th>
                                                <td><input type="text" name="invenCode" id="invenPk"></td>
                                            </tr>

                                            <tr style="height: 40px;">
                                                <th>비품명</th>
                                                <td><input type="text" name="invenName"></td>
                                            </tr>

                                            <tr style="height: 40px;">
                                                <th>비품가격</th>
                                                <td><input type="number" name="invenPay" min="0" value="0"></td>
                                            </tr>

                                            <tr style="height: 40px;">
                                                <th>초기재고</th>
                                                <td><input type="number" name="invenNum" min="0" value="0"></td>
                                            </tr>

											<tr style="height: 40px;">
                                                <th>추가가격</th>
                                                <td><input type="number" name="invenPlusPay" min="0" value="0"></td>
                                            </tr>
                        
                                        </table>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="submit" class="btn btn-sm btn-primary">추가</button>
                                    </div>
                                </div>
                                </form>
                                
                            </div>
                        </div>


						<script>
							$(()=>{
								$('#items-list>table>tbody>tr').click(function () {
									var invenPk = $(this).children('.invenPk').text();
									$('#invenPk').val(invenPk);

                                    var invenPk = $(this).children('.invenPk').text();
                                    var invenName = $(this).children('.invenName').text();
									$('#detail-code').html(invenPk + ' / '+invenName);

									$.ajax({
										url: 'detail-inven',
										data: {
											invenCode: invenPk
											},
										success:result=>{
											console.log(result);
											var value = '';
											var inven = result.result;
											if(inven.length === 0){
												value += '<tr>' 
													  + '<td colspan="4" style="text-align:center;">결과가 존재하지 않습니다.</td>'
													  + '</tr>'
											}
											for (let i in inven) {
											var styleClass = inven[i].tableType === '납품' ? 'delivery' : 'reception';
											value += '<tr>' +
												'<td class="' + styleClass + ' tableType">' + inven[i].tableType + '</td>' +
												'<td class="invenCode">' + inven[i].invenCode + '</td>' +
												'<td class="quantity">' + inven[i].quantity + '</td>' +
												'<td class="day">' + inven[i].day + '</td>' +
												'</tr>'
										}

											var pi = result.pi;
											var currentPage = pi.currentPage; // 현재 페이지
											var startPage = pi.startPage; // 시작 페이지
											var endPage = pi.endPage; // 끝 페이지
											var maxPage = pi.maxPage; // 전체 페이지 수
											var paginationHtml ='';


											if (currentPage === 1) {
												paginationHtml += '<li class="page-item disabled"><span class="page-link">◄</span></li>';
											} else {
												paginationHtml += '<li class="page-item"><a class="page-link" href="procurement-Management?cPage=' + (currentPage - 1) + '">◄</a></li>';
											}

											for (var i = startPage; i <= endPage; i++) {
												if (i === currentPage) {
													paginationHtml += '<li class="page-item active"><span class="page-link">' + i + '</span></li>';
												} else {
													paginationHtml += '<li class="page-item"><a class="page-link" href="procurement-Management?cPage=' + i + '">' + i + '</a></li>';
												}
											}

											if (endPage === maxPage) {
												paginationHtml += '<li class="page-item disabled"><span class="page-link">►</span></li>';
											} else {
												paginationHtml += '<li class="page-item"><a class="page-link" href="procurement-Management?cPage=' + (currentPage + 1) + '">►</a></li>';
											}

											$('#modalPagination').html(paginationHtml);
											$('.stockAndDelovery > tbody').html(value);
											
										},
										error:()=>{
											console.log('실패');
										}
									});
								});
						   })
						</script>

					<!-- Modal -->
					<div id="resultModal" class="modal modal-center fade" role="dialog">
						<div class="modal-dialog modal-lg">
					
							<!-- Modal content-->
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal">&times;</button>
									<h4 class="modal-title"><p id="detail-code"></p></h4>
								</div>
								<div class="modal-body">
									<div>
										<table class="table table-hover table-size stockAndDelovery">
											<thead>
												<tr>
													<th>구분</th>
													<th>코드명</th>
													<th>수량</th>
													<th>일자</th>
												</tr>
											</thead>
											<tbody>

											</tbody>
										</table>
									</div>

								</div>
								<div class="modal-footer">

									<div id="pageInfo" style="margin: auto; text-align: center;">
										<ul class="pagination" style="padding-left: 50px;" id="modalPagination">
											
										</ul>
									</div>

									<button onclick="deleteInven();" class="btn btn-sm btn-danger">항목삭제</button>

								</div>
								<script>
									function deleteModel(){
										
										$.ajax({
											url: 'deleteInven',
											data: {
												
												},
											success:result=>{
												console.log(result);
												alert("납품처리되었습니다.");
												window.location.href = "/genesis/procurement-Management";
											},
											error:()=>{
												console.log('실패');
											}
										});
									}
								</script>

							</div>
						<div>
					</div>
				</div>
				
				
			</div>
			<div id="pagingArea">
				<ul class="pagination">
					<li></li>
					<c:choose>
						<c:when test="${pi.currentPage eq 1 }">
							<li class="page-item disabled"><a class="page-link" href="#">◄</a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item"><a class="page-link" href="equipment-management?cPage=${pi.currentPage-1}">◄</a></li>
						</c:otherwise>
					</c:choose>

					<c:forEach begin="${pi.startPage}" end="${pi.endPage}" var ="p">
						<li class="page-item"><a class="page-link" href="equipment-management?cPage=${p}">${p}</a></li>
					</c:forEach>

					<c:choose>
						<c:when test="${pi.endPage eq pi.maxPage}">
							<li class="page-item disabled"><a class="page-link" href="#">►</a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item"><a class="page-link" href="equipment-management?cPage=${pi.currentPage+11}">►</a></li>
						</c:otherwise>
					</c:choose>
				</ul>
			</div>
			
		</div>
	
	</div>
	

</body>
</html>