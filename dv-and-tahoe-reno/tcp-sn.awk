BEGIN {
	fsDrops = 0;
	numFs = 0;
}
{
   action = $1;
   time = $2;
   from = $3;
   to = $4;
   type = $5;
   pktsize = $6;
   flow_id = $8;
   src = $9;
   dst = $10;
   seq_no = $11;
   packet_id = $12;

	if (from==2 && to==3 && type="tcp" && action == "+") 
		printf("%f %d\n", time, seq_no)
}
END {
}
