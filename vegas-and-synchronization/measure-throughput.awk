#這是測量CBR封包平均吞吐量(average throughput)的awk程式

BEGIN {
	init=0;
	i=0;
	start_time = 0;
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
   
 	if(action=="r" && type =="tcp" && (flow_id == 0 || flow_id == 1 || flow_id == 2)) {
 		pkt_byte_sum[i+1]=pkt_byte_sum[i]+ pktsize;
		
		end_time[i] = time;
		i = i+1;
	}
}
END {
	printf("%.2f\t%.2f\n", end_time[0], 0);
	
	for(j=1 ; j<i ; j++){
		th = pkt_byte_sum[j] / (end_time[j] - start_time)*8/1000;
		printf("%.2f\t%.2f\n", end_time[j], th);
	}
	
	printf("%.2f\t%.2f\n", end_time[i-1], 0);
}
