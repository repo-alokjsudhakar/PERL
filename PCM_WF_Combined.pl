#!/usr/bin/perl

##############################################################################
#  Name: PCM_WF.pl
#
#  Description:
#    Generate the SQL file to load the data into PCM.
#
#
#  Update: PragmaEdge
#  Update History: 
#	07/10/2017: Initial creation
#       07/13/2018: Updates to load PD and PR details from Input file
##############################################################################

use strict;

my @MY_TP_ref;
my @MY_TR_ref;
my @MY_PD_ref;
my @MY_PR_ref;
my $ACCT_NUM;
my $ACCT_SAN;
my $ACCT_NAME;
my $ORG_SAP_ACCT;
my $ORG_SAN;
my $i;
my $in_rec;
my $temp_str;
my $items;
my $pr_item;
my $tr_rec;
my $pd_rec;
my $pr_rec;
my @fields;
my @tr_fds;
my @pd_fds;
my @pr_fds;
my @pr_list;
my @elements;
my $tp_count=30266;
my $pc_count=30295;
my $tr_count=30231;
my $pd_count=30296;
my $pr_count=30281;
my $set_ID;
my $file_pos;
my $sql;
my $tp_pk;
my $pc_pk;
my $tp_name;
my $tp_id;
my $tp_phone;
my $tp_email;
my $protocol;
my $ftp_host;
my $ftp_port;
my $ftp_in_dir;
my $ftp_out_dir;
my $ftp_user_id;
my $ftp_password;
my $ftp_file_type;
my $protocol_pk;
my $found;
my ($tr_pk);
my ($pd_pk);
my ($pr_pk);
my $ref_tr_pk;
my $new_pr_list = "";
my $TP_email = "";
my $TP_phone = "";
my $TP_Protocol = "";
my $ACCT_CTT_IND = "";
my $TD_FilePattern = "";
my $TD_OrigFileName = "";
my @OrigFileNameSplit;
my $TD_DocType = "";
my $TR_InFileFormat = "";
my $TR_ClientName = "";
my $TR_ClientCode = "";
my $TR_OpFileFormat = ""; 
my $TR_OpDateFormat = "";
my $TR_FilePrefix = "";
my $TR_DateTimeFormat = "";
my $TR_Extension = "";
my $TR_LocOfArchive = "";
my $pc_Type="";
my $pc_SubType="";
my $TP_MBXPath="";
my $TR_MBXAddPath = "";
my $TR_MBXArcPath = "";
my $TR_QAInMBVer = "";
my $TR_QAFileCVer = "";
my $TR_QAFileVer = "";
my $TR_QANullFileVer = "";
my $TR_FileArc = "";
my $TR_DropProtocol = "";
my $TR_DropApp = "";
my $TR_DropDir = "";
my $TR_FirstMBPath = "";
my $TR_FinalMBPath = "";
my $TR_Direction = "";
my $TD_FileExt = "";
my $Inv_ID = "";
my @FirstMBSplit;
my @FinalMBSplit;
my @INFileArc;
my @OUTFileArc;
my $TP_ClientCodeCheck = "";
my $TP_Check = "";
my $TP_DeliveryType = "";
my $TP_ProfileName = "";
my $TP_RecipientName = "";
my $TP_Direction = "";
my $inMBPath = "";
my $outMBPath = "";
my $TP_AppID = "";
my $TR_MapName = "";
##my $repRuleCount = 0;
##my @MBXPathSplits;

if ($#ARGV < 1) {
	die "Usage: PCM_WF.pl account_request_file data_ref_file output_file1";		
}

##open(FH_REF, $ARGV[0]) or die "Open file $ARGV[0] failed.";
open(FH_IN, $ARGV[1]) or die "Open file $ARGV[1] failed.";
open(FH_OUT, "> $ARGV[2]") or die "Open file $ARGV[2] failed.";

while (<FH_IN>) {
	chomp;
		my @MY_TP_ref;
		my @MY_TR_ref;
		my @MY_PD_ref;
		my @MY_PR_ref;
		##$temp_str = substr($_, 12);
		$temp_str = $_;
		$temp_str =~ s/\s+$//;
		$temp_str =~ s/^\s+//;
		@elements = split(/\,/, $temp_str);
		
		open(FH_REF, $ARGV[0]) or die "Open file $ARGV[0] failed.";
		##print "template no $elements[51] \n";
		
		if($elements[52] eq ""){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^01TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                }
                close(FH_REF);
		}


		if($elements[52] eq "1"){
		while (<FH_REF>) {
        		chomp;
		        if ( $_ =~ /^01TP:/ ) {
                	$temp_str = substr($_, 5);
                	push(@MY_TP_ref, $temp_str);
       			 }
        		elsif ( $_ =~ /^01TR:/ ) {
                	$temp_str = substr($_, 5);
                	push(@MY_TR_ref, $temp_str);
       			 }
        		elsif ( $_ =~ /^01PD:/ ) {
                	$temp_str = substr($_, 5);
                	push(@MY_PD_ref, $temp_str);
        		}
        		elsif ( $_ =~ /^01PR:/ ) {
                	$temp_str = substr($_, 5);
                	push(@MY_PR_ref, $temp_str);
        		}
		}
		close(FH_REF);
		}
		if($elements[52] eq "2"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^02TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^02TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^02PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^02PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "3"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^03TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^03TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^03PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^03PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "4"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^04TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^04TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^04PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^04PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "5"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^05TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^05TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^05PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^05PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "6"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^06TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^06TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^06PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^06PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "7"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^07TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^07TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^07PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^07PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "8"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^08TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^08TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^08PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^08PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "9"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^09TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^09TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^09PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^09PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "10"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^10TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^10TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^10PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^10PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "11"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^11TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^11TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^11PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^11PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
		if($elements[52] eq "12"){
                while (<FH_REF>) {
                        chomp;
                        if ( $_ =~ /^12TP:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TP_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^12TR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_TR_ref, $temp_str);
                         }
                        elsif ( $_ =~ /^12PD:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PD_ref, $temp_str);
                        }
                        elsif ( $_ =~ /^12PR:/ ) {
                        $temp_str = substr($_, 5);
                        push(@MY_PR_ref, $temp_str);
                        }
                }
                close(FH_REF);
                }
			
		##print "TP is @MY_TP_ref \n";
		##print "TR is @MY_TR_ref \n";
		##print "PD is @MY_PD_ref \n";
		##print "PR is @MY_PR_ref \n";
		
                if($TP_ClientCodeCheck eq $elements[4]){
                ##print STDERR "same \n";
		$TP_Check = "0";
                }
		else{
		$TP_Check = "1";
		}
		##print STDERR "TP CHECK $TP_Check \n";

		$ACCT_NUM = $elements[4];
		$ACCT_SAN = $elements[0];
		$Inv_ID = $elements[0];
		$ACCT_NAME = $elements[5];
		$ACCT_NAME =~ s/\s+$//;
		$ACCT_NAME =~ s/^\s+//;
		$ACCT_NAME =~ s/'//g;
		$ACCT_NAME =~ s/"//g;
		$TP_ClientCodeCheck = $elements[4];
		$TP_email = $elements[3];
		$TP_phone = $elements[4];
		$TP_Protocol = $elements[5];
		$TP_MBXPath = $elements[14];
		$TD_OrigFileName = $elements[22];
		$TD_DocType = $elements[14];
		$TR_InFileFormat = $elements[23];
		$TR_ClientName = $elements[5];
		$TR_ClientCode = $elements[4];
		$TR_OpFileFormat = $elements[24]; 
		$TR_OpDateFormat = $elements[25];
		$TR_QAInMBVer = $elements[11];
		$TR_QAFileCVer = $elements[12];
		$TR_QAFileVer = $elements[13];
		$TR_QANullFileVer = $elements[9];
		$TR_DropProtocol = $elements[39]; 
		$TR_DropApp = $elements[40];
		$TR_DropDir = $elements[41];	
		$TR_FirstMBPath = $elements[14];
		$TR_FinalMBPath = $elements[37];  
		$TP_DeliveryType = $elements[21];
		$TP_ProfileName = $elements[40];
		$TP_RecipientName = $elements[42];
		$TP_Direction = $elements[1];	
		$TP_AppID = $elements[51];
		$TR_MapName = $elements[20];
				

		if($TR_DropProtocol eq "CD"){
		$TR_DropProtocol = "Connect:Direct";	
		}

		if ($ACCT_NAME eq "") {
			printf STDOUT "ERROR: Missing Account Name\n$_\n ";
			exit(-1);
		}
		
		@OrigFileNameSplit = split(/\./,$TD_OrigFileName);
		if(@OrigFileNameSplit[1] eq ""){
		$TD_FilePattern = "$elements[0]_$elements[4]_(.*)";
		}
		else {
		$TD_FilePattern = "$elements[0]_$elements[4]_(.*)_.$OrigFileNameSplit[1]";
		}
		##print STDERR "file pattern is $TD_FilePattern";
		
		@FirstMBSplit = split /IN|OUT/,$TR_FirstMBPath;
		@FinalMBSplit = split /IN|OUT/,$TR_FinalMBPath;			

		my($first,$next,$FirstMBrest) = split(/\//,$TR_FirstMBPath,3);
		my($first,$next,$FinalMBrest) = split(/\//,$TR_FinalMBPath,3);
		
		if($TP_Check eq "1"){
		
		if($TP_DeliveryType eq "Push" || $TP_DeliveryType eq "Scheduled Push"){
		$tp_name = $TP_ProfileName;
		##$protocol = "Connect:Direct";
		##$pc_pk = sprintf("CD-%06d",$pc_count);
		}
		else{
		$tp_name = $TP_RecipientName;	
		##$protocol = "Mailbox";	
		##$pc_pk = sprintf("MB-%06d",$pc_count);
		}

		foreach $items (@MY_TP_ref) {
		@fields = split(/\|/, $items);
			$tp_id = $ACCT_NUM;
			##$tp_name = $ACCT_NAME;
			$tp_name =~ s/,//;
			$tp_email = $TP_email;
			$tp_phone = $TP_phone;
			$protocol = "Mailbox";
			$tp_pk = sprintf("TP-%06d",$tp_count);
			$pc_pk = sprintf("MB-%06d",$pc_count);
$sql = qq {INSERT INTO PETPE_TRADINGPARTNER VALUES('$tp_pk','$tp_id-$tp_name','$tp_id',NULL,NULL,'$tp_email','$tp_phone','$protocol','N','Y','$pc_pk','N','N','SQL','SQL',GETDATE())};
			printf FH_OUT "$sql;\n";
			$tp_count++;

			if($TP_DeliveryType eq "Mailbox"){
				if($TP_Direction eq "I"){
				$inMBPath = $TP_MBXPath;
				$outMBPath = "/dummy";
				}
				else{
				$inMBPath = "/dummy";
                                $outMBPath = $TP_MBXPath;
				}
			##$pc_pk = sprintf("MB-%06d",$pc_count);
			$pc_SubType = "TP";
			$pc_Type = "Mailbox";
$sql = qq {INSERT INTO PETPE_MAILBOX VALUES('$pc_pk','$pc_SubType','$tp_pk','$pc_Type','$inMBPath','$outMBPath','1','Y','N','SQL','SQL',GETDATE(),NULL)};
			printf FH_OUT "$sql;\n";
			$pc_count++;
			}
		}
		}
		
		##print "Fly TR is @MY_TR_ref \n";
		foreach $tr_rec (@MY_TR_ref) {
			##$tr_rec =~ s/$ORG_SAP_ACCT/$ACCT_NUM/g;
			##$tr_rec =~ s/$ORG_SAN/$ACCT_SAN/g;
			@tr_fds = split(/\|/, $tr_rec);
			$ref_tr_pk = $tr_fds[0];
			$TR_Direction = $tr_fds[4];
			$tr_pk = sprintf("P-%06d",$tr_count);
$sql = qq {INSERT INTO PETPE_PROCESS VALUES('$tr_pk','$tp_pk','$TP_AppID','$tr_fds[3]','$tr_fds[4]',NULL)};
			printf FH_OUT "$sql;\n";
			$tr_count++;

			foreach $pd_rec (@MY_PD_ref) {
				##print "inside pd \n";
				my $my_pd_rec = $pd_rec;
				##$my_pd_rec =~ s/$ORG_SAP_ACCT/$ACCT_NUM/g;
				##$my_pd_rec =~ s/$ORG_SAN/$ACCT_SAN/g;
##				printf STDOUT "Before: $pd_rec\n";
##				printf STDOUT "After:  $my_pd_rec\n";
				@pd_fds = split(/\|/, $my_pd_rec);
				if ($ref_tr_pk eq $pd_fds[1]) {
					##print "pd check pass \n";
					$new_pr_list = "";
					@pr_list = split(/\,/, $pd_fds[7]);
					$pd_fds[2] = $TD_FilePattern;
					$pd_fds[6] = $TD_DocType;
					my $repRuleCount = 0;
					foreach $pr_item (@pr_list) {
						##print "inside pr list \n";
						foreach $pr_rec (@MY_PR_ref) {
						##print "inside pr \n";
####		printf STDOUT "\n$ACCT_NUM, $ACCT_SAN\n ";
							##print STDERR "var $repRuleCount";
							##print STDERR "deff $pr_rec";
							my $my_pr_rec = $pr_rec;
							##$my_pr_rec =~ s/$ORG_SAP_ACCT/$ACCT_NUM/g;
							##$my_pr_rec =~ s/$ORG_SAN/$ACCT_SAN/g;
							@pr_fds = split(/\|/, $my_pr_rec);
							if ($pr_item eq $pr_fds[0]) {
							## pk_id for this table without "-"
								$pr_pk = sprintf("PR%06d",$pr_count);
								if ($new_pr_list eq "") {
									$new_pr_list = $pr_pk;
								}
								else {
									$new_pr_list = $new_pr_list . ',' . $pr_pk;
								}
							if ($pr_fds[2] eq "Optum_Standard_Rename") {
									$pr_fds[3] = $TR_InFileFormat;
									$pr_fds[4] = $TR_ClientCode;
									$pr_fds[5] = $TR_ClientName;
									$pr_fds[6] = $TR_OpFileFormat;
									$pr_fds[7] = $TR_OpDateFormat;
							}
							if ($pr_fds[2] eq "Optum_Mailbox_Add") {
                                                                        $pr_fds[3] = $TR_FinalMBPath;
                                                        }
							if ($pr_fds[2] eq "Translation"){
									$pr_fds[3] = $TR_MapName;
							}
							if($pr_fds[2] eq "FileSystemDelivery"){
									$pr_fds[3] = $TR_FinalMBPath;
							}
							if ($pr_fds[2] eq "Optum_Mailbox_Archive") {
								##print STDERR "$repRuleCount";
                                                                if($tr_fds[4] eq "Inbound"){
                                                                        $pr_fds[3] = "$FirstMBSplit[0]Archive/IN/$FirstMBSplit[1]"
                                                                }
                                                                if($tr_fds[4] eq "Outbound"){
								    if($repRuleCount eq "1"){
									$pr_fds[3] = "$FinalMBSplit[0]Archive/OUT$FinalMBSplit[1]"
								    }
								    if($repRuleCount eq "0"){
                                                                        $pr_fds[3] = "$TR_FirstMBPath/Backup"
                                                                    }
								}
								$repRuleCount++;
                                                        }
							if ($pr_fds[2] eq "Optum_QA_Checks") {
                                                                        $pr_fds[3] = $TR_QAInMBVer;
									$pr_fds[4] = $TD_DocType;
									$pr_fds[6] = $TR_QAFileCVer;
									$pr_fds[7] = $TR_ClientCode;
									$pr_fds[8] = $TR_QANullFileVer;
                                                        }
							if ($pr_fds[2] eq "File_Archive"){
								if($tr_fds[4] eq "Inbound"){
							 	     $pr_fds[3] = "data/archive/$FirstMBrest"
								}
								if($tr_fds[4] eq "Outbound"){
								     $pr_fds[3] = "data/archive/$FinalMBrest"
								}
							}
							if ($pr_fds[2] eq "DropProcess"){	
									$pr_fds[3] = $TR_DropProtocol;
									$pr_fds[4] = $TP_AppID;
									$pr_fds[5] = $TR_DropDir;
							}				
							##$pr_fds[10] =~ s/!/|/g;	
$sql = qq {INSERT INTO PETPE_PROCESSRULES VALUES('$pr_pk','$pr_fds[1]','$pr_fds[2]','$pr_fds[3]','$pr_fds[4]','$pr_fds[5]','$pr_fds[6]','$pr_fds[7]','$pr_fds[8]','$pr_fds[9]','$pr_fds[10]','$pr_fds[11]','$pr_fds[12]','$pr_fds[13]','$pr_fds[14]','$pr_fds[15]','$pr_fds[16]','$pr_fds[17]')};
								printf FH_OUT "$sql;\n";
								$pr_count++;
							}
						
						}
					}
					$pd_pk = sprintf("PD-%06d",$pd_count);
$sql = qq {INSERT INTO PETPE_PROCESSDOCS VALUES('$pd_pk','$tr_pk','$pd_fds[2]','$pd_fds[3]','$pd_fds[4]','$pd_fds[5]','$pd_fds[6]','$new_pr_list','$pd_fds[8]',NULL)};
					printf FH_OUT "$sql;\n";
					$pd_count++;
				}
			}
		}
		printf FH_OUT "commit;\n";
	##}
	##else {
	##	next;
	##}
}
close(FH_IN);

close(FH_OUT);

