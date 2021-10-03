#!/bin/sh
# lz_arip.sh v1.0.0
# By LZ 妙妙呜 (larsonzhang@gmail.com)

#BEIGIN

## 获取路由器公网出口IPv4地址脚本
## 输入项：
##     $1--1：第一WAN口；2：第二WAN口；其它/无输入项：第一WAN口/单线接入时的WAN口
## 返回值：
##     IPv4地址

## 获取路由器公网出口IPv4地址函数
## 输入项：
##     $1--1：第一WAN口；2：第二WAN口；其它/无输入项：第一WAN口/单线接入时的WAN口
## 返回值：
##     IPv4地址
arIpAdress() {
	local id=0 ifn=""
	[ "$1" = "2" ] && id=1
	if [ -n "$( ip route | grep nexthop )" ]; then
		ifn=$( nvram get wan"$id"_pppoe_ifname )
		[ -z "$ifn" ] && ifn=$( nvram get wan"$id"_ifname )
		[ -n "$ifn" ] && ifn="--interface $ifn"
	fi
	echo $( eval "curl -s --connect-timeout 20 $ifn whatismyip.akamai.com 2>&1 | grep -Eo '([0-9]{1,3}[\.]){3}[0-9]{1,3}'" )
}

## 获取路由器公网出口IPv4地址
## 输入项：
##     $1--1：第一WAN口；2：第二WAN口；其它/无输入项：第一WAN口/单线接入时的WAN口
## 返回值：
##     IPv4地址
MyPubIPv4Addr=$( arIpAdress $1 )
[ -z "$MyPubIPv4Addr" ] && MyPubIPv4Addr=unknown

echo
echo My public network IPv4 address: $MyPubIPv4Addr
echo

#END
