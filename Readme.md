
<h1 align="center">Sh0zack 1.0</h1>
<div align="center">
 <img src='./assests/67732f97-297a-4048-9dc5-f64dad5c009c.png' altsrc ='https://github.com/sh0z3n/Sh0zack/assests/67732f97-297a-4048-9dc5-f64dad5c009c.png'height='330' >
</div>
<div align="center">
  <b>Sh0zack</b>  : Advanced Penetration Testing Framework | Powered by Bash <br>
  
  Supports  <b><i> THM & HTB Machines, CTFs, and Real-World Pentesting</i></b><br>
  <br>
  [![GitHub Forks](https://img.shields.io/github/forks/sh0z3n/Sh0zack?style=for-the-badge&labelColor=blue&color=violet&logo=github)](https://github.com/sh0z3n/Sh0zack/fork)
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/sh0z3n/Sh0zack?style=for-the-badge&labelColor=blue&color=violet">
  <img alt="Static Badge" src="https://img.shields.io/badge/Tested--on-Linux-violet?style=for-the-badge&logo=linux&logoColor=black&labelColor=blue">
  <img alt="Static Badge" src="https://img.shields.io/badge/Bash-violet?style=for-the-badge&logo=gnubash&logoColor=black&labelColor=blue">
  <p></p>
    <a href="https://github.com/sh0z3n/Sh0zack?tab=readme-ov-file#installation">Install</a>
  <span> • </span>
       	<a href="https://github.com/sh0z3n/Sh0zack?tab=readme-ov-file#documentation">Documentation</a>
  <span> • </span>
	<a href="https://github.com/sh0z3n/Sh0zack?tab=readme-ov-file#usage">Usage</a>
  <p></p>
</div>

## 🗂️ Documentation

###  FEATURES : ⚙️
<!--- 
maybe this will be included in a c2 server set up  , very sooooon ?
--->

| Feature                     | Description                                                                                          |
|-----------------------------|------------------------------------------------------------------------------------------------------|
| **Port Scanning**            | Scan open ports using Nmap, Rustscan, or the Sh0zack Port Scan Tool.                                  |
| **DNS Enumeration**             | Discover subdomains with Gobuster or the Advanced Sh0zack DNS Scan Tool.                              |
| **Directory Fuzzer**       | Enumerate directories and files using Gobuster, WFuzz, or the Sh0zack Directory Scan Tool.            |
| **Brute Force**              | Perform brute force attacks with Hydra or the Sh0zack Brute Force Tool.                               |
| **Listener Setter**          | Code to set up a listener to catch reverse shells.                                                     |
| **Privilege Escalation Check**| Custom binary ( **only for linux systems** ) to identify potential privilege escalation vectors.                            |
| **Shell Generator**          | Generate various types of reverse and bind shells (e.g., Bash, Python, Netcat, PHP, etc.).            |
| **Decrypting Tools**         | Decrypt encoded data using multiple methods.                                                         |
| **Web Scanner**              | Scan websites for vulnerabilities using Nikto, OWASP ZAP, Skipfish, WPScan, or CMSmap.                |
| **AI Chat**                  | integrated AI tool to chat about pentesting

###  MODULES  : 📦
* The Logic of this tool is also including providing each functionality to be independent and easy to use without the need of other tools

#### Network Reconnaissance :
* Use Nmap,Smb , Rustscan, or Sh0zack's custom tool to scan a network
```bash
nmap -sV -Pn <target-ip>
rustscan -a <target-ip>
./tools/portscan.sh <target-ip> -o <output-file>
```
#### DNS Enumerating :
* Enumerate subdomains using Gobuster or Sh0zack's Advanced DNS Scan Tool.

```bash
gobuster dns -d <domain> -w <wordlist> -o <output-file>
./tools/dns.sh -u <url> -w <wordlist> -o <output-file> -t <threads> -T <timeout> -n -v
```



#### Directory Fuzzing :
* Use Gobuster, WFuzz, or Sh0zack's custom tool to find hidden directories and files.

```Bash
gobuster dir -u <url> -w <wordlist> -x php,html,txt -o <output-file>
./tools/dirscan.sh -u <url> -w <wordlist> -o <output-file> -t <threads> -T <timeout>
```
#### Brute - Force  :
* Perform brute-force attacks on many services like ssh and ftp and http  , using  Sh0zack's custom brute force tool

```bash
hydra -L <userlist> -P <passwordlist> <target-ip> ssh
./tools/bruteforce.sh -u <user> -p <password> -t <target-ip> -s ssh
```
#### Listener Setter :
* Set up a listener to catch reverse shells using Netcat or Sh0zack's custom script

[//]:# ( this will become among a c2 server funconality in veryyy near future , wanna colaborate ? dm me through socials at top of acc)

```bash nc -nvlp <port>
./tools/listener.sh -p <port>
```
<dog>

#### Auto Privilege Escalation  :

* check potential privilege escalation vectors on a Linux system ( yet to have it on windows)

```bash
./tools/privesc.sh
```

#### Decrypting Tools :
* Decrypt encoded data using Base64, Hex, or other encryption methods.

``` bash
 ./tools/decrypt.sh -e base64 -i <input-file> -o <output-file>
```

#### Web Scanner :
*Scan websites for vulnerabilities using tools like Nikto, OWASP ZAP, WPScan, and others.

```bash
nikto -h <target-website>
wpscanner --url <target-url>
./tools/webscan.sh -u <url> -o <output-file>
````
* SQLi, XSS detection and WAF bypass are in the way ... 
<br>

## 🛠️ Some Tools Showcase :

| Tool | Description | Usage |
|------|-------------|-------|
| 🔍 DNS Scanner | Fast and customizable DNS enumeration | `./tools/dns.sh -u <url> -w <wordlist> -o <output_file> -t <threads> -T <timeout> -n -v` |
| 🖧 Port Scanner | Efficient multi-threaded port scanning | `./tools/port-scanner.sh <target>` |
| 📁 Directory Scanner | Discover hidden directories and files | `./tools/dir.sh -u <url> -w <wordlist> -o <output_file> -t <threads> -T <timeout> -v` |
| 🔐 SSL Analyzer | Evaluate SSL/TLS security configurations | `./tools/ssl-analyzer.sh <domain>` |
| 🕷️ Web Crawler | Recursively map website structure | `./tools/webcrawler.sh -u <url> -d <depth> -o <output_file>` |

... and many more powerful tools!

<br>

# Installation : 
```chkoupy
git clone https://github.com/sh0z3n/Sh0zack.git
cd Sh0zack
./sh0zack.sh
```

### Tip : 
for internal tools installation  use :
``` bash 
chmod +x/scripts/install.sh && ./install.sh 
```
for wordlists generation : 
``` bash 
chmod +x/scripts/get-wordlists.sh && ./get-wordlists.sh 
```

## 🚀 Features

- 🚄 **High-speed scanning** with multi-threading support

- 🎨 **Customizable output formats** (JSON, CSV, XML)
- 🔧 **Modular design** for easy integration and expansion

- 📊 **Detailed reporting** with vulnerability assessment

- 🔒 **Built-in security measures** to prevent abuse

<br>

## 🤝 Contributing 

We invite you to contribute to **Sh0zack** by adding new modules, improving code logic, or creating odd scripts. 

- Fork the repository and submit a pull request after working on your branch. Most pull requests will be reviewed and approved within ```24``` **hours** ! <br></br>
<div align="center">
  <img alt="New Badge" src="https://img.shields.io/badge/Contributions-Welcome-violet?style=for-the-badge&labelColor=blue&color=violet">
</div>

## 📊 Some Meaning-less Statistics
<p align="center">
  <img src="https://img.shields.io/github/downloads/sh0z3n/Sh0zack/total?style=for-the-badge&color=blue" alt="Downloads">
  <img src="https://img.shields.io/github/last-commit/sh0z3n/Sh0zack?style=for-the-badge&color=blue" alt="Last Commit">
  <img src="https://img.shields.io/github/issues-raw/sh0z3n/Sh0zack?style=for-the-badge&color=blue" alt="Open Issues">
  <img src="https://img.shields.io/github/issues-closed-raw/sh0z3n/Sh0zack?style=for-the-badge&color=blue" alt="Closed Issues">
</p>
<a href="https://star-history.com/#sh0z3n/Sh0zack&Timeline">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=sh0z3n/Sh0zack&type=Timeline&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=sh0z3n/Sh0zack&type=Timeline" />
  <center> 
  <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=sh0z3n/Sh0zack&type=Timeline" />
  </center>
 </picture>
</a>

<!-- ## 📜 License
This project is licensed under the MIT License - see the LICENSE file for details. -->
<br> </br>

## 👨‍💻 Author

<div align="center">
<a href="https://x.com/Mokhtar_Derbazi">
<img src="https://github.com/sh0z3n.png" width="100px" style="border-radius:50%"> </div> </a>
<!-- <a href="https://www.linkedin.com/in/mokhtarderbazi"> @sh0z3n  -->
<br></br>
<p align="center">
  <a href="https://www.linkedin.com/in/mokhtar-derbazi/">
    <img src="https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin" alt="LinkedIn">
  </a>
  <a href="https://x.com/Mokhtar_Derbazi">
    <img src="https://img.shields.io/badge/Twitter-Follow-blue?style=for-the-badge&logo=twitter" alt="Twitter">
  </a>
</p>




<br>
<center > <b>  Built with ❤️ for future security researchers worldwide </center>

</div>
