#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
import datetime
import time
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.header import Header
from bs4 import BeautifulSoup

NOTICE_SOURCE = {"Zhongsu":["海关总署", "http://www.customs.gov.cn/customs/302249/302266/302268/index.html", 7],
              "Nanjing":["南京海关", "http://nanjing.customs.gov.cn/nanjing_customs/589281/589283/589284/index.html", 7],
              "Nanning":["南宁海关", "http://nanning.customs.gov.cn/nanning_customs/600333/600348/600337/index.html", 10],
              "Huangpu":["黄埔海关", "http://huangpu.customs.gov.cn/huangpu_customs/536775/536799/536800/index.html", 15],
              "Guangzhou":["广州海关", "http://guangzhou.customs.gov.cn/guangzhou_customs/381558/2478416/2478417/index.html", 10],
              "Kunming":["昆明海关", "http://kunming.customs.gov.cn/kunming_customs/611308/611311/611312/index.html", 10],
              "Qingdao":["青岛海关", "http://qingdao.customs.gov.cn/qingdao_customs/406484/406513/index.html", 10],
              "Hefei":["合肥海关", "http://hefei.customs.gov.cn/hefei_customs/479573/479574/index.html", 10]
            }

data = []
cdate = datetime.datetime.strptime("2018-4-4",'%Y-%m-%d')

def GetNoticePage(URL, NUMBER_PER_PAGE):
    BASE_URL = "http://" + URL.split("/")[1] + URL.split("/")[2]
    NEXT_PAGE_URL = ""

    res = requests.get(URL)
    while not res:
      time.sleep(5)
      res = requests.get(URL)
      
    res.encoding='utf-8'
    soup = BeautifulSoup(res.text,"html5lib")

    # 获取下一页连接
    for j in soup.select(".easysite-page-wrap"):
        NEXT_PAGE_URL = BASE_URL + j.select("a")[2].get("tagname")

    print("NEXT_PAGE: ", NEXT_PAGE_URL)

    # 获取新闻清单
    for i in soup.select(".conList_ul"):
        for num in range(0, NUMBER_PER_PAGE):
            i_date = datetime.datetime.strptime(i.select("span")[num].text,'%Y-%m-%d')
            if i_date > cdate:
                data.append('<li><a href="' + BASE_URL + i.select("a")[num].get("href") + '" istitle="true" onclick="void(0)" target="_blank" title="' + i.select("a")[num].text + '">' +  i.select("a")[num].text +'</a><span>' + i.select("span")[num].text + '</span></li>')
                if num == NUMBER_PER_PAGE - 1:
                    GetNoticePage(NEXT_PAGE_URL, NUMBER_PER_PAGE)

def GetNotice():

    for each_custom in NOTICE_SOURCE:
        TITLE = NOTICE_SOURCE[each_custom][0]
        URL = NOTICE_SOURCE[each_custom][1]
        NUMBER_PER_PAGE = NOTICE_SOURCE[each_custom][2]

        data.append("<h2>" + TITLE + "</h2>")

        GetNoticePage(URL, NUMBER_PER_PAGE)

def SendMail(data,cdate,type):
    smtpserver = "mail.test.com"
    username = "zsls@test.com"
    password= "zsls"
    sender= "zsls@test.com"
    receiver=["111@test.com"]

    string=""
    subject=""
    #通过Header对象编码的文本，包含utf-8编码信息和Base64编码信息。以下中文名测试ok
    if type == 0 :
        subject = "昨日海关公告汇总" + "(" + cdate.strftime('%Y-%m-%d') + ")"
    elif type == 1 :
        subject = "上周海关公告汇总"
    else :
        subject = "上月海关公告汇总"

    subject=Header(subject, "utf-8").encode()

    #构造邮件对象MIMEMultipart对象
    #下面的主题，发件人，收件人，日期是显示在邮件页面上的。
    msg = MIMEMultipart("mixed")
    msg["Subject"] = subject
    msg["From"] = sender
    msg["To"] = ";".join(receiver)
    #msg['Date']='2012-3-16'

    #构造html
    for i in data:
        string = string + i
    text_html = MIMEText(string,'html', 'utf-8')
    msg.attach(text_html)

    #发送邮件
    smtp = smtplib.SMTP()
    smtp.connect('mail.test.com')
    #我们用set_debuglevel(1)就可以打印出和SMTP服务器交互的所有信息。
    #smtp.set_debuglevel(1)
    smtp.login(username, password)
    smtp.sendmail(sender, receiver, msg.as_string())
    smtp.quit()

if __name__ == "__main__":
    GetNotice()
    #print(data)
    string=""
    for i in data:
        string = string + i
    print(string)
    # 每天发送日报
    # raw_date="2019-6-1"
    # cdate=datetime.datetime.now()
    # raw_date=cdate.strftime('%Y-%m-%d')
    # cdate=datetime.datetime.strptime(raw_date,'%Y-%m-%d')
