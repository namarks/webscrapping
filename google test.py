#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 19 13:27:25 2017

@author: nickmarks
"""

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time
driver = webdriver.Chrome()
driver.get("https://www.netflix.com")

element = driver.find_element_by_link_text("Sign In")
element.click()

email = driver.find_element_by_name("email")
password = driver.find_element_by_name("password")

email.send_keys("smarkspdx@gmail.com")
password.send_keys("netflix0128")
password.submit()