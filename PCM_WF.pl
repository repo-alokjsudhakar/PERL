#!/usr/bin/perl
use strict;
use feature qw(say);

my $temp_str;
my $sql;
my $items;
my $tr_rec;
my $ref_tr_pk;
my $td_rec;
my $new_pr_list;
my $pr_item;
my $pr_rec;
my $pd_rec;
my $find;
my $replace;
my $email;

my $tp_count=join '', map int rand 10, 1..5;
my $pc_count=join '', map int rand 10, 1..5;
my $tr_count=join '', map int rand 10, 1..5;
my $pd_count=join '', map int rand 10, 1..5;
my $pr_count=join '', map int rand 10, 1..5;
my $ec_count=join '', map int rand 10, 1..5;
my $mb_count=join '', map int rand 10, 1..5;

my @MY_TP_ref;
my @MY_TR_ref;
my @MY_PD_ref;
my @MY_PR_ref;
my @MY_MB_ref;
my @MY_CN_ref;

my @elements;
my @fields;
my @fields1;
my @tr_fds;
my @td_fds;
my @pr_list;
my @pr_fds;
my @pd_fds;
my $ec_pk;
my $mb_pk;
my $proto_check;
my $proto_name;
my $proto_pkid;
my $proto_ref;
my $proto;
my $drop_proto;

if ($#ARGV < 1) {
	die "Usage: PCM_WF.pl account_request_file data_ref_file output_file1";		
}

open(FH_IN, $ARGV[0]) or die "Open file $ARGV[0] failed.";
open(FH_OUT, ">> $ARGV[1]") or die "Open file $ARGV[1] failed.";

while (<FH_IN>) {
	chomp;
	##say "FILE READ";
	
	if ( $_ =~ /^CN:/ ) {
	    $temp_str = substr($_, 3);
            push(@MY_CN_ref, $temp_str);
        }
        elsif ( $_ =~ /^TP:/ ) {
	    $temp_str = substr($_, 3);
            push(@MY_TP_ref, $temp_str);
        }
	elsif ($_ =~ /^MB:/ ){
	    $temp_str = substr($_, 3);
	    push(@MY_MB_ref, $temp_str);	
	}
	elsif ( $_ =~ /^TR:/ ) {
	    ##say "TR READ";
            $temp_str = substr($_, 3);
            push(@MY_TR_ref, $temp_str);
        }
        elsif ( $_ =~ /^PD:/ ) {
	    ##say "PD READ";
            $temp_str = substr($_, 3);
            push(@MY_PD_ref, $temp_str);
        }
        elsif ( $_ =~ /^PR:/ ) {
	    ##say "PR READ";
            $temp_str = substr($_, 3);
            push(@MY_PR_ref, $temp_str);
        }
}
close(FH_IN);

$proto_check=0;
$proto_pkid="";
$proto_name="";
$proto_ref="";
$proto="";
$drop_proto="";

foreach $items(@MY_TP_ref) {
	##say "TP WRITE";
	##say "$proto_check";	

	$proto = $MY_CN_ref[$proto_check];
	$proto =~ s/\s+$//;

	##say $proto;
	if ($proto eq "VAN"){
	$proto_name = "ExistingConnection";
	$proto_pkid = 'TPYIy5Vn';
	$proto_ref = sprintf("EC%06d",$ec_count);
	$drop_proto = $proto_pkid;
	}
	elsif ($proto eq "SPS"){
	$proto_name = "ExistingConnection";
	$proto_pkid = 'TPddFY5h';
	$proto_ref = sprintf("EC%06d",$ec_count);
	$drop_proto = $proto_pkid;
	}
	elsif ($proto eq "Mailbox"){
	$proto_name = "Mailbox";
	$proto_ref = sprintf("MB%06d",$mb_count);
	$drop_proto = $proto_ref;
	}
	
	##say "proto name $proto_name";

	@fields = split(/\|/, $items);
	$sql = qq {INSERT INTO SterInt.dbo.PETPE_TRADINGPARTNER VALUES('$fields[0]','$fields[1]','$fields[2]','','','$fields[3]','$fields[4]','$proto_name','N','N','$proto_ref','N','N','SQL','SQL',GETDATE())};
	printf FH_OUT "$sql;\n";
       
	#TPYIy5Vn - For IBM VAN
	#TPddFY5h - For SPS AS2
        #Mailbox-for mailbox

       if($proto_name eq "ExistingConnection"){
 	$sql = qq {INSERT INTO SterInt.dbo.PETPE_EC VALUES('$proto_ref','TP','$fields[0]','Mailbox','$proto_pkid','Y','N','SQL','SQL',GETDATE())};
	printf FH_OUT "$sql;\n";
	$ec_count++;
       }

	if($proto_name eq "Mailbox"){
		foreach $items (@MY_MB_ref) {
		@fields = split(/\|/, $items);
		$sql = qq {INSERT INTO SterInt.dbo.PETPE_MAILBOX VALUES('$proto_ref','$fields[1]','$fields[2]','$fields[3]','$fields[4]','$fields[5]','1','N','N','SQL','SQL',GETDATE(),NULL)};
		printf FH_OUT "$sql;\n";
		$mb_count++;	
		}
	}
	$proto_check++;
}

foreach $tr_rec (@MY_TR_ref) {
	##say "inside TR";
	$find = "QA";
	$replace = "CERT";
	@tr_fds = split(/\|/, $tr_rec);
	$ref_tr_pk = $tr_fds[0];
	$sql = qq {INSERT INTO SterInt.dbo.PETPE_PROCESS VALUES('$tr_fds[0]','$tr_fds[1]','APP9UYEj','$tr_fds[3]','$tr_fds[4]',NULL)};
	printf FH_OUT "$sql;\n";
	
	foreach $pd_rec (@MY_PD_ref) {
		@pd_fds = split(/\|/, $pd_rec);
		
		if ($ref_tr_pk eq $pd_fds[1]) {
			$new_pr_list = "";
			@pr_list = split(/\,/, $pd_fds[7]);
			
			foreach $pr_item (@pr_list) {
				foreach $pr_rec (@MY_PR_ref) {
					@pr_fds = split(/\|/, $pr_rec);
					
					if ($pr_item eq $pr_fds[0]) {
						
						if ($new_pr_list eq "") {
							$new_pr_list = $pr_fds[0];
						}
						else {
							$new_pr_list = $new_pr_list . ',' . $pr_fds[0];
						}
                                                
						if($pr_fds[2] eq "Pragma_Translation"){
							$pr_fds[1] ="Ri1i14";	
						}
						if($pr_fds[2] eq "Multi Split & Mail"){
							$pr_fds[1] ="RozMrv";	
						}
						if($pr_fds[2] eq "Multi SAP ALE Delivery"){
							$pr_fds[1] ="Rs2ZmV";	
						}
						if($pr_fds[2] eq "Pragma_SAP_Translation"){
							$pr_fds[1] ="RM5pJB";	
						}
						if($pr_fds[2] eq "Pragma_SAPTranslation_Envelope_Mode"){
							$pr_fds[1] ="RWVtet";	

   							if($pr_fds[4] eq "AOBSMITHWESST"){
                            					$pr_fds[4] = "AOBSMITHWESS";
                        				}
				                        if($pr_fds[4] eq "AOBACCESSORYT"){
                            					$pr_fds[4] = "AOBACCESSORY";
                        				}
							if($pr_fds[4] eq "AOBTHOMPSONT"){
                            					$pr_fds[4] = "AOBTHOMPSON";
                        				}
							if($pr_fds[4] eq "AOBUSTT"){
                            					$pr_fds[4] = "AOBUST";
                        				}
						}
						if($pr_fds[2] eq "DeferredEnvelope"){
							$pr_fds[1] ="RnJ7AO";	
						}
						if($pr_fds[2] eq "SAPALEDelivery"){
							$pr_fds[1] ="Rsx9Iw";	
						}
						if($pr_fds[2] eq "Pragma_Translation_AckTieBack"){
							$pr_fds[1] ="RBkVUC";	
						}
						if($pr_fds[2] eq "DropProcess"){
							$pr_fds[1] = "7";
							$pr_fds[4] = $drop_proto;
						}
						$sql = qq {INSERT INTO SterInt.dbo.PETPE_PROCESSRULES VALUES('$pr_fds[0]','$pr_fds[1]','$pr_fds[2]','$pr_fds[3]','$pr_fds[4]','$pr_fds[5]','$pr_fds[6]','$pr_fds[7]','$pr_fds[8]','$pr_fds[9]','$pr_fds[10]','$pr_fds[11]','$pr_fds[12]','$pr_fds[13]','$pr_fds[14]','$pr_fds[15]','$pr_fds[16]','$pr_fds[17]')};
						printf FH_OUT "$sql;\n";
					}
				}
			}
                        if($pd_fds[3] eq "AOBSMITHWESST"){
                            $pd_fds[3] = "AOBSMITHWESS";
                        }
                        if($pd_fds[4] eq "AOBSMITHWESST"){
                            $pd_fds[4] = "AOBSMITHWESS";
                        }
                        if($pd_fds[3] eq "AOBACCESSORYT"){
                            $pd_fds[3] = "AOBACCESSORY";
                        }
                        if($pd_fds[3] eq "AOBUSTT"){
                            $pd_fds[3] = "AOBUST";
                        }
                        if($pd_fds[4] eq "AOBACCESSORYT"){
			    $pd_fds[4] = "AOBACCESSORY";
                        }
			if($pd_fds[3] eq "AOBTHOMPSONT"){
                            $pd_fds[3] = "AOBTHOMPSON";
                        }
 			if($pd_fds[4] eq "AOBTHOMPSONT"){
			    $pd_fds[4] = "AOBTHOMPSON";
			}
 			if($pd_fds[4] eq "AOBUSTT"){
			    $pd_fds[4] = "AOBUST";
			}			
			$sql = qq {INSERT INTO SterInt.dbo.PETPE_PROCESSDOCS VALUES('$pd_fds[0]','$pd_fds[1]','$pd_fds[2]','$pd_fds[3]','$pd_fds[4]','$pd_fds[5]','$pd_fds[6]','$new_pr_list','$pd_fds[8]',NULL)};
			printf FH_OUT "$sql;\n";
		}
	}
}

