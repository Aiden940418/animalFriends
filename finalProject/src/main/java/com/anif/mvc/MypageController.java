package com.anif.mvc;

import java.io.File;
import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.anif.mvc.common.image.UploadFileUtils;
import com.anif.mvc.common.pagination.Criteria;
import com.anif.mvc.common.pagination.PageMaker;
import com.anif.mvc.diary.biz.DiaryBiz;
import com.anif.mvc.diary.dto.DiaryDto;
import com.anif.mvc.member.dto.MemberDto;
import com.anif.mvc.qnaBoard.biz.QnaBoardBiz;
import com.anif.mvc.qnaBoard.dto.QnaBoardDto;

@Controller
public class MypageController {
	
	//로그 사용 위한 logger 
	private static final Logger logger = LoggerFactory.getLogger(MypageController.class);
	
	@Autowired
	private QnaBoardBiz biz;
	
	@Autowired
	private DiaryBiz diaryBiz;
	
	@Resource(name="uploadPath")
	private String uploadPath;
	
	@RequestMapping("/chattingList.do")
	public String chatList() {
		
		
		return "mypage/mypage_chattingList";
	}
	
	@RequestMapping("/chattingDetail.do")
	public String chatDetail() {
		
		
		return "mypage/mypage_chattingDetail";
	}
	
	// Diary Start 
	
	@RequestMapping(value = "/mydiary.do", method = RequestMethod.GET)
	public String myDiary(Model model) {
		
		logger.info("MyDiary SELECT LIST");
		
		model.addAttribute("list", diaryBiz.MyDselectList());
		
		return "mypage/mypage_mydiary";
	}
	
	
	@RequestMapping("/mydiaryDetail.do")
	public String mydiaryDetail() {
		
		return "mypage/mypage_mydiaryDetail";
	}
	
	@RequestMapping("/mydiaryWriteForm.do")
	public String mydiaryWriteForm() {
		return "mypage/mypage_mydiaryWriteForm";
	}
	
	@RequestMapping("/mydiaryWriteRes.do")
	public String mydiaryWriteRes(DiaryDto dto, HttpSession session, @RequestParam(value = "file", required = false) MultipartFile file, Model model) throws IOException, Exception {
		logger.info("My Diary INSERT");
		

		//현재 로그인 되어있는 계정의 회원번호를 가져와서 dto에 세팅해주기
		MemberDto memberDto = (MemberDto) session.getAttribute("login");
		dto.setMno(memberDto.getmNo());
		
		String imgUploadPath = uploadPath + File.separator + "imgUpload";
		String ymdPath = UploadFileUtils.calcPath(imgUploadPath);
		String fileName = null;
		
		if(file.getOriginalFilename() != null && file.getOriginalFilename() != "") {
			fileName = UploadFileUtils.fileUpload(imgUploadPath, file.getOriginalFilename(), file.getBytes(), ymdPath); 
		} else {
			fileName = uploadPath + File.separator + "images" + File.separator + "none.png";
		}
		
		dto.setDiaryImg(File.separator + "imgUpload" + ymdPath + File.separator + fileName);
		dto.setDiaryThumbImg(File.separator + "imgUpload" + ymdPath + File.separator + "s" + File.separator + "s_" + fileName);
	
		
		int res = diaryBiz.insert(dto);

		if (res > 0) { // 글 insert 성공 시
			model.addAttribute("msg", "글 등록 성공!");
			model.addAttribute("url", "/diaryList.do");
		} else {  //글 insert 실패 시
			model.addAttribute("msg", "글 등록 실패!");
			model.addAttribute("url", "/mydiaryWriteForm.do");
		}
		
		return "/mypage/alertPage";
	}
	
	@RequestMapping("/mydiaryUpdateForm.do")
	public String mydiaryUpdateForm() {
		return "mypage/mypage_mydiaryUpdateForm";
	}
	
	
	// Diary End
	
	
	//Adopt Start 
	
	@RequestMapping("/myAdoptList.do")
	public String myAdoptList() {
		
		
		return "mypage/mypage_myadoptList";
	}
	
	@RequestMapping("/myAdoptUpdateForm.do")
	public String myAdoptUpdateForm() {
		
		return "mypage/mypage_myadoptWriteForm";
	}
	
	
	//Adopt End 
	@RequestMapping("/myCartList.do")
	public String myCartList() {
		
		
		return "mypage/mypage_mycartList";
	}
	
	@RequestMapping("/myGoodsBuyList.do")
	public String myGoodsBuyList() {
		
		return "mypage/mypage_mygoodsBuyList";
	}
	

	
	
	@RequestMapping("/myMemberModityPw.do")
	public String myMemberModityPw() {
		
		
		return "mypage/mypage_memberModifyPWCheck";
	}
	
	
	//QnA Start
	
	//페이징 적용한 Select List
	@RequestMapping("/myQnaList.do")
	public String myQnaList(Model model, Criteria cri) {
		logger.info("QnA SELECT LIST");
		
		model.addAttribute("list", biz.selectList(cri));
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		int listCount = biz.listCount();
		pageMaker.setTotalCount(listCount);
		
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("listCount", listCount);
		
		return "/mypage/mypage_qnaList";
	}
	
	
	@RequestMapping("/myQnaDetail.do")
	public String myQnaDetail(Model model, int qno) {
		logger.info("QnA SELECT ONE");
		model.addAttribute("dto", biz.selectOne(qno));
		
		return "/mypage/mypage_qnaDetail";
	}
	
	@RequestMapping("/myQnaWriteForm.do")
	public String myQnaWriteForm() {
		logger.info("QnA INSERT FORM");
		
		return "/mypage/mypage_qnaWrite";
	}
	
	@RequestMapping("/myQnaWriteRes.do")
	public String myQnaWriteRes(QnaBoardDto dto, HttpSession session, Model model) throws IOException {
		logger.info("QnA INSERT");
		
		//현재 로그인 되어있는 계정의 회원번호를 가져와서 dto에 세팅해주기
		MemberDto memberDto = (MemberDto) session.getAttribute("login");
		dto.setMno(memberDto.getmNo());
		
		int res = biz.insert(dto);

		if (res > 0) { // 글 insert 성공 시
			model.addAttribute("msg", "글 등록 성공!");
			model.addAttribute("url", "/myQnaList.do");
		} else {  //글 insert 실패 시
			model.addAttribute("msg", "글 등록 실패!");
			model.addAttribute("url", "/myQnaWriteForm.do");
		}
		
		return "/mypage/alertPage";
	}
	
	@RequestMapping("/myQnaUpdateForm.do")
	public String myQnaUpdateForm(Model model, int qno) {
		logger.info("QnA UPDATE FORM");
		
		model.addAttribute("dto", biz.selectOne(qno));

		return "/mypage/mypage_qnaUpdateForm";
	}
	
	@RequestMapping("/myQnaUpdateRes.do")
	public String myQnaUpdateRes(QnaBoardDto dto) {
		logger.info("QnA UPDATE RESULT");
		
		int res = biz.update(dto);
		
		if(res>0) {
			return "redirect:myQnaDetail.do?qno="+dto.getQno();
		}else {
			return "redirect:myQnaUpdateForm.do?qno="+dto.getQno();
		}
		
		
	}
	
	@RequestMapping("/myQnaDelete.do")
	public String myQnaDelete(int qno, int qgroupno) {
		logger.info("QnA DELETE");
		
		int res = biz.delete(qgroupno);
		
		if(res>0) {
			return "redirect:myQnaList.do"; 
		}else {
			return "redirect:myQnaDetail.do?qno="+qno;
		}
		
	}
	
	//QnA End
	
	
	
}
