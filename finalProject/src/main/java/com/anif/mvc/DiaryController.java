package com.anif.mvc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.anif.mvc.diary.biz.DiaryBiz;
import com.anif.mvc.diary.dto.DiaryDto;
import com.anif.mvc.diary.dto.DiaryReplyDto;
import com.anif.mvc.member.dto.MemberDto;

@Controller
public class DiaryController {
	
	//로그 사용 위한 logger 
	private static final Logger logger = LoggerFactory.getLogger(MypageController.class);
	
	@Autowired
	private DiaryBiz biz;
	
	
	@RequestMapping(value = "/diaryList.do", method = RequestMethod.GET)
	public String diary(Model model, HttpSession session) {
		logger.info("Diary SELECT LIST");
		
		MemberDto memberDto = (MemberDto) session.getAttribute("login");

		
		model.addAttribute("list", biz.selectList());
		model.addAttribute("memberDto", memberDto);
		
		
		return "diary/diaryList";
	}
	
	
	//무한스크롤 관련 컨트롤러 메소드
	@RequestMapping(value = "/diaryListScroll.do", method = RequestMethod.GET)
	@ResponseBody
	public List<DiaryDto> diaryListScroll(@RequestParam Map<String, String> number) {
		
		int startNumber = Integer.parseInt(number.get("startNumber"));
		int endNumber = Integer.parseInt(number.get("endNumber"));
		
		List<DiaryDto> list = biz.diaryListScroll(startNumber, endNumber);
		
		return list; 
	}
	
	
	
	//댓글, 댓글의 답글 관련
	@ResponseBody
	@RequestMapping(value = "/DRselectList.do", method = RequestMethod.POST)
	public List<DiaryReplyDto> DRselectList(@RequestBody DiaryReplyDto dto){
		System.out.println(dto);
		logger.info("Diary Reply SELECT LIST");
		
		List<DiaryReplyDto> list = null;
		list = biz.DRselectList(dto.getDno());
		
		System.out.println(list);
		
		return list;
	}
	
	//댓글 등록
	@ResponseBody
	@RequestMapping(value = "/DRwrite.do", method = RequestMethod.POST)
	public int DRwrite(@RequestBody DiaryReplyDto dto, HttpSession session){
		System.out.println(dto);
		logger.info("Diary Reply INSERT");
		
		MemberDto memberDto = (MemberDto) session.getAttribute("login");
		dto.setMno(memberDto.getmNo());
		System.out.println("작성자 설정 한 dto: "+dto);
		
		int res = biz.DRinsert(dto);
		
		return res;
	}
	
	//댓글 삭제
	@ResponseBody
	@RequestMapping(value = "/DRdelete.do", method = RequestMethod.POST)
	public int DRdelete(@RequestBody DiaryReplyDto dto, HttpSession session){
		System.out.println(dto);
		logger.info("Diary Reply DELETE");
		
		int res = 0;
		MemberDto memberDto = (MemberDto) session.getAttribute("login");
		DiaryReplyDto originReplyDto = biz.DRselectOne(dto.getDrno());
		
		
		if( originReplyDto.getMno() == memberDto.getmNo() ) {
			//댓글의 mno와(작성자) 로그인 한 사람의 mno가 같다면 삭제
			res = biz.DRdelete(dto.getDrno());
			
			if(res>0) {
				//댓글 삭제가 성공했다면 dno값을 넘겨준다 (어차피 0보다 클거고, 댓글 목록 재조회해야하니까)
				return originReplyDto.getDno();
			}
			
		}else{
			//댓글의 mno와(작성자) 로그인 한 사람의 mno가 같다면 반려
			return 0;
		}
		
		return res;
	}
	
	
	//답글 등록
	@RequestMapping(value = "/DRanswerWrite.do", method = RequestMethod.POST)
	@ResponseBody
	public int DRanswerWrite(@RequestBody DiaryReplyDto dto, HttpSession session) {
		logger.info("Diary Reply DRanswerWrite");
		
		//작성자 mno 를 댓글dto에 세팅해주기
		MemberDto memberDto = (MemberDto) session.getAttribute("login");
		dto.setMno(memberDto.getmNo());
		
		int res = biz.DRanswerInsert(dto);
		
		//본 글의 dno 를 조회해서 화면의 ajax로 리턴, 화면에서 getReplyList(dno) 실행
		DiaryReplyDto originReplyDto = biz.DRselectOne(dto.getDrno());
		if(res>0) {
			return originReplyDto.getDno();
		}else {
			return 0;
		}
		
	}
	
	
	@ResponseBody
	@RequestMapping(value="/like.do", method=RequestMethod.POST)
	public int like(@RequestBody DiaryDto dto, HttpSession session){
		logger.info("like ");
		
		MemberDto memberDto = (MemberDto) session.getAttribute("login");
		dto.setMno(memberDto.getmNo());
		
		
		Map<String, Object> m = new HashMap<>();
		m.put("dno", dto.getDno());
		m.put("mno", dto.getMno());
		
		int res = biz.recCheck(m);
		
		if(res == 0) {
			int insert = biz.recInsert(m);
			int Update = biz.likeUpdate(m); 
			
			
			if(insert > 0 || Update > 0) {
				System.out.println("좋아요 성공!");
			}
			
			return dto.getDno();
			
		}else {
			int Delete = biz.recDelete(m);
			int Update = biz.likeUpdate(m); 
			
			if(Delete > 0 || Update > 0) {
				System.out.println("좋아요 취소 성공!");
			}
			
			return dto.getDno();
			
		}
		
	}
	
	@ResponseBody
	@RequestMapping(value="/RecCount.do", method=RequestMethod.POST)
	public int RecCount(@RequestBody DiaryDto dto, HttpSession session){
		logger.info("RecCount");
		System.out.println("RecCount Num: " + dto.getDno());
	
		DiaryDto likecnt = biz.recCount(dto.getDno());
		
		System.out.println(likecnt.getDiaryLikeCnt());
		
		
		return likecnt.getDiaryLikeCnt();
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	

}
