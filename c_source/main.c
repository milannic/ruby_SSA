#include<stdio.h>
#define MAXSTATE 10000
int transfer_Matrix[MAXSTATE][256];
//int transfer_is_ending_state[MAXSTATE];

int main(int argc,char** argv)
{
	int state_Number,for_loop_variable,for_loop_255_variable,temp_int,current_state = 0;
	int* temp_ending_flag = NULL;
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
	//input_transfer_file = fopen("/home/milannic/result","r");
	fscanf(input_transfer_file,"%d\n",&state_Number);
	//printf("%d\n",state_Number);
	for(for_loop_variable=0;for_loop_variable<state_Number;for_loop_variable++)
	{
		temp_ending_flag = &transfer_is_ending_state[for_loop_variable];
		*temp_ending_flag = 1;
		for(for_loop_255_variable=0;for_loop_255_variable<256;for_loop_255_variable++)
		{
			fscanf(input_transfer_file,"%d\t",&temp_int);
			transfer_Matrix[for_loop_variable][for_loop_255_variable] = temp_int;
			//if(*temp_ending_flag==1)
			//{
			//	if(temp_int!=for_loop_variable)
			//		*temp_ending_flag = 0;
			//}

			//printf("%d\t",transfer_Matrix[for_loop_variable][for_loop_255_variable]);
			//getchar();
		}
		fscanf(input_transfer_file,"\n");
		//getchar();
	}
	fclose(input_transfer_file);
	if ((input_string_file= fopen(argv[2],"r+"))==NULL)
	{
		printf("files openning wrong\n");
		exit(0);
	}
	while((!feof(input_string_file)))
	{
		//printf("%d\n",current_state);
		trans_char = fgetc(input_string_file);
 		current_state = transfer_Matrix[current_state][(int)trans_char];
	}
	fclose(input_string_file);
	return 0;
};
