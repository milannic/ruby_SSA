#include<stdio.h>
#include<stdlib.h>
#define MAXSTATE 100000


typedef struct _link_set{
	int accept_state;
	struct _link_set * next;
}link_set;

typedef link_set *p_link_set;


p_link_set accepted_state[MAXSTATE];

int transfer_Matrix[MAXSTATE][256];

//int transfer_is_ending_state[MAXSTATE];

int main(int argc,char** argv)
{
	volatile int state_Number,for_loop_variable,for_loop_255_variable,temp_int,current_state = 0;
	p_link_set temp_link_node,temp_link_node2;
	unsigned char trans_char;
	FILE* input_transfer_file;
	FILE* input_string_file;

	if(argc!=3)
	{
		printf("arguments matching wrong,requires two arguments(%d of 2)\n",argc-1);
		exit(0);
	}
	if ((input_transfer_file = fopen(argv[1],"r+"))==NULL)
	{
		printf("files openning wrong\n");
		exit(0);
	}
	fscanf(input_transfer_file,"%d\n",&state_Number);
	//printf("%d\n",state_Number);
	// get transfer matrix
	for(for_loop_variable=0;for_loop_variable<state_Number;for_loop_variable++){
		accepted_state[for_loop_variable] = NULL;	
		//printf("%ld\n",&accepted_state[for_loop_variable]);
		//getchar();
		for(for_loop_255_variable=0;for_loop_255_variable<256;for_loop_255_variable++){
			fscanf(input_transfer_file,"%d\t",&temp_int);
			transfer_Matrix[for_loop_variable][for_loop_255_variable] = temp_int;
		}
		fscanf(input_transfer_file,"\n");
	}

	//get accepted state;
	while((!feof(input_transfer_file))){

		fscanf(input_transfer_file,"%ld\t:\t%ld\t:",&temp_int,&for_loop_variable);
		fscanf(input_transfer_file,"%ld\t",&current_state);

		//printf("%ld:%ld\n",temp_int,for_loop_variable);
		//printf("%ld",current_state);
		//getchar();
		//printf("%ld\n",accepted_state[temp_int]);
		//printf("%ld\n",&accepted_state[temp_int]);
		(accepted_state[temp_int]) = (p_link_set)malloc(sizeof(link_set));
		//printf("%ld\n",accepted_state[temp_int]);
		//printf("%ld\n",&accepted_state[temp_int]);
		//getchar();
		(accepted_state[temp_int])->accept_state = current_state;
		(accepted_state[temp_int])->next = NULL;
		temp_link_node = accepted_state[temp_int];

		for(for_loop_255_variable=1;for_loop_255_variable<for_loop_variable;for_loop_255_variable++){
			//printf("coming in is the state %ld\n",temp_int);
			//getchar();
			fscanf(input_transfer_file,"%ld\t",&current_state);
			//printf("and this is %ld\n",current_state);
			temp_link_node->next = (p_link_set)malloc(sizeof(link_set));
			temp_link_node->next->accept_state = current_state;
			temp_link_node->next->next= NULL;
			temp_link_node = temp_link_node->next;
		}
		fscanf(input_transfer_file,"\n");
	}
	/* 
	for(for_loop_255_variable=0;for_loop_255_variable<MAXSTATE;for_loop_255_variable++)
	{
		//printf("hehe %ld\n",for_loop_255_variable);
		if(accepted_state[for_loop_255_variable]!=NULL)
		{
			printf("hahahaha %ld\n",for_loop_255_variable);
			temp_link_node = accepted_state[for_loop_255_variable];
			while(temp_link_node!=NULL)
			{
				printf("-->%ld",temp_link_node->accept_state);
				temp_link_node = temp_link_node->next;
			}
			//printf("haha %ld\n",accepted_state[for_loop_255_variable]->accept_state);
			getchar();
		}
	}
	*/
	
	fclose(input_transfer_file);
	//getchar();
	if ((input_string_file= fopen(argv[2],"r+"))==NULL)
	{
		printf("files openning wrong\n");
		exit(0);
	}
	current_state = 0;

	while((!feof(input_string_file)))
	{
		trans_char = fgetc(input_string_file);
 		current_state = transfer_Matrix[current_state][(int)trans_char];
		if(NULL != accepted_state[current_state]){
			temp_link_node = accepted_state[current_state];
			while(NULL != temp_link_node){
				if(temp_link_node->accept_state==-1);
				temp_link_node = temp_link_node->next;
			}
		}
	}
	fclose(input_string_file);
	return 0;
};
