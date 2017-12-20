from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time
driver = webdriver.Chrome()
driver.get("https://www.aa.com/loyalty/login")

loginId = driver.find_element_by_name("loginId")
lastName = driver.find_element_by_name("lastName")
password = driver.find_element_by_name("password")

loginId.send_keys("nmarkspdx@gmail.com")
lastName.send_keys("Marks")
password.send_keys("Billy1793")

time.sleep(2)
driver.find_element_by_name("_button_login").click()

