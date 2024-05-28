@echo off
set dir=%~dp0

IF EXIST "%dir%halon-fivem" (
    set datap="%dir%halon-fivem\server-data"
    set conf="%dir%halon-fivem\server.cfg"
) ELSE (
    set datap="%dir%server-data"
    set conf="%dir%server.cfg"
)

IF EXIST "%dir%server" (
    set execf="%dir%server\FXServer.exe"
) ELSE (
    set execf="%dir%FXServer.exe"
)

title halon-fivem && cd %datap% && %execf% +exec %conf%
