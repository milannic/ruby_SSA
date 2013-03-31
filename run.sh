#! /bin/bash	 

ruby state_trace_gen.rb bro217_trans_matrix bro217_end_state ../result 1000000 & ruby state_trace_gen.rb bro217_trans_matrix bro217_end_state ../result2 1000000 & 
