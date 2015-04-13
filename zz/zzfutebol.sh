# ----------------------------------------------------------------------------
# http://esporte.uol.com.br/futebol/agenda-de-jogos
# Mostra todos os jogos de futebol marcados para os proximos dias.
# Além de mostrar os times que irão jogar, o script também mostra o dia,
# o horário e por qual campeonato será o jogo.
#
# Suporta um argumento que pode ser:
#
# Um dos dias da semana, como:
#  hoje, amanhã, segunda, terça, quarta, quinta, sexta, sábado, domingo.
#
# Um filtro como nome do campeonato ou nome do time.
# Ou o horário de uma partida.
#
# Uso: zzfutebol [ argumento ]
# Ex.: zzfutebol                 # Todas as partidas nos próximos dias.
#      zzfutebol hoje            # Partidas que acontecem hoje.
#      zzfutebol sabado          # Partidas que acontecem no sábado.
#      zzfutebol libertadores    # Próximas partidas da Libertadores.
#      zzfutebol 21h             # Partidas que começam entre 21 e 22h.
#
# Autor: Jefferson Fausto Vaz (www.faustovaz.com)
# Desde: 2014-04-08
# Versão: 6
# Licença: GPL
# Requisitos: zzdata zzdatafmt zztrim zzpad
# ----------------------------------------------------------------------------
zzfutebol ()
{

	zzzz -h futebol "$1" && return
	local url="http://esporte.uol.com.br/futebol/central-de-jogos/proximos-jogos"
	local linha campeonato time1 time2

	$ZZWWWDUMP "$url" |
	sed -n '
		/[0-9]h[0-9]/p
		/ __*$/ {s/ [A-Z][A-Z][A-Z]//; s/ __*//; p;}
		/º / { s/.*\([0-9]\{1,\}º\)/\1/;p }' |
	zztrim |
	awk '
		NR % 3 == 1 { campeonato = $0 }
		NR % 3 == 2 { time1 = $0 }
		NR % 3 == 0 { print campeonato ":" time1 ":" $0 }
		' |
	case "$1" in
		hoje | amanh[aã] | segunda | ter[cç]a | quarta | quinta | sexta | s[aá]bado | domingo)
			grep --color=never -e $( zzdata $1 | zzdatafmt -f 'DD/MM/AA' )
			;;
		*)
			grep --color=never -i "${1:-.}"
			;;
	esac |
	while read linha
	do
		campeonato=$(echo $linha | cut -d":" -f 1)
		time1=$(echo $linha | cut -d":" -f 2)
		time2=$(echo $linha | cut -d":" -f 3 | zztrim)
		echo "$(zzpad -r 40 $campeonato) $(zzpad -l 25 $time1) x $time2"
	done
}
