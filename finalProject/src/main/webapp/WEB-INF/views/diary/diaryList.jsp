<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- JSTL 사용위한 코드 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">



<title>Insert title here</title>

<!-- ionicons 사용 위한 코드 -->
<script src="https://unpkg.com/ionicons@5.4.0/dist/ionicons.js"></script>
<!-- 제이쿼리 사용 위한 코드 -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

<style type="text/css">
	h1 {
		text-align: center;
		margin-top:20px;
	    margin-bottom:50px;
		margin-top: 20px;
		}
		
		
</style>



<script type="text/javascript">
	var isEnd = false;
	var startNumber = 4;
	var endNumber = 6;
	
	$(function(){
	    $(window).scroll(function(){
	        
	    	//스크롤 바닥에 도달하면 실행
	        //if( $(window).scrollTop() == $(document).height() - $(window).height() ){
	        if( $(window).scrollTop()+$(window).height()+30 > $(document).height() ){
	            fetchList();
	            startNumber += 3;
	            endNumber += 3;
	        }
	    })
	    
	})
	
	var fetchList = function(){
	    if(isEnd == true){
	        return;
	    }
	    
	    $.ajax({
	        url: "diaryListScroll.do",
	        type: "GET",
	        data : {'startNumber' : startNumber, 
	        		'endNumber' : endNumber}, 
	        success: function(result){
	        	//console.log(result);
	        	//console.log(result[0]);
	        	
	        	scrollPrint(result);
	        	
	        }
	    });
	}
	
	function scrollPrint(result) {
		
		for(var i=0; i<result.length; i++){
		var addHtml = "<div class='row'>"+
						"<div class='col-2'></div>"+ 
						"<div class='col ms-4 my-3'>"+
							"<div class='card border-success mb-3 text-dark' style='width: 800px;'>"+
								"<div class='card-header bg-transparent border-success'>"+result[i].mnick+"</div>"+
									"<img class='card-img-top' src='resources/" + result[i].diaryImg + "'>"+
									"<ul class='list-group list-group-flush'>"+
										"<li class='list-group-item'>"+
											"<div class='row'>"+
												"<div class='col'>"+
													"<ion-icon name='heart-outline' style='font-size:25px;'></ion-icon>"+
													"<ion-icon name='heart' style='font-size:25px;'></ion-icon>"+"좋아요"+
												"</div>"+
												"<div class='col text-end'>"+
													"<ion-icon name='person-add-outline' style='font-size:25px;'></ion-icon>"+
													"<ion-icon name='person-add' style='font-size:25px;'></ion-icon>"+"팔로우"+
												"</div>"+
											"</div>"+
										"</li>"+
									"</ul>"+
						"<div class='card-body text-dark' style='height: 100px;'>"+
							"<h5 class='card-title'>"+result[i].dcontent+"</h5>"+
							"<p class='card-text'>"+result[i].ddateToChar+"</p>"+
						"</div>"+
						
						"<div class='card-footer bg-transparent border-success'>"+
							//댓글 입력란 삭제
							"<div id='replyListBox'>"+
							"<div id='"+result[i].dno+"'>"+
								"<div class='d-grid gap-2'>"+
								"<button class='btn btn-success' id='replyBtn' type='button' value='"+result[i].dno+"'>"+
								"댓글 보기</button>"+
								"</div>"+
							"</div>"+
						"</div>"+
						"</div>"+
					"</div>"+
					
					
					"</div>"+
					
					"</div>";
		
			$('#scrollPrintHere').append(addHtml);
		}
	}
	
	
	
//'댓글보기' 버튼 클릭 시 클릭된 글의 글번호(dno) 가져오고, getReplyList() 실행 
$(document).on("click", '#replyBtn', function getReplyDno() {
		
		var id = $(this).val();
		console.log(id);
		
		getReplyList(id);
});
		
		
//글 번호(dno)에 맞는 댓글 리스트 조회
function getReplyList(id) {
	
		var diaryVal = {
				"dno":id
		};
	
		var html = "<div class='replys'>";

		$.ajax({
			type:"post",
			url:"DRselectList.do",
			data:JSON.stringify(diaryVal),
			contentType:"application/json",
			dataType:"json",
			success:function(replyList){
				
				//댓글이 없다면 없다는 문구 출력				
				if(replyList.length == 0){
					
					html += "<p style='text-align:center; font-size:14pt;'>" +
							"-----아직 덧글이 없습니다. 제일 먼저 댓글을 작성해 보세요!-----" +
							"</p>";
				
					}else{

				//댓글이 있다면 반복문을 통해서 내용을 추가		
				for(var i = 0 ; i < replyList.length; i++){
					//변수 선언
					var nick = "";
					
					//만약 답글이라면 공백과 화살표 기호를 추가
					if(replyList[i].drtitletab!=0){
						nick = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
						"<ion-icon name='return-down-forward-outline'></ion-icon>";
					}
					
						nick += replyList[i].mnick;
					var content = replyList[i].drcontent;
					var date = replyList[i].drdateToChar;
					//console.log(nick);
					//console.log(content);
					//console.log(date);
					
					//출력 형식(수정 예정)
					html += nick+": "+content+" /"+date+"<hr>";
					
				}
					}
				
				html += "<input type='text' style='width: 700px; height: 38px;'>"+
						"<button type='submit' class='btn btn-outline-success ms-1 float-end' id='replySubmit' value='"+id+"'>등록</button>"	;
				html += "</div>";
				//console.log(html);

				//버튼을 지우고(div 위치를 바꿔서 변경 가능) 댓글을 append한다.
				$('#' + id).empty();
				$('#' + id).append(html);
				
			},
			error:function(){
				alert("댓글 ajax 불러오기 실패..");
			}
			
		});
}



//댓글 등록(insert)
$(document).on("click", '#replySubmit', function insertReply(){
	//클릭한 버튼의 이전 요소인 input의 value를 content로 설정
	var drcontent = $(this).prev().val();
	console.log(drcontent);
	
	var dno = $(this).val();
	console.log("dno: "+dno);
	
	//작성자 mno는 컨트롤러에서 처리해주려 함	
	
	var replyVal = {
		"dno" : dno,
		"drcontent" : drcontent
	};
	
	$.ajax({
		type:"post",
		url:"DRwrite.do",
		data:JSON.stringify(replyVal),
		contentType:"application/json",
		dataType:"json",
		success:  function(res){
			
			if ( res > 0 ){
				alert("댓글 등록 완료!");
				
				getReplyList(dno);
				
			}else{
				alert("댓글 등록 실패!");
			}
		},
		error:function(){
			alert("댓글 등록 ajax 실패");
		}

	
	});
});

	

	
	
	
	
	
	
</script>



</head>
<body>

	<!-- header -->
	<%@ include file="../includes/header.jsp"%>
	
	<!-- 내용 -->
	<div class="container mt-3">
	
	<h1 class="mt-4">입양 일기</h1>
	
		
		<!-- 입양일기 리스트 반복하여 화면에 출력 -->
		<c:forEach items="${list }" var="dto">
		
			<div class="row">
		
			<div class="col-2"></div> <!-- 좌우 간격 맞추기 용도 -->
				
				<div class="col ms-4 my-3">
				
					<!-- 입양일기 카드(박스) 부분 -->
					<div class="card border-success mb-3 text-dark" style="width: 800px;">
						<div class="card-header bg-transparent border-success">${dto.mnick}</div>
						
						<!-- 입양일기 이미지(서버에 업로드된 이미지 화면출력) -->
						<img class="card-img-top" src="resources/${dto.diaryImg }">
						
						<ul class="list-group list-group-flush">
							<li class="list-group-item">
								<div class="row">
									<div class="col">
										<ion-icon name="heart-outline" style="font-size:25px;"></ion-icon>
										<ion-icon name="heart" style="font-size:25px;"></ion-icon>
										좋아요
									</div>
									<div class="col text-end">
										<ion-icon name="person-add-outline" style="font-size:25px;"></ion-icon>
										<ion-icon name="person-add" style="font-size:25px;"></ion-icon>
										팔로우
									</div>
								</div>
							</li>
						</ul>
						
						<div class="card-body text-dark" style="height: 100px;">
							<h5 class="card-title">${dto.dcontent }</h5>
							<p class="card-text">${dto.ddateToChar }</p>
						</div>
						
						<div class="card-footer bg-transparent border-success">
							<!--등록 박스랑 버튼 임시 주석처리 <form action="">
								<input type="text" style="width: 700px; height: 38px;">
								<button type="submit" class="btn btn-outline-success ms-1 float-end">등록</button>
							</form> -->
							
							<!-- 댓글 리스트 부분 -->
							<div id="replyListBox">
								<div id="${dto.dno }">
									<div class="d-grid gap-2">
									<button class="btn btn-success" id="replyBtn" type="button" value="${dto.dno }">댓글 보기</button>
								</div>
							</div>
							</div>
							
						</div>
					</div>
				
				
				</div>
				
			</div>
		
		</c:forEach>				



		<div id="scrollPrintHere"></div>
			
		
		
		
		
		
		
		
		
	
	</div>

</body>
</html>