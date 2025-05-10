#!/home/noah/kermit/wermit
set transfer mode manual
set file type binary
set host localhost 2030 /raw-socket

input 2 "\13."
output "login dist\13"

;input 1 "\13."
;output "r setsrc\13"
;input 1 "\13*"
;output "cp [10,7,decwar]\13"
;input 1 "\13*"
;output "\3"
;input 1 "\13."
;output "dir\13"
;input 5 "\13."
;output "\13"

input 1 "\13."
output "r k10mit\13"
input 1 "Kermit-10>"
output "set file byte-size 36-bit\13"
input 1 "Kermit-10>"
output "server\13"

; when done, k/f on tops, then close and quit from raspi kermit
