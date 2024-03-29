package com.jee.genesis.member.controller;

import java.text.DecimalFormat;
import java.text.Format;
import java.util.ArrayList;
import java.util.Random;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.jee.genesis.member.model.service.MemberService;
import com.jee.genesis.member.model.vo.CertVO;
import com.jee.genesis.member.model.vo.Member;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.exception.NurigoMessageNotReceivedException;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.service.DefaultMessageService;


@Controller
public class MemberController {

	@Autowired
	private MemberService memberService;
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	public static final String APIKEY = "NCSW02HP7JEZPA4F";
	public static final String SERVICEKEY = "AXCN1TUXEGERFCHP6NIRC4DIBAZHAH2S";
	public static final String PHONE = "01040718816";
	
	@Autowired
	private JavaMailSender sender;
	
	// -------------------------- 화면연결
	@GetMapping("login-page")
	public String loginPage() {
		return "member/loginPage";
	}
	@GetMapping("member-login")
	public String loginForm() {
		return "member/loginForm";
	}
	@GetMapping("member-enroll")
	public String enrollForm() {
		return "member/enrollForm";
	}
	@GetMapping("admin")
	public String webAdmin() {
		return "member/adminPage";
	}
	@GetMapping("admin-enroll")
	public String adminEnroll() {
		return "member/adminEnrollForm";
	}
	
	
	// --------------------- 휴대폰인증 메세지
	@ResponseBody
	@PostMapping(value="check-phone-meessage", produces="application/json; charset=UTF-8")
	public String sendPhoneCheckMessage(String memPhone) {
		DefaultMessageService messageService =  NurigoApp.INSTANCE.initialize(APIKEY, 
																			  SERVICEKEY, 
																			  "https://api.coolsms.co.kr");
		int randomNum = (int)((Math.random()*(9000)) + 1000);
		
		Message message = new Message();
		message.setFrom(PHONE);
		message.setTo(memPhone);
		
		message.setText("인증번호 : ["+randomNum +"] 입니다.\n절대 타인에게는 알려주지 마세요.");

		try {
		  messageService.send(message);
		} catch (NurigoMessageNotReceivedException exception) {
		  System.out.println(exception.getFailedMessageList());
		  System.out.println(exception.getMessage());
		} catch (Exception exception) {
		  System.out.println(exception.getMessage());
		}
        return new Gson().toJson(randomNum);
	}
	
	// ------------------------ 메일인증
	@ResponseBody
	@GetMapping(value="duplicate-check", produces="application/json; charset=UTF-8")
	public String emailCheck(String memEmail) {
		
		String result = "";
		
		if(memberService.emailCheck(memEmail) > 0) {
			result = "N";
		} else {
			result = "Y";
		}
		return new Gson().toJson(result);
	}
	
	
	@ResponseBody
	@GetMapping(value="mail-check", produces="application/json; charset=UTF-8")
	public String sendMailCheck(String memEmail, HttpServletRequest request) throws MessagingException {
		
		MimeMessage message = sender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
		String ip = request.getRemoteAddr();
		
		Random r = new Random();
		int i = r.nextInt(100000);
		Format f = new DecimalFormat("000000");
		String secret = f.format(i);
		
		CertVO certVo = CertVO.builder().who(ip).secret(secret).build();
		
		helper.setTo(memEmail);
		helper.setSubject("회원가입 인증번호입니다.");
		helper.setText("인증번호 : " +secret+"\n");
		
		sender.send(message);
		
		return new Gson().toJson(secret);
	}
	
	@ResponseBody
	@GetMapping(value="enrollMember", produces="application/json; charset=UTF-8")
	public String insertMember(Member m) {
		String encPwd = bcryptPasswordEncoder.encode(m.getMemPwd());
		m.setMemPwd(encPwd);
		
		String message = "";
		
		if(memberService.insertMember(m)>0) {
			message = "success";
		} else {
			message = "error";
		}
		return new Gson().toJson(message);
	}
	
	@ResponseBody
	@GetMapping(value="enrollAdmin", produces="application/json; charset=UTF-8")
	public String insertAdmin(Member m) {
		String encPwd = bcryptPasswordEncoder.encode(m.getMemPwd());
		m.setMemPwd(encPwd);
		
		String message = "";
		
		if(memberService.insertAdmin(m)>0) {
			message = "success";
		} else {
			message = "error";
		}
		return new Gson().toJson(message);
	}
	
	@RequestMapping("login")
	public ModelAndView login(Member m, HttpSession session, ModelAndView mv) {
		
		Member loginUser = memberService.loginMember(m);
		
		if(loginUser != null && bcryptPasswordEncoder.matches(m.getMemPwd(), loginUser.getMemPwd())) {// 로그인 성공
			session.setAttribute("loginUser", loginUser);
			mv.setViewName("redirect:/");
		} else {// 로그인 실페 => 
			mv.addObject("errorMsg", "아이디와 비밀번호가 일치하지 않습니다.")
			  .setViewName("common/errorPage");
		}
		return mv;
	}
	
	@ResponseBody
	@GetMapping(value="searchMember", produces="application/json; charset=UTF-8")
	public String searchMember(String memName){
		
		ArrayList<Member> mem = memberService.searchMember(memName);
		
		return new Gson().toJson(mem);
	}
	
	@ResponseBody
	@PostMapping(value="finalCheck", produces="application/json; charset=UTF-8")
	public String finalCheck(Member m){
		
		Member buyMember = memberService.buyMember(m);
		
		String message ="";
		if(buyMember != null && bcryptPasswordEncoder.matches(m.getMemPwd(), buyMember.getMemPwd())) {// 로그인 성공
			message ="Y";
		} else {
			message ="N";
		}
		
		return new Gson().toJson(message);
	}
	
	
}
