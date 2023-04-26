package com.game.web.service;

import java.io.File;
import java.util.Random;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

@Component
@Service("mailSendService")
public class MailSendService {
	@Autowired
	private JavaMailSenderImpl mailSender;
	private int authNumber;
	
	// 난수 발생(여러분들 맘대러)
	
			public void makeRandomNumber() {
				// 난수의 범위 111111 ~ 999999 (6자리 난수)
				Random r = new Random();
				int checkNum = r.nextInt(888888) + 111111;
				System.out.println("인증번호 : " + checkNum);
				authNumber = checkNum;
			}
			
			
					//이메일 보낼 양식! 
			public String joinEmail(String email) {
				makeRandomNumber();
				String setFrom = "egame1234@naver.com"; // email-config에 설정한 자신의 이메일 주소를 입력 
				String toMail = email;
				String title = "회원 가입 인증 이메일 입니다."; // 이메일 제목 
				String content = 
						"<td\r\n" + 
						"  style=\"\r\n" + 
						"    width: 775px;\r\n" + 
						"    min-width: 775px;\r\n" + 
						"    font-size: 0pt;\r\n" + 
						"    line-height: 0pt;\r\n" + 
						"    padding: 0;\r\n" + 
						"    margin: 0;\r\n" + 
						"    font-weight: normal;\r\n" + 
						"  \"\r\n" + 
						">\r\n" + 
						"  <table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n" + 
						"    <!-- Main -->\r\n" + 
						"    <tbody>\r\n" + 
						"      <tr>\r\n" + 
						"        <td bgcolor=\"#070720\" style=\"padding: 80px\">\r\n" + 
						"          <table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n" + 
						"            <!-- Logo -->\r\n" + 
						"            <tbody>\r\n" + 
						"              <tr>\r\n" + 
						"                <td\r\n" + 
						"                  style=\"\r\n" + 
						"                    font-size: 0pt;\r\n" + 
						"                    line-height: 0pt;\r\n" + 
						"                    text-align: left;\r\n" + 
						"                    padding-bottom: 45px;\r\n" + 
						"                  \"\r\n" + 
						"                >\r\n" + 
						"                  <img\r\n" + 
						"                    src=\"cid:logo.png\"\r\n" + 
						"                    width=\"500\"\r\n" + 
						"                    height=\"200\"\r\n" + 
						"                    border=\"0\"\r\n" + 
						"                    alt=\"Steam\"\r\n" + 
						"                    loading=\"lazy\"\r\n" + 
						"                  />\r\n" + 
						"                </td>\r\n" + 
						"              </tr>\r\n" + 
						"              <!-- END Logo -->\r\n" + 
						"\r\n" + 
						"              <!-- All Content Exists within this table column -->\r\n" + 
						"              <tr>\r\n" + 
						"                <td>\r\n" + 
						"                  <table\r\n" + 
						"                    width=\"100%\"\r\n" + 
						"                    border=\"0\"\r\n" + 
						"                    cellspacing=\"0\"\r\n" + 
						"                    cellpadding=\"0\"\r\n" + 
						"                  >\r\n" + 
						"                    <tbody>\r\n" + 
						"                      <tr>\r\n" + 
						"                        <td\r\n" + 
						"                          style=\"\r\n" + 
						"                            font-size: 36px;\r\n" + 
						"                            line-height: 42px;\r\n" + 
						"                            font-family: Arial, sans-serif, 'Motiva Sans';\r\n" + 
						"                            text-align: left;\r\n" + 
						"                            padding-bottom: 30px;\r\n" + 
						"                            color: #bfbfbf;\r\n" + 
						"                            font-weight: bold;\r\n" + 
						"                          \"\r\n" + 
						"                        >\r\n" + 
						"                          EGame 이메일 인증\r\n" + 
						"                        </td>\r\n" + 
						"                      </tr>\r\n" + 
						"                    </tbody>\r\n" + 
						"                  </table>\r\n" + 
						"                  <table\r\n" + 
						"                    width=\"100%\"\r\n" + 
						"                    border=\"0\"\r\n" + 
						"                    cellspacing=\"0\"\r\n" + 
						"                    cellpadding=\"0\"\r\n" + 
						"                  >\r\n" + 
						"                    <tbody>\r\n" + 
						"                      <tr>\r\n" + 
						"                        <td\r\n" + 
						"                          style=\"\r\n" + 
						"                            font-size: 18px;\r\n" + 
						"                            line-height: 25px;\r\n" + 
						"                            font-family: Arial, sans-serif, 'Motiva Sans';\r\n" + 
						"                            text-align: left;\r\n" + 
						"                            color: #dbdbdb;\r\n" + 
						"                            padding-bottom: 30px;\r\n" + 
						"                          \"\r\n" + 
						"                        >\r\n" + 
						"                          홈페이지 방문을 환영합니다. 아래 인증번호를 입력해\r\n" + 
						"                          주세요.\r\n" + 
						"                        </td>\r\n" + 
						"                      </tr>\r\n" + 
						"                    </tbody>\r\n" + 
						"                  </table>\r\n" + 
						"                  <table\r\n" + 
						"                    width=\"100%\"\r\n" + 
						"                    border=\"0\"\r\n" + 
						"                    cellspacing=\"0\"\r\n" + 
						"                    cellpadding=\"0\"\r\n" + 
						"                  >\r\n" + 
						"                    <tbody>\r\n" + 
						"                      <tr>\r\n" + 
						"                        <td style=\"padding-bottom: 70px\">\r\n" + 
						"                          <table\r\n" + 
						"                            width=\"100%\"\r\n" + 
						"                            border=\"0\"\r\n" + 
						"                            cellspacing=\"0\"\r\n" + 
						"                            cellpadding=\"0\"\r\n" + 
						"                            bgcolor=\"#17191c\"\r\n" + 
						"                          >\r\n" + 
						"                            <tbody>\r\n" + 
						"                              <tr>\r\n" + 
						"                                <td\r\n" + 
						"                                  style=\"\r\n" + 
						"                                    padding-top: 30px;\r\n" + 
						"                                    padding-bottom: 30px;\r\n" + 
						"                                    padding-left: 56px;\r\n" + 
						"                                    padding-right: 56px;\r\n" + 
						"                                  \"\r\n" + 
						"                                >\r\n" + 
						"                                  <table\r\n" + 
						"                                    width=\"100%\"\r\n" + 
						"                                    border=\"0\"\r\n" + 
						"                                    cellspacing=\"0\"\r\n" + 
						"                                    cellpadding=\"0\"\r\n" + 
						"                                  >\r\n" + 
						"                                    <tbody>\r\n" + 
						"                                      <tr>\r\n" + 
						"                                        <td\r\n" + 
						"                                          style=\"\r\n" + 
						"                                            font-size: 48px;\r\n" + 
						"                                            line-height: 52px;\r\n" + 
						"                                            font-family: Arial, sans-serif,\r\n" + 
						"                                              'Motiva Sans';\r\n" + 
						"                                            color: #3a9aed;\r\n" + 
						"                                            font-weight: bold;\r\n" + 
						"                                            text-align: center;\r\n" + 
						"                                          \"\r\n" + 
						"                                        >" + authNumber + 
					    " </td>\r\n" + 
					    "                                      </tr>\r\n" + 
					    "                                    </tbody>\r\n" + 
					    "                                  </table>\r\n" + 
					    "                                </td>\r\n" + 
					    "                              </tr>\r\n" + 
					    "                            </tbody>\r\n" + 
					    "                          </table>\r\n" + 
					    "                        </td>\r\n" + 
					    "                      </tr>\r\n" + 
					    "                    </tbody>\r\n" + 
					    "                  </table>\r\n" + 
					    "                  <table\r\n" + 
					    "                    width=\"100%\"\r\n" + 
					    "                    border=\"0\"\r\n" + 
					    "                    cellspacing=\"0\"\r\n" + 
					    "                    cellpadding=\"0\"\r\n" + 
					    "                  >\r\n" + 
					    "                    <tbody></tbody>\r\n" + 
					    "                  </table>\r\n" + 
					    "                  <table\r\n" + 
					    "                    width=\"100%\"\r\n" + 
					    "                    border=\"0\"\r\n" + 
					    "                    cellspacing=\"0\"\r\n" + 
					    "                    cellpadding=\"0\"\r\n" + 
					    "                  >\r\n" + 
					    "                    <tbody>\r\n" + 
					    "                      <tr>\r\n" + 
					    "                        <td\r\n" + 
					    "                          style=\"\r\n" + 
					    "                            font-size: 18px;\r\n" + 
					    "                            line-height: 25px;\r\n" + 
					    "                            font-family: Arial, sans-serif, 'Motiva Sans';\r\n" + 
					    "                            text-align: left;\r\n" + 
					    "                            color: #7abefa;\r\n" + 
					    "                            padding-bottom: 40px;\r\n" + 
					    "                          \"\r\n" + 
					    "                        ></td>\r\n" + 
					    "                      </tr>\r\n" + 
					    "                    </tbody>\r\n" + 
					    "                  </table>\r\n" + 
					    "                </td>\r\n" + 
					    "              </tr>\r\n" + 
					    "            </tbody>\r\n" + 
					    "          </table>\r\n" + 
					    "        </td>\r\n" + 
					    "      </tr>\r\n" + 
					    "    </tbody>\r\n" + 
					    "  </table>\r\n" + 
					    "</td>\r\n"; //이메일 내용 삽입
						
				mailSend(setFrom, toMail, title, content);
				return Integer.toString(authNumber);
			}
			
			//이메일 전송 메소드
			public void mailSend(String setFrom, String toMail, String title, String content) { 
				MimeMessage message = mailSender.createMimeMessage();
				// true 매개값을 전달하면 multipart 형식의 메세지 전달이 가능.문자 인코딩 설정도 가능하다.
				try {
					MimeMessageHelper helper = new MimeMessageHelper(message,true,"utf-8");
					helper.setFrom(setFrom);
					helper.setTo(toMail);
					helper.setSubject(title);
					// true 전달 > html 형식으로 전송 , 작성하지 않으면 단순 텍스트로 전달.
					helper.setText(content,true);
					FileSystemResource file = new FileSystemResource(new File("C:\\project\\finalproject\\egame\\src\\main\\webapp\\WEB-INF\\views\\resources\\icon\\logo.png"));
					helper.addInline("logo.png", file);
					mailSender.send(message);
				} catch (MessagingException e) {
					e.printStackTrace();
				}
			}
	
			
	
	
	
}
