package com.game.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.game.web.dao.UserDao;
import com.game.web.model.Friend;
import com.game.web.model.Product;
import com.game.web.model.User;

@Service("userService")
public class UserService
{
	private static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private UserDao userDao;
	
	//유저 파일 저장 경로
	@Value("#{env['user.upload.save.dir']}") 
	private String USER_UPLOAD_SAVE_DIR;
	
	//회원가입
	public int userInsert(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.userInsert(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userInsert Exception", e);
		}
		
		return count;
	}
	
	//회원정보 수정
	public int userUpdate(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.userUpdate(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userUpdate Exception", e);
		}
		
		return count;
	}
	
	//아이디 조회
	public User userSelect(String userId)
	{
		User user = null;
		
		try
		{
			user = userDao.userSelect(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userSelect Exception", e);
		}
		
		return user;
	}
	
	//유저 아이디 체크
	public long userCheck(String userId)
	{
		long count = 0;
		
		try
		{
			count = userDao.userCheck(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userCheck Exception", e);
		}
		
		return count;
	}
	
	//사업자번호 중복 체크
	public User businessNumCheck(String businessNum)
	{
		User userBusinessNum = null;
		
		try
		{
			userBusinessNum = userDao.businessNumCheck(businessNum);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userSelect Exception", e);
		}
		
		return userBusinessNum;
	}
	
	//판매게임 정보
	public List<Product> saleSelect(Product product) {
		
		List<Product> list = null;
		
		try
		{
			list = userDao.saleSelect(product);
		}
		catch(Exception e)
		{
			logger.error("[UserService] saleSelect Exception", e);
		}
		
		return list;
	}
	
	//게임 판매정지
	public int waitStatusPrd(Product product) {
		
		int count = 0;
		
		try
		{
			count = userDao.waitStatusPrd(product);
		}
		catch(Exception e)
		{
			logger.error("[UserService] waitStatusPrd Exception", e);
		}
		
		return count;
	}
		
	//마이페이지 판매게임
	public int countSaleGame(String userId) {
	
		int count = 0;
		
		try
		{
			count = userDao.countSaleGame(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] countSaleGame Exception", e);
		}
		
		return count;
	}

	//마이페이지 보유게임
	public int countGame(String userId) {
		
		int countGame = 0;
		
		try
		{
			countGame = userDao.countGame(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] countGame Exception", e);
		}
		
		return countGame;
	}

	//마이페이지 사용포인트(포인트지출합계)
	public long expenditure(String userId) {
		
		long expenditure = 0;
		
		try
		{
			expenditure = userDao.expenditure(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] expenditure Exception", e);
		}
		
		return expenditure;
	}
	
	//마이페이지 사용포인트(포인트환불합계)
	public long expenditureRefund(String userId) {
		
		long expenditureRefund = 0;
		
		try
		{
			expenditureRefund = userDao.expenditureRefund(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] expenditureRefund Exception", e);
		}
		
		return expenditureRefund;
	}

	//마이페이지 장바구니 보유 갯수
	public int countCart(String userId) {
		
		int countCart = 0;
		
		try
		{
			countCart = userDao.countCart(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] countCart Exception", e);
		}
		
		return countCart;
	}

	//마이페이지 친구 수
	public int countFriend(String userId) {

		int countFriend = 0;
		
		try
		{
			countFriend = userDao.countFriend(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] countFriend Exception", e);
		}
		
		return countFriend;
	}

	//마이페이지 문의 작성수
	public int countQna(String userId) {
		
		int countQna = 0;
		
		try
		{
			countQna = userDao.countQna(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] countQna Exception", e);
		}
		
		return countQna;
	}

	
	//마이페이지 문의 답변 수
	public int countQnaReview(String userId) {
		
		int countQnaReview = 0;
		
		try
		{
			countQnaReview = userDao.countQnaReview(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] countQnaReview Exception", e);
		}
		
		return countQnaReview;
	}

	//리뷰 작성 수
	public int countReview(String userId) {
		
		int countReview = 0;
		
		try
		{
			countReview = userDao.countReview(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] countReview Exception", e);
		}
		
		return countReview;
	}

	//신고 작성 수
	public int countReport(String userId) {

		int countReport = 0;
		
		try
		{
			countReport = userDao.countReport(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] countReport Exception", e);
		}
		
		return countReport;
	}

	//신고 처리 수
	public int countCompleteReport(String userId) {

		int countCompleteReport = 0;
		
		try
		{
			countCompleteReport = userDao.countCompleteReport(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] countCompleteReport Exception", e);
		}
		
		return countCompleteReport;
	}
	
	//친구페이지 친구조회
	public List<Friend> friendList(Friend friend) {
		
		List<Friend> friendList = null;
		
		try
		{
			friendList = userDao.friendList(friend); 
		}
		catch(Exception e)
		{
			logger.error("[UserService] friendList Exception", e);
		}
		
		return friendList;
	}

	//친구페이지 사이드
	public List<Friend> friendSide(String cookieUserId) {
		
		List<Friend> friendSide = null;
		
		try
		{
			friendSide = userDao.friendSide(cookieUserId); 
		}
		catch(Exception e)
		{
			logger.error("[UserService] friendSide Exception", e);
		}
		
		return friendSide;
	}

	//friendId(상대)의 frStatus 조회
	public String frStatus(Friend friend) {
		
		String frStatus = "";
		
		try
		{
			frStatus = userDao.frStatus(friend);
		}
		catch(Exception e)
		{
			logger.error("[UserService] frStatus Exception", e);
		}
		
		return frStatus;
	}

	//friendId(기준) - userId 로 frStatus - 2(수락대기) INSERT
	public int insertAcceptFrStatus(Friend friend) {
		
		int count = 0;
		
		try
		{
			count = userDao.insertAcceptFrStatus(friend);
		}
		catch(Exception e)
		{
			logger.error("[UserService] insertAcceptFrStatus Exception", e);
		}
		
		return count;
	}

	//cookieUserId(기준) - frUserId 로 frStatus - 1(신청) INSERT
	public int insertProposalFrStatus(Friend friend) {
		
		int count = 0;
		
		try
		{
			count = userDao.insertProposalFrStatus(friend);
		}
		catch(Exception e)
		{
			logger.error("[UserService] insertProposalFrStatus Exception", e);
		}
		
		return count;
	}

	//friendId(기준) - userId 로 frStatus - 4(친구) UPDATE
	public int updateRegFrStatus(Friend friend) {
		
		int count = 0;
		
		try
		{
			count = userDao.updateRegFrStatus(friend);
		}
		catch(Exception e)
		{
			logger.error("[UserService] updateRegFrStatus Exception", e);
		}
		
		return count;
	}

	//cookieUserId(기준) - frUserId 로 frStatus - 4(친구) UPDATE
	public int updateMyRegFrStatus(Friend friend) {
		
		int count = 0;
		
		try
		{
			count = userDao.updateMyRegFrStatus(friend);
		}
		catch(Exception e)
		{
			logger.error("[UserService] updateMyRegFrStatus Exception", e);
		}
		
		return count;
	}
	
	//friendId(기준) - userId 로 TBL_FRIEND DELETE
	public int deleteFrStatus(Friend friend) {
		
		int count = 0;
		
		try
		{
			count = userDao.deleteFrStatus(friend);
		}
		catch(Exception e)
		{
			logger.error("[UserService] deleteFrStatus Exception", e);
		}
		
		return count;
	}

	//cookieUserId(기준) - frUserId 로 TBL_FRIEND DELETE	
	public int deleteMyFrStatus(Friend friend) {
		
		int count = 0;
		
		try
		{
			count = userDao.deleteMyFrStatus(friend);
		}
		catch(Exception e)
		{
			logger.error("[UserService] deleteMyFrStatus Exception", e);
		}
		
		return count;
	}	
	
	//프로필 변경
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int updateImg(User user) throws Exception
	{
		int count = 0;
		
		if(user.getUserImg() != "default.jpg")
		{									
			count = userDao.updateImg(user);
		}
		else
		{									
			count = userDao.updateImgToDf(user.getUserId());
		}
		
		return count;
	}

	//userImg default로 변경
	public int updateImgToDf(String userId) {
		
		int count = 0;
		
		count = userDao.updateImgToDf(userId);
		
		return count;
	}
	
	//포인트 업데이트
	public int updatePoint(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.updatePoint(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] updatePoint Exception", e);
		}
		return count;
	}
	
	//이메일 중복체크
	public int userEmailCheck(String userEmail)
	{
		int count = 0;
		
		try
		{
			count = userDao.userEmailCheck(userEmail);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userEmailCheck Exception", e);
		}
		
		return count;
	}
}
