<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<!-- header -->
<%@ include file="../includes/header_R.jsp" %>
    

<title>나의 장바구니</title>

 <!-- 메뉴 사이드바 스크립트 -->
<script>
 	$(function() {
		$('#sidebarCollapse').on('click', function () {
	      $('#sidebar').toggleClass('active');
	  });

	});
</script>

<style>

	#horisonLine {
	 	    height: 10px;
		    border-bottom: groove;
		    position: relative;
			top: 20px;
	    	width: 100%;
	}

</style>
	

	<!-- 페이지 내용 부분 -->
		
		<!-- 상단 제목부분 -->
		<div class="container text-center" style="margin-top:20px;">
			<h1 class="text-center">${login.mNick}님 장바구니</h1><br>
			<div id="horisonLine"></div>
		</div>
		
		<!-- 찜 목록 그리드 시작 -->
		<div class="container mt-5">
			<div class="row">
			
			
				<!-- 카드 박스 (체크박스 포함) -->
				<div class="col-sm">
					<!--모두 선택 체크박스-->
					<div class="allCheck">
						<input name="allCheck" type="checkbox" id="allCheck">
						<label class="ms-1" for="allCheck">모두 선택</label><br>
					
					<script>
					$("#allCheck").click(function() {
						
						var chk = $("#allCheck").prop("checked");
						
						if(chk) {
							$(".chBox").prop("checked", true);
							
						}else {
							$(".chBox").prop("checked", false);
						}
						
					});
					
					
					
					</script>		
							
							
							
					</div>
					
			
					
					<!-- 모두 선택 체크박스 끝  -->
					
					<!-- 선택 삭제 버튼  -->
					
					<div class="delBtn">
						<button type="button" class="selectDelete_btn" style="float:right">선택 삭제</button>
					<script>
					
					 $(".selectDelete_btn").click(function(){
					  var confirm_val = confirm("정말 삭제하시겠습니까?");
					  
					  if(confirm_val) {
					   var checkArr = new Array();
					   
					   $("input[class='chBox']:checked").each(function(){
					    checkArr.push($(this).attr("data-cartNum"));
					   });
				
							
					   $.ajax({
						    url : "deleteCart.do",
						    type : "post",
						    data : { chbox : checkArr },
						    success : function(result){
						    	
						    	
						    	if(result == 1) { 
						    
							location.href="cartList.do?mNo="+${login.mNo};

						     
						     
						    	}else {
						    		
						    		alert("삭제 오류");
						    	}
						    }
						   });
						  } 
						 });
						</script>
				

		
					
					</div>
					</div>
					<br>
					<!-- 선택 삭제 버튼 end -->
					<hr>
					
					
					<!--  cartList start -->
				<c:forEach items="${cartList}" var="cartList">
				
				<input type="hidden" name="cgNo" value="${cartList.gNo }">
					

					
					
						<!-- 카드 부분 체크박스 -->
					
					<div class="checkBox">
						<input type="checkbox" name="chBox" class="chBox" data-cartNum="${cartList.cartNo }" />
					<div class="card" style="width: 30rem;">
									
					
					<script>
						$(".chBox").click(function(){
						$("#allCheck").prop("checked", false);
							
						})
						
					
					</script>
					</div>
					
					<!--  카드부분 체크박스 끝  -->
						<img class="card-img-top"
							src="resources/${cartList.gImg }" alt="Card image cap" style="width:30rem;">
						<div class="card-body">
							<p class="card-text">
								
								상품명 :${cartList.gName } <br> 
								가격 :
									<fmt:formatNumber pattern="###,###,###" value="${cartList.gPrice}" />원<br>
								구매수량 : ${cartList.cartStock }<br>
								최종가격 : <fmt:formatNumber pattern="###,###,###" value="${cartList.gPrice * cartList.cartStock }" />원
								
							</p>
							<div class="delete">
								 <button type="button" class="delete_${cartList.cartNo}_btn" data-cartNum="${cartList.cartNo}">삭제</button>
								 
								 <script>
								  $(".delete_${cartList.cartNo}_btn").click(function(){
								   var confirm_val = confirm("정말 삭제하시겠습니까?");
								   
								   if(confirm_val) {
								    var checkArr = new Array();
								    
								    checkArr.push($(this).attr("data-cartNum"));
								               
								    $.ajax({
								     url : "deleteCart.do",
								     type : "post",
								     data : { chbox : checkArr },
								     success : function(result){
								      if(result == 1) {     
								       location.href = "cartList.do?mNo="+${login.mNo};
								      } else {
								       alert("삭제 실패");
								      }
								     }
								    });
								   } 
								  });
								 </script>
								</div>
														
						
				
						</div>
						</div>
						
						<c:set var="sum" value="${sum + (cartList.gPrice * cartList.cartStock) }" />
								</c:forEach>
					</div>
					
					
					
					
					
					<div class="listResult">
					
						<div class="sum"> 
						
							총 합계 : <fmt:formatNumber pattern="###,###,###" value="${sum }"/>원 
						</div>
						
					<div class="orderOpen">
					
						<button type="button" class="orderOpen_btn">주문 정보 입력</button>
						
						
						<script>
						$(".orderOpen_btn").click(function(){
						
							$(".orderInfo").slideDown();
							$(".orderOpen_btn").slideUp();
							
							
						});
						
						</script>
					</div>
					
					
					</div>
				</div>
	
				<!--  카드박스 끝 -->
			<div class="orderInfo" style="display:none;">	
				
			<h1 class="display-7 mt-5 ms-5">주문 정보 입력</h1><button id="init_btn">정보초기화</button>
         
         				<script>				
         				
         				$("#init_btn").click(function(){
						
							$("#orderName").val() == "";
							
							
						});
         				
         				
         				
         				</script>
       	         <div class="container " style="font-size:30px;">
			
			
				</div>
 			  

 			  
 			  
 			  
 			  
 			  	
              <div class="ms-5 container mt-2 boarder=1" id="sameAddr" >
              	<form id="goodsOrder" action="goodsOrder.do" method="post">
              	<input type="hidden" name="amount" value="${sum }">
              	<input type="hidden" name="mNo" value="${login.mNo }">
             <c:forEach items="${cartList}" var="cartList">
              	<input type="hidden" name="gNo" value="${cartList.gNo }">
              	</c:forEach>
       		  <table>
		        
		        <tr>
		        <th>배송 받는 사람</th>
		        <td><input type="text" name="orderName" style="width:300px; height:40px"value="${login.mName }" ></td>
		        </tr>
		        
				<tr>
				<th>주소</th>
				<td><input type="text" id="mAddr1"	  name="orderAddr1" style="width:100px; height:40px" value="${login.mAddr1 }">
				<input class="btn btn-outline-success" type="button" name="idCheck" value="주소검색"
				onclick="execPostCode();"
				
				
				 style="font-size:20px">
				</td>
				
				</tr>
				
				<tr>
				<th>기본주소</th>
				<td><input type="text"  id="mAddr2"	 name="orderAddr2" style="width:300px; height:40px" value="${login.mAddr2 }"></td>
				</tr>
				
				<tr>
				<th>상세주소</th>
				<td><input type="text"  id="mAddr3"	  name="orderAddr3" style="width:300px; height:40px" value="${login.mAddr3 }"></td>
				</tr>
		        
		        <tr>
		        <th>연락처</th>
		        <td><input type="text" name="orderPhone" style="width:300px; height:40px"value="${login.mPhone}"></td>
		        </tr>

		        </table>
				
      	
         
       			
		         <br>
    
  
  	<br>
  	<br>
       <div class="container text-center">
       
     <button type="button" id="check_module">카드 결제하기</button>  
	<button type="submit" class="btn btn-outline-success btn-lg" id="submit">완료</button>
	
	<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
	<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
	<script>
	$("#check_module").click(function () {
	var IMP = window.IMP; // 생략가능
	IMP.init('imp87221885');
	// 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
	// i'mport 관리자 페이지 -> 내정보 -> 가맹점식별코드
	IMP.request_pay({
	pg: 'kakao', // version 1.1.0부터 지원.
	/*
	'kakao':카카오페이,
	html5_inicis':이니시스(웹표준결제)
	'nice':나이스페이
	'jtnet':제이티넷
	'uplus':LG유플러스
	'danal':다날
	'payco':페이코
	'syrup':시럽페이
	'paypal':페이팔
	*/
	pay_method: 'card',
	/*
	'samsung':삼성페이,
	'card':신용카드,
	'trans':실시간계좌이체,
	'vbank':가상계좌,
	'phone':휴대폰소액결제
	*/
	merchant_uid: 'merchant_' + new Date().getTime(),
	/*
	merchant_uid에 경우
	https://docs.iamport.kr/implementation/payment
	위에 url에 따라가시면 넣을 수 있는 방법이 있습니다.
	참고하세요.
	나중에 포스팅 해볼게요.
	*/
	name: '애니멀프렌즈',
	//결제창에서 보여질 이름
	amount: ${sum},
	//가격
	buyer_email: '',
	buyer_name: '${login.mName}',
	buyer_tel: '${login.mPhone}',
	buyer_addr: '서울특별시 강남구 삼성동',
	buyer_postcode: '123-456',
	m_redirect_url: 'https://www.yourdomain.com/payments/complete'
	/*
	모바일 결제시,
	결제가 끝나고 랜딩되는 URL을 지정
	(카카오페이, 페이코, 다날의 경우는 필요없음. PC와 마찬가지로 callback함수로 결과가 떨어짐)
	*/
	}, function (rsp) {
	console.log(rsp);
	if (rsp.success) {
		
		
	  	$("form").submit();

		
	
		
	/* var msg = '결제가 완료되었습니다. 완료버튼을 눌러주세요';
	msg += '고유ID : ' + rsp.imp_uid;
	msg += '상점 거래ID : ' + rsp.merchant_uid;
	msg += '결제 금액 : ' + rsp.paid_amount;
	msg += '카드 승인번호 : ' + rsp.apply_num;
	 */


	
	
	} else {
	var msg = '결제에 실패하였습니다.';
	msg += '에러내용 : ' + rsp.error_msg;
	}
	});
	});
	</script>

   	<button type="button" class="btn btn-outline-success btn-lg" id="cancel_btn">취소</button>
   	
								<script>
								$("#cancel_btn").click(function(){
									
								 $(".orderInfo").slideUp();
								 $(".orderOpne_btn").slideDown();
								});      
								</script>
       
       
       </div>
       
       
       </form>
      
      
      </div>
	
	
			
		</div>
	
	
	
	
	
	
	
	

	<!-- footer -->
	<%@ include file="../includes/footer.jsp" %>   
	<!-- header의 'Page 내용 div' 닫기 태그  -->

	
 	<!-- Page 내용 끝 -->
	
</body>
</html>