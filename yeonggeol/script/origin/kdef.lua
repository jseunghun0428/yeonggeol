--[[
SceneID
-1 ºÚÆÁ
0 ´óµØÍ¼
43 Ğí²ı²Ü²Ù¹ÙÛ¡
45 ĞìÖİÌÕÇ«¹ÙÛ¡
48 ±±Æ½ÒéÊÂÌü
54 Æ½Ô­ÒéÊÂÌü/±±º£/Ğ¡Åæ/ÏÂÚü/°×Âí/¹Å³Ç
63 ²Ü²Ù¾üÓªÕÊ
66 Ğí²ı ²Ü²Ù»¨Ô°
77 Ğí²ıÁõ±¸¹ÙÛ¡
83 Úş³ÇÒéÊÂÌü
84 Ğí²ı¹¬µî
85 ÂåÑô¹¬µî/Ğí²ıÒéÊÂÌü
86 ³ÂÁôÒéÊÂÌü/ĞìÖİ
87 ĞÅ¶ÈÒéÊÂÌü
89 ÂåÑô¹¬µî£¨Ï×µÛ£©
85 ÂåÑô¹¬µî£¨¶­×¿£©ÂÒÓÃ
92 »´ÄÏÒéÊÂÌü
97 ¹ã´¨ÓªÕÊ/Áõ±¸
95 ³ÂÁôÓªÕÊ/»¢ÀÎ/Ô¬ÉÜ
]]--

Event= {
 --ĞòÕÂ¿ªÊ¼
 --ĞòÕÂ¡¡ÈºĞÛÆğ±øÌÖ·¥¶­×¿
 [1]=function()
 SetSceneID(-1,2);
 JY.Base["ÕÂ½ÚÃû"]="ƒWƒa¡¡‚T†] ‚l…a ‰S‰r";

DrawMulitStrBox("DDo ƒa‚Iƒb ‚lƒm„S ‚N‚jƒd ƒA†@ƒb ~†]S ‰s‚S ‰t„p.*‚V‚P‡z ƒ{OD ‰BnƒsA ‰uƒu, ‰R„[ƒb ƒ[‚_„S „Z†o„V ‰v„k„p.*†e_ƒP ‚S‚^‡z ƒ|‚^‚b ‚I^fƒW ^SˆG ‰wƒU†vS ƒX ƒs„p.*…a‚K o ‰xf …A^G „Vƒv ƒdƒgƒP …IS ‰y‚Mf ‚^„Q„p.*¡ª¡ªR‚I…m")

 DrawStrBoxCenter("ƒWƒa¡¡‚T†] ‚l…a ‰S‰r");
 LoadPic(3,1);
 DrawMulitStrBox("¡¡„U‚b …Co ˆ|‰z.*¡¡…Co ˆ|, …A‚d{ „c‚lG ‰{‚i‚jƒd oNƒP ‰|…D‚b †u^ ‰}D ‰~Š@PM.*¡¡G ‚c‚dS ‚^‡M …x^ ƒU„S ‚l…aGM.")
 DrawMulitStrBox("¡¡‚l…aƒb vFS ‡Yf †pƒd ‚Ud‚h †nƒNbƒG†B dŠA‚_„S †^„kM. „v†G ƒ[‚h …A‚_aŠB …xƒRD ƒ[^ ŠC ‚~‡bG ‚[ƒ`„E n‰TaL, ‚UdƒP ‡b‚n‚b G†w ‚r‚f‚Cƒd ‚a„kM.")

 LoadPic(3,2);
 --ĞŞ¸ÄÈÎÎñÄ¿±ê:<ÔÚãáË®¹ØÓë¶­×¿µÄ»ªĞÛ¾ü½»Õ½>
 
 NextEvent();
 end,
 [2]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 -- 
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="„Y†o";
 JY.Base["D‚wC"]=0;
 AddPerson(383,27,8,1);
 AddPerson(4,19,12,0);
 AddPerson(372,17,12,0);
 AddPerson(371,19,13,0);
 AddPerson(384,14,9,3);
 AddPerson(7,25,15,2);
 AddPerson(22,12,10,3);
 AddPerson(21,23,16,2);
 AddPerson(47,10,11,3);
 AddPerson(48,21,17,2);
 SetSceneID(89);
 DrawStrBoxCenter("„Y†o †X‚B");
talk(4,"ŠDa, …`ƒ` …X‡I‚V[. vFƒP …Iƒb ‚Z‚[ ƒNfQ ŠEƒG‚V‚CZ.",
 383,"¡­¡­",
 4,"ƒ[†{, ƒNƒb G„V ƒA…e^†yKLM.");
 MovePerson( 4,1,1);
 MovePerson( 4,7,1,
 372,7,1,
 371,7,1);
 talk(4,"…M! ‚Ud‚b Gd ƒa‚yƒB…I ŠF, G ƒv‚fƒP ‚Kjƒb ƒU„S ƒvM. aa!");
 DecPerson(4);
 DecPerson(372);
 DecPerson(371);
 DrawSMap();
 ShowScreen();
 MovePerson( 7,1,0);
 MovePerson( 7,2,2);
 MovePerson( 7,0,0);
 talk(7,"ŠDa, …_…r‚h `‚Ea‚V‚S ‚l…afQ ŠGƒW‚C …XmƒW.");
 MovePerson( 7,9,1);
 DecPerson(7);
 DrawSMap();
 ShowScreen();
 MovePerson( 21,7,1,
 22,7,1,
 47,7,1,
 48,7,1);
 DecPerson(21);
 DecPerson(22);
 DecPerson(47);
 DecPerson(48);
 DrawSMap();
 ShowScreen();
 talk(383,"¡­¡­‚M, ‰cƒb †@ŠH ‚l…aS „oƒW„Q ‚kƒmu‚f. ‡mƒv ‚_‚TG ƒ[ƒP ‡Yf „OƒmL ‰cfQ‚b ŠGE „@G ‚a‚wƒv. G ƒv‚ff‚b ‚l…aS „Qƒd oNƒP ‚n‡nS „C†j„u …x^ ‚a†M ˆ|j^?");
 MovePerson( 384,4,0);
 MovePerson( 384,1,3);
 talk(384,"ŠDa, ƒ[ †dF ŠInu[ƒv ƒNƒRƒP „@G ‚Z…xŠJ ‚iŠKhLM.");
 NextEvent();
 end,
 [3]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="g]";
 JY.Base["D‚wC"]=0;
 AddPerson(9,25,9,1);
 SetSceneID(95,12);
 DrawStrBoxCenter("g] g~");
 DrawMulitStrBox("¡¡oNf ‡tƒ{S †_ƒoo d…CƒRƒb ‚l…aƒP ‚B†Hf „^Q …d„VS ƒB„kM.*¡¡ŠLƒd ‚GƒMaƒG„S GŠK‚q vvD kƒk‚b nL„kM.");
 DrawMulitStrBox("¡¡vv‚b ‚l…aS ŠN†jaƒ` Pƒmƒv NOPM. G‚S ‚E‚Cf ‰S‰r ‚p…ZS ‰BuL „]†E‡S †q„iG „O„kƒd, [†G‚C ‚kn d…CƒRG ‚~ƒ}S Gˆnƒd g]„S ‚ZbƒR„kM.");
 AddPerson(10,4,20,0);
 AddPerson(12,6,21,0);
 MovePerson( 10,8,0,
 12,8,0);
talk(9,"ƒQm, ƒQƒH ‚[ ƒa‚T, ‚p…Zf „iB ‚K‚S ƒdŠOm.",
 10,"ƒv‚b gJ‚^ƒh ‚l…aƒP ‚B†HG „If †E…j„~m. G‚Wf…Eˆ|„S †JƒL ‚l…aS ŠPƒW oNƒP ‚n‡nS „C†ju†ym.",
 12,"ƒ[ŠQm. ƒOu ƒQƒT …I^^ ƒv…m GC ‚l…aS ƒ[ˆ} ‚[‚C ‚k†ym. ƒ[ ŠRƒbGƒP ‚B†HS ‚SŠS †~†y‚b^, ƒOuƒP ‡G‡SŠTS ƒsb ‚K‚C."
 );
 MovePerson( 10,2,2,
 12,2,2);
 MovePerson( 10,0,3,
 12,2,1);
 MovePerson( 12,1,2);
 MovePerson( 12,0,3);
 
 AddPerson(16,4,20,0);
 AddPerson(8,6,21,0);
 MovePerson( 16,8,0,
 8,8,0);
talk(9,"[, D‡[, ‚J‡X, ŠU [ŠVm.",
 16,"oƒP ƒNa„SƒW ‚SŠS ‚l…aS †~†ym. ƒW‚KfƒW †PŠW ˆGƒ`ŠXƒmL …BW‚Tf ŠY„E ‚K‚V[.",
 8,"ƒvD ‡kBfƒW ‚TS Gˆnƒd ‡z …BW‚Tf ^†ia†ym."
 );
 MovePerson( 16,2,3,
 8,2,3);
 MovePerson( 16,2,1,
 8,0,2);
 MovePerson( 16,1,3);
 MovePerson( 16,0,2);
 AddPerson(13,4,20,0);
 MovePerson( 13,8,0);
talk(9,"‚J‡Y‡ZD ŠX‚wƒ`. ‰q †r [‚V†s‚f qƒd ‡Aƒtm.",
 13,"ŠZˆ|Š[S. m†Kaƒd Š]ƒb ‚r†vG aƒv „Om.",
 9,"[, †u‚wZ?",
 13,"‚G‚P‚f a[. ƒR‚S[‚VQ."
 );
 AddPerson(1,6,21,0);
 MovePerson( 1,8,0);
talk(1,"…f‚b ‚G‚P, …x‚b r‡VhLM. ‚l…aS ˆjM‚b ˆ|S Š^ƒd ‚J‡Y‡Z{ ‰HŠ_ ˆGƒ`ŠXKLM.");
 DrawMulitStrBox("¡¡‚Cƒg ƒv…@‚q G jƒAG G G…EƒGƒP ‚Kj‚JGM. ƒ{ƒb ‚G, GŠKƒb ‚P, …x‚b r‡V. Š`…xu‚h Ša ‰O†B ^‚q …{f …x‚d ŠLƒbGŠbƒmƒv, ‚SŠcLfQƒW …mv^ ‚Ud‚f‚b ˆ|S ƒRƒb ‡D„S ƒ[ƒP Šdƒb ˆG‚fƒFM.");
 DrawMulitStrBox("¡¡‚UwƒP ‚qG …I‚Sƒv…x ‚G‚P‚b ‚qƒo‚h ‚waƒd…x ƒP„o‚TS Gˆnƒd ‚UwƒLS ‡RM.*¡¡‚G‚PfQ‚b ‚[ nƒO^ „O„kƒmL aƒv‚b eƒO …x‚b ‡Sƒa, aƒv‚b ƒa‚P …x‚b …S‡V. Še M Šf‚S‚q †q‚@G„kM.");
 DrawMulitStrBox("¡¡‚G‚P, eƒO, ƒa‚P ƒo ‚r†vƒb ƒO…BŠW „VŠgƒmƒv ƒW„SƒP ƒ]f ‡N‚DB ƒPˆEd‚h Šh„kM. ‰X‚h ƒv„I ‚rG‚b nL„k‚C„V eƒO‡z ƒa‚P‚b ‚G‚P‚h ƒnˆEŠiG‚f …dŠjM.");
talk(9,"[, ‚G‚Pj^? ƒOu ‚Bf „V‚q ƒLG „O‚C.",
 1,"‚UwƒLS †R „UŠbKLM.",
 9,"ƒ[„U ƒ[‚_ƒP „o†_o ‰jˆlf „D„gm. ƒ[‚_^ „OƒmL „l„m ˆeˆea[. ŠU ‚^…aa[.",
 1,"ŠU ‚^…a…w„tLM.",
 12,"(‚G‚P? ƒR‚S „v ƒL ‚a‚b …x„S‚T.)"
 );
 DrawMulitStrBox("¡¡‚Zbˆe d…CƒR ^‡S…h ƒQm^ †_‚K„S …c‚_„C‚S ‚l…a ‰S‰r …BW‚TG †@ƒ{„C„kM.");
 NextEvent(); 
 end,
 [4]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="„Y†o";
 JY.Base["D‚wC"]=0;
 AddPerson(4,26,8,1);
 AddPerson(5,23,7,1);
 AddPerson(6,19,12,0);
 AddPerson(7,14,9,3);
 AddPerson(47,10,11,3);
 AddPerson(48,4,14,3);
 AddPerson(21,25,15,2);
 AddPerson(22,21,17,2);
 AddPerson(28,15,20,2);
 SetSceneID(85,11);
 DrawStrBoxCenter("„Y†o †X‚B");
 DrawMulitStrBox("¡¡‚l…aƒb vv …}ƒP ˆl„LRf ‰bƒU„S ‚_„iB, ‚^a @†]{ †onƒR b†afQ ŠGƒW ‰j…[ ƒe‚P‚h ‚XPM.");
talk(4,"@†], ‚rqeS ‚C‰J‚b RI‚b ƒ[‚_fQ ŠEƒG†yM.",
 6,"k.");
 MovePerson( 6,9,1);
 DecPerson(6);
 MovePerson( 5,0,3);
talk(5,"n„qŠi, ‚SŠS @†]fQ„V …bFS ‚Xa‡ILY. G b†a‚h ŠkƒmŠVKLY?");
 MovePerson( 4,0,2);
talk(4,"ƒ[Šl u^. b†a, ƒ_^ ^ƒa ˆ[‚b …x‚b ƒU„S HM. H‚b †q„beS ‚C‰a‚f.",
 5,"k, ‡N‚rWLM n„qŠi. MˆQ[†yKLM");
 MovePerson( 4,0,1);
 MovePerson( 5,2,1);
 MovePerson( 5,1,3);
 MovePerson( 5,10,1);
 DecPerson(5);
 NextEvent();
 end,
 [5]=function()
 JY.Smap={};
 SetSceneID(0);
talk(6,"…M! †u^ ƒ_^ b†a„V ˆfaM„lŠm? ^ƒa ‚Io ƒuƒb ƒvM!",
 5,"…fƒRG @†]S „_ƒd bƒGY‚C ƒi q „O†yƒv? ‚S‚O‚a‚C. aaa!!");
 NextEvent();
 end,
 [6]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="g]";
 JY.Base["D‚wC"]=1;
 AddPerson(10,25,9,1);
 AddPerson(9,20,9,1);
 AddPerson(12,11,10,3);
 AddPerson(13,7,12,3);
 AddPerson(16,24,17,2);
 AddPerson(8,20,19,2);
 AddPerson(3,1,14,3);
 AddPerson(2,3,13,3);
 AddPerson(1,3,14,3);
 SetSceneID(95);
 DrawStrBoxCenter("g] g~");
 DrawMulitStrBox("¡¡‚l…a ‰S‰r …BW‚TƒP …m‡WG @†]G Gˆa‚b ‚l…a‚TfQ OPM.*¡¡…BW‚Tƒb ‰Wƒ@f ƒEƒFM.");
 AddPerson(369,4,21,0);
 MovePerson( 369,8,0);
talk(369,"†_‚KŠ_ nŠnLM. @†]G Gˆa‚b ‚l…a‚TG ŠPƒR‚S…oLM.",
 10,"„a†yM. ‰b ƒQ‚TS ƒsƒ_†yM. ƒA…e^‚f.",
 369,"k."
 );
 MovePerson( 369,10,1);
 DecPerson(369);
talk(10,"ˆ|ƒb ƒ[u Pƒmƒv, †u‚w‚h ƒsƒ_…E Šo†M ˆ|j^?",
 9,"d…CƒR ‚ef @†]{ ŠGE …x^ „Om?",
 8,"‚^ˆaŠp‚C„V ƒOu ‚TƒP „@ƒm„S‚b @†]S ‡iBƒ_ƒG ‚SŠqm.",
 12,"„v†G ƒ_^ ‚TS Gˆnƒd ƒvƒW…E aƒv, ZŠr ˆuG Šo‚C ‚km.",
 9,"F‡} nID ‚a†M ˆ|j^?"
 );
 NextEvent();
 end,
 [7]=function()
 MovePerson( 1,4,3,
 2,4,3,
 3,5,3
 );
 MovePerson( 1,1,0,
 2,0,0,
 3,1,0
 );
 MovePerson( 1,2,0,
 2,1,0,
 3,1,0
 );
talk(1,"…fŠs ˆEd^ ƒv^†yKLM.",
 10,"‚G‚P, ƒ[‚_ ‡Df …m …xƒRƒb †u‚wZ?",
 13,"‚G‚PƒP ƒPˆEdj eƒO‡z ƒa‚PhLM.",
 12,"†q? ‚G‚PƒP e„LG‚f¡­ ‚G‚P‚d GŠKƒb ƒR‚S „v ƒLG ‚am. ‚_ƒaS ŠEƒmƒ`A ƒ[f ‚@ŠGƒb ƒN‡LG „O‚S…E a[.",
 13,"‚Cƒgƒb ƒwƒQ r‚Y…I ŠFhLM.",
 12,"I‡JG? oŠt ˆ|†M eu^ ‚SŠS G ƒn…IS ŠE†y‚b^? ƒA…e^‚f.",
 9,"ƒQƒH, ‡dŠu ƒGMu‚V[. ‚P…l ˆ|†MGƒv …fu ˆ|a‚b ƒuS ƒsA IˆA^ ˆ[‚b ƒU^ „OS ƒuG[.",
 12,"…M, …X‚M‚_„S a‚V[.",
 9,"Šom, ƒ[‚_ƒRfQ ŠEƒG†ym. ‚SƒW ƒe‚Pa‚V[. ‚TqƒBƒb …X‚MŠy ˆ`D…l a‚V[. b‰}‚f, D‚w‡F ‚KjS …d…e[H‚f.",
 13,"‚G‚P, G ‚r†vG D‚w‡F ‚KjG[. ‚TqƒBS ‚_ „{ ƒuG[.",
 13,"ƒ[uƒd …bF ‚Bf M‡M GƒR{ j‚r‚h ƒv†u‚S ‚[‚V[. „P „Vo m‚yS …VS‚CD ‚Z‚j[."
 );
 GetMoney(500);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [8]=function()
 if JY.Tid==10 then--Ô¬ÉÜ
talk(10,"@†]ƒb „o†_o …xGL v†da‚V[.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚^ƒZ „o†_ŠW ‰j„E ‚KƒG ƒU‚f[.");
 end
 if JY.Tid==12 then--Ô¬Êõ
talk(12,"…M, Šz‚~G nIu _„qŠ{ ŠPD OX ‡S‚XG‚C. ‚CƒgG‚fD ƒA…eE q „Om.");
 end
 if JY.Tid==8 then--¿×ÈÚ
talk(8,"ƒ[‚_ƒRƒb ƒs‚~Gƒd @†]ƒb ƒG‚~G[. ‚~TG M‚jL ‰j…[ „U ƒ[ „yG‚h ‚GŠ|a‚V[. ƒ[…e‚C ‚kƒmA ‡YB‚h …R ƒuG[.");
 end
 if JY.Tid==13 then--¹«Ëïè¶
talk(13,"ƒvD G‚W J‚Bf †~^a†ym. DˆlG Š}‚C ‚Z‚jL.");
 SetFlag(0,1);
 end
 if JY.Tid==16 then--ÌÕÇ«
talk(16,"ƒ_ ‚^‚_D †~^a†ym. ‰HŠ_ ƒLS Š~‚VM.");
 SetFlag(1,1);
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW …bFa‚V‚CZ. ƒe‚P^ „CA eƒO ˆEŠiŠ_ …I…e ‚K‡I‚V[.");
 end
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 PlayBGM(12);
talk(2,"…bF!");
 NextEvent();
 JY.Tid=-1;
 end
 end 
 end,
 [9]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(2,"ƒLƒb ‚rqef „OKLM. †PŠW g‚Ta‚V‚CZ.");
 NextEvent(); 
 end,
 [10]=function() --test½øÈëÕ½¶·
 WarIni();
 DefineWarMap(0,"ƒWƒa ‚rqe ‚B„e","1. @†] ˆL†U",30,0,5);
 -- id,x,y,d,ai
 SelectTerm(1,{
 0,22,9,3,0,-1,0,
 1,20,10,3,0,-1,0,
 2,20,9,3,0,-1,0,
 12,16,7,3,0,0,0,
 15,16,6,3,0,1,0,
 });
 SelectEnemy({
 5,3,9,4,2,5,7,0,0,-1,0,
 20,5,10,4,0,2,4,0,0,-1,0,
 21,4,9,4,0,2,1,0,0,-1,0,
 27,6,9,4,0,2,1,0,0,-1,0,
 256,11,8,4,0,1,1,0,0,-1,0,
 257,11,10,4,0,1,1,0,0,-1,0,
 258,11,12,4,0,1,1,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [11]=function() --testÕ½¶·ÊÂ¼ş
 PlayBGM(11);
talk(6,"o ‚W ‡iaƒdD FƒNS ˆf „y„~‚T. …BW‚TG ‡O @‚h …xƒ|a‚b‚wƒv. †u‚wƒP ‚^‚_Šm?",
 21,"‚Kƒaƒb ‚G‚P‚f‚b …xj ‡KWLM.",
 6,"‚G‚P? ƒR‚S „v ƒL ‚a‚b GŠKG‚T. ‚SŠS …f‹@ I‚XƒP ‹A†DŠY‚h ƒs„jƒv. ƒv‚h ‹Bƒs‚b ƒuGŠm?",
 21,"…BW‚Tf ‚r†vG ‚a‚b ‚Z†ohLM.",
 6,"†u‚wˆe Ce‚aM. ƒcS ƒq‚S ‹C_f d‚h ƒiu†yM. ‚B ƒa‚~ƒb …bFB ƒLS ŠGƒm‚f.",
 3,"ƒnˆEŠi, d^ ‰q…f ˆu ‹D ‹E†yKLM.",
 2,"ƒnˆEŠi, G …Iƒb dQ ŠEƒG‡I‚V[. …A…w‚V @†]ƒP ƒcS ƒq‚S [†yKLM.");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [12]=function(kind)
 if (not GetFlag(177)) and WarCheckLocation(-1,7,6) then
 	GetMoney(100);
 	PlayWavE(11);
 	DrawStrBoxCenter("‚Uƒg £±£°£°S ƒYƒC!");
 	SetFlag(177,1);
 end
 WarLocationItem(6,12,31,178); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¶¹
 --WarLocationItem(8,11,74,500); --»ñµÃµÀ¾ß:Ö±µ¶
 if WarMeet(2,6) then
 	WarAction(1,2,6);
	talk(2,"ŠGƒb„Kƒb @†]GŠ@M. ƒv‡z …I‚_…I„S „}ƒ^…x!",
	 6,"ƒ_Q D‚BoMƒd? †iG „^‚wƒv. GŠKS ‚_ƒd …G‚S‚f.",
	 2,"ƒv‚b eƒO, …x‚b ‡SƒaGM. @†], G eƒO^ ‚l…a‚TƒP †H†a‚h †@ŠH ‚[ƒd ƒs‚C ‚k†yM.",
 	6,"…M, ‚nƒo‚b ‚_†MaM„V o„If ‰}D I‚XƒP Šz†K„S‚T. ƒv‚h G†r q „O†y†sŠm?",
	 2,"‡NŠW ƒv‚h I‚XƒP Šz†K„S ƒsML. …ftƒm„S ƒsƒ_ ‚K…X.");
	 if fight(2,6)==1 then
		talk(2,"ƒ_ ‹FS …Hn‚f!");
 		WarAction(8,2,6);
 		WarAction(19,6,2);
		talk( 6,"‚_†Ma‚wƒv!",
	 	2,"@†]! „p ƒc…~S †E‚[†yM!");
 		WarAction(8,2,6);
 		WarAction(18,6);
		talk(2,"‰q…f @†]ƒP ƒcS ƒq„kM.");
 		WarLvUp(GetWarID(2));
		talk(3,"ƒnˆEŠi, eƒO^ @†]S ‹G ‚Z†ohLM.",
 		1,"‚M, ƒOu ‚TG G‹HM.");
 		PlayBGM(7);
 		DrawMulitStrBox("¡¡‚G‚P‚TG @†]‚TS IŠS‚jƒd ‚rqeS ‡F‚YPM.");
		bonus_moneyexp_4()
 		JY.Status=GAME_SMAP_AUTO;
 		NextEvent();
 	else
		talk(6,"ƒ_ ‹FS …Hn‚f!");
 		WarAction(4,6,2);
 		WarAction(19,2,6);
		talk(2,"‚_†Ma‚wƒv!",
 		6,"eƒO! „p ƒc…~S †E‚[†yM!");
 		WarAction(4,6,2);
 		WarAction(18,2);
		talk(6,"‰q…f eƒOƒP ƒcS ƒq„kM.");
 		WarLvUp(GetWarID(6));
 		DrawMulitStrBox("¡¡‚G‚P‚TG @†]‚TfQ OPM.");
 		JY.Status=GAME_SMAP_AUTO;
 		NextEvent(999);
 	end
 end
 if JY.Status==GAME_WARWIN then
	talk(1,"ƒOu ‚TG G‹HM.");
 	PlayBGM(7);
 	DrawMulitStrBox("¡¡‚G‚P‚TG @†]‚TS IŠS‚jƒd ‚rqeS ‡F‚YPM.");
	bonus_moneyexp_8()
 	JY.Status=GAME_SMAP_AUTO;
 	NextEvent();
 end
 end,
 [13]=function()
 SetSceneID(0,3);
talk(2,"ƒLG ‹I‹J †q„beƒm„S ˆGn‚q ‡KWLM. ƒnˆEŠi, ‚SŠSXYZ?",
 1,"…I†M ‚TS †E‚[…x.",
 3,"I‡H ˆ|Š[hLY? ‚CƒgG…Eˆ|„S tƒo‚h …@ƒd …c‚pX „U‚CZ. d^ ^†yKLM!",
 2,"GƒsQ! ƒa‚P! ƒ@„xŠW ˆl„LG‚C ˆ|Q!",
 3,"…c‚pa‚f! „T…{ …c‚pa‚f!"
 );
talk(2,"‚S‡m! ‹Kn^ „q„~‚T. b‚BŠW …fu …f‰BƒLG‚fL.");
 if GetFlag(0) then
talk(13,"ƒ[u ˆ|Š[aN ƒu ‚aKLM. ƒOu ‚TƒP ‚rƒGD ƒi„g‚C ‚kKLY.");
 end
 if GetFlag(1) then
talk(16,"‚Cƒgƒb ƒGƒo‚h …@ƒd †q„beS ŠP…E WLM.");
 end
talk(1,"a‚b q ‚a‚T. ŠoM! ƒa‚P‚h ‡D‚i‚j‚f! †q„beƒm„S g‚ToM!");
 NextEvent();
 end,
 [14]=function()
 --61 ´¢´æ½ø¶È:Õ½³¡´æÅÌ
 --46 ÇĞ»»³¡¾°:ÇĞ»»³¡¾°µ½<4>
 NextEvent();
 end,
[15]=function()
change_mode()
 WarIni();
 DefineWarMap(1,"ƒWƒa †q„be ‚B„e","1. b†a ‚p…D",30,0,4);
 -- id,x,y,d,ai
 SelectTerm(1,{
 0,15,21,2,0,-1,0,
 1,13,21,2,0,-1,0,
 2,12,20,2,0,-1,0,
 12,14,18,2,0,0,0,
 15,13,18,2,0,1,0,
 });
 SelectEnemy({
 4,6,5,1,2,6,7,0,0,-1,0,
 79,3,7,1,0,3,23,0,0,-1,0,
 80,6,8,1,0,3,7,0,0,-1,0,
 74,10,8,1,0,3,4,0,0,-1,0,
 73,10,11,1,1,2,1,0,0,-1,0,
 274,8,8,1,0,1,4,0,0,-1,0,
 275,5,11,1,1,1,4,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [16]=function()
 PlayBGM(11);
talk(5,"I‡JG? …BW‚TG ŠPƒR‚S[ƒd @†]Y‚C …GŠbMƒd? dˆFG‚wƒv. ‡mƒv ƒ[ƒRƒP ‡SD bƒGY‚CM.",
 81,"b†a ƒa‚T, Gd ƒOu ‚TƒP IƒWˆlS ƒsb ‹L‚VM.",
 5,"ŠoM, ‚B‚T …b‚p! …BW‚TGb, ƒ_ ‹MƒT‚h ‹N‹NŠW ƒsn‚f.",
 3,"ƒLƒaƒb ‚SƒZ „O†sŠm? eƒO ˆEŠiŠ_„V ‚JS „|†r q‚b ‚a‚C. ƒvD o‹P ‹Q†yM.",
 2,"G‡Eƒb b†a^ ‚C‰J‚b ‡KWLM.",
 1,"b†a„S‚T. ƒ[ƒsM IƒW‡S ƒLƒb n…X ‚aS ƒuGM.",
 2,"b†a^ „d ƒL‰S…X‚b aƒ^f ‚s u‚h ˆGƒjMƒd WLM.",
 3,"b†a^ ‚_qŠm? ƒ_ ‹MƒT‚h ƒsb ‚K…X.");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [17]=function()
 if WarMeet(3,5) then
 WarAction(1,3,5);
talk(3,"ŠGƒb„Kƒb b†aŠ@M. ƒv‡z t‚^‚h „}ƒ^…x!",
 5,"‡NŠW ƒ_Q D‚Ba‚b …x^ ‡O „O†sŠm! GŠKS ‚_‚f!",
 3,"ƒv‚b ‚G‚PƒP nƒO ƒa‚P, …x‚b …S‡VGM! b†a! „p ƒcS †E‚[†yM!",
 5,"aa! I‚XƒP Šz†K^ †iG „^‚wƒv. G b†a^ C‚_B ‚K…X. ‹R‹S‚f!",
 3,"ƒv‚h ‹Bƒs‚C …X‚f. …C‚}aQ Š} ƒuGM.");
 if fight(3,5)==1 then
talk(5,"dˆF ‹MƒT^ „O‚wƒv.",
 3,"{…B „o‚r„S‚T. ‡mƒv G †gS ‰XX q „O†y†sŠm?");
 WarAction(9,3,5);
talk(5,"ƒSˆc‚C …X‚f!");

talk(1,"ƒa‚P, ƒOu^ ‰I†yM.",
 2,"b†a, „p ‚sƒLG ŠXM.",
 5,"ƒQ‚TG ŠX‚T. a‚b q ‚aM, ƒA…e‚qM. ƒL‰S…E, H„V ˆ[‚bM.");
 WarMoveTo(5,6,0);
talk(3,"ˆGnƒv‚C …X‚f! b†a! ƒW‚f!",
 2,"{…B ƒL‰S…X„S‚T. D…fŠW ‚i‚f‹QS q ‚aM.");
talk(5,"‚B‚T …C…D.");
 WarAction(16,5);
 WarLvUp(GetWarID(3));
 NextEvent();
 else
talk(5,"dˆF ‹MƒT^ „O‚wƒv. ‡mƒv G „N‚sˆpS ‰XX q „O†y†sŠm?");
 WarAction(8,5,3);
WarAction(19,3,5);
 --WarAction(17,3);
 --WarLvUp(GetWarID(5));
 --talk( 1,"ÈıµÜ£¡",
 -- 2,"¿É¶ñ£¡",
 -- 5,"¹ş¹ş¹ş£¡Ò»ÆğÉÏ°É£¡");
talk(3,"ƒSˆc‚C …X‚f!");
talk(1,"ƒa‚P, ƒOu^ ‰I†yM.",
 2,"b†a, „p ‚sƒLG ŠXM.",
 5,"ƒQ‚TG ŠX‚T. a‚b q ‚aM, ƒA…e‚qM. ƒL‰S…E, H„V ˆ[‚bM.");
 WarMoveTo(5,6,0);
talk(3,"ˆGnƒv‚C …X‚f! b†a! ƒW‚f!",
 2,"{…B ƒL‰S…X„S‚T. D…fŠW ‚i‚f‹QS q ‚aM.");
talk(5,"‚B‚T …C…D.");
 WarAction(16,5);
 --WarLvUp(GetWarID(3));
 NextEvent();
 end
 
 end
 if (not GetFlag(1001)) and War.Turn==18 then
talk(5,"…M! †Pvo ‚^‚_„Qƒd‚b dˆFG‚T. ‡mƒv G ˆuG …f‹@ ‹A†DŠYƒRfQ ‹T u ‚a‚C. ƒ_ IƒWˆlS „aQ B ‚K…X.");
 WarModifyAI(4,1);
 SetFlag(1001,1);
 end
 if JY.Status==GAME_WARWIN then
talk(5,"‹U‹Va‚wƒv! ‚S‹W q ‚aM, ‚B‚T …C…D.",
 1,"B„jM! ƒOu^ b†a‚h ƒAu‡RM.");
 NextEvent();
 end
 WarLocationItem(10,13,41,59); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º½¹ÈÈÊé
 WarLocationItem(11,14,31,179); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¶¹
 --WarLocationItem(17,12,147,501); --»ñµÃµÀ¾ß:ÊÖÅÆ
 end,
 [18]=function()
 PlayBGM(7);
 DrawMulitStrBox("¡¡b†a‚TG ƒA…eƒvƒd ‚G‚P‚TG †q„beS ‡F‚YPM.");
 GetMoney(100);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°S ƒYƒC!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [19]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="„Y†o";
 JY.Base["D‚wC"]=0;
 AddPerson(383,27,8,1);
 AddPerson(4,19,12,0);
 AddPerson(7,17,13,0);
 AddPerson(21,25,15,2);
 AddPerson(22,23,16,2);
 AddPerson(28,21,17,2);
 AddPerson(384,14,9,3);
 AddPerson(47,12,10,3);
 AddPerson(48,10,11,3);
 
 SetSceneID(89,11);
 DrawStrBoxCenter("„Y†o †X‚B");
 DrawMulitStrBox("¡¡‚l…afQ ‚rqe{ †q„beƒP ‰Hˆyƒb ‚e‚_o …IG„kM.*¡¡‚l…aƒb ‡qd‚h ŠYƒd „Y†oS ‹XƒvƒG„S PM.");
talk(4,"ŠDa‚h ƒYu‚b …xƒRG „Y†o ^YG ŠXKLM. ‚rFG G…eaL „Y†oS ‹Xƒv‚V‚CZ.",
 383,"I‡JG‚f? „Y†oƒb k„S‚^ƒh dD„SƒW ‚Wƒ{B †[ ‡EGM. ƒ[ƒuS „qu…x‚b ˆ|GŠm?",
 4,"„Nƒg o ˆ|S „anŠ^‚C ˆfaƒN ‚Z†oG‚TZ. o ‚W „l „C‹EGB…E WLY?",
 383,"ƒ[, ‰cG „a†yƒY‚f. ƒ[‚_ ˆ|‚_„S a‚f!",
 4,"ƒNƒP gˆAS …Hn ‚K‚VL ‡N‚ra…oLM. ƒ[†{ ‚SƒW ‹Xƒv‚V‚CZ!");
 MovePerson( 4,2,1);
 MovePerson( 4,7,1,
 7,7,1);
talk(4,"†~, G‚G. „Y†oS „A„AŠW ƒL‚TfQ „|†r q‚b ‚aM. „Y†oS …d‚|ƒOƒd ƒ{‚oƒP ƒgƒbƒs@‚h ‚Zvu †E‚[‚S‚f.",
 7,"k!");
 DecPerson(4);
 DecPerson(7);
 MovePerson( 21,9,1,
 22,9,1,
 28,9,1,
 47,9,1,
 48,9,1);
 DecPerson(21);
 DecPerson(22);
 DecPerson(28);
 DecPerson(47);
 DecPerson(48);
 PlayBGM(2);
talk(383,"…md‚Vb! G IƒM‰HS „oƒWamƒW! …mv^ ƒAƒ`‚KƒN G ˆmS ‚C‰J‚C ˆfPƒmL, oNƒP ƒG†nG ƒ_ ‡YfƒW IHg†M ˆ|j^?",
 384,"ŠDa¡­");
 LoadPic(28,1);
 DrawMulitStrBox("¡¡Guab ‚l…aƒb oƒP D‹YS „Y†ofƒW ƒa‚oƒm„S ‹Z‹HM. o ‡ev‚b ‚l…aƒP ‚B†Hƒm„S ‹[S †YB ^ƒd „O„kM.");
 LoadPic(28,2);
 NextEvent();
 end,
 [20]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†q„be";
 JY.Base["D‚wC"]=0;
 AddPerson(10,25,9,1);
 AddPerson(9,20,9,1);
 AddPerson(12,11,10,3);
 AddPerson(13,7,12,3);
 AddPerson(16,24,17,2);
 AddPerson(8,20,19,2);
 AddPerson(3,1,14,3);
 AddPerson(2,3,13,3);
 AddPerson(1,3,14,3);
 SetSceneID(95);
 DrawStrBoxCenter("†q„be g~");
 DrawMulitStrBox("¡¡‚rqe{ †q„beS ‰Hˆyaƒd tuf lB „OŠB vv …} ‰S‰r …BW‚TfQ, ‚l…aG ‡qd‚h ŠYƒd ˆGnŠgM‚b m‚yG ‚BBƒFM.");
talk(9,"‚l…aG „Y†o ƒW‹J ƒa‚oƒm„S ˆGnŠgM a[. ‚Cƒg ‡iƒa …c‚pB…E a[.",
 10,"nL[. …BGƒb ‰jˆlƒm„S ‚~‚rƒRG ‚C‡Rm. ‚Cƒgƒb bƒGƒW ‹]‚S…E a[.",
 9,"‡mƒv ‚BƒG‚h ‹Qn…E a[. G Šoƒb ƒG‚}‚h ‹^„QA G†r ƒG‚}‚b ‚am.");
talk(12,"ƒ[u ‹Kƒd Š]†Eˆe ƒ[‚_ ‚c…x ^‚V[.",
 13,"‚~‚rƒRG ‚Cˆj ƒuD ‚rNG[.",
 9,"ƒOu‚b }ƒLS „QƒG ‚nB ‚TS …Iƒm…sm. ƒ[‹@…h ‚l…aS ‹K‚b ƒuv„y …XMoMA ‚saƒP †eƒ{G NˆoX ƒuG[.",
 9,"G‡Ef‚b ƒv‡z ƒ]S „GGX …x^ ‚a‚wƒ`. ƒv‚b ~‚C„S ‰Bn^†ym. G„V ƒA…e^[.");
 MovePerson( 9,11,1);
 DecPerson(9);
 NextEvent();
 end,
 [21]=function()
talk(12,"ƒ]S „GGaML I‡H mƒj^. ‚X…Z^ …bƒND n†m ‚Kdf w„N‚C‚wƒv.",
 10,"‡mƒv vv‚f‚b ‚e†d jƒAG ‚aƒmA G …BW‚Tƒb ƒP†w^ ‚am.");
talk(8,"‚G‚P, ƒG‚}^ „CA M‚V „V‹_‚VM.");
 MovePerson( 8,9,1);
 DecPerson(8);
talk(16,"‚G‚P‚b ‹`ƒS ƒn…IS G‹a ƒuG[. aaa! ŠRƒbGƒP ˆN†iGL †KƒP„Q …X‚V[. ƒ[†{ G„V ^†ym.");
 MovePerson( 16,9,1);
 DecPerson(16);
talk(13,"ƒ[†{ ƒOuD ƒA…e‹_‚VM.",
 2,"ƒ[ŠQ‚TZ.");
 NextEvent();
 end,
 [22]=function()
 JY.Smap={};
 SetSceneID(0);
talk(13,"ƒ[†{ ‚G‚P, ‡O ‹b‚VM. I‡H …IG „OƒmA ˆAdˆe ƒ_Q ˆ|a‚V[.",
 1,"ƒ[†{ ƒvD G„V ^†ym.",
 13,"ƒ[ŠQ‚TZ."
 );
 DrawMulitStrBox("¡¡Guab ‚l…a ‰S‰r …BW‚Tƒb B„[PM. †E‚_o o ‡ev‚b ‚l…aƒP …}ƒaƒm„S †UˆoƒP †r„S ‰n‚SƒR„kM.*¡¡G ‚qƒof ‚sa‚h ƒYu‚b …x‚b ‚l…a„VG nL„kM. vv^ „Oƒd, ƒQmD „O„kƒmL¡­¡­");
 DrawMulitStrBox("¡¡G ‚qƒofƒW ‚G‚P …I‚]ƒb ‚S‹cQ ŠGE ƒuj^. ƒ[uƒd oNS „C†juƒ`‚b |ˆEdƒP ‹dƒb Gƒ^‚S‹T ƒuj^.");
 NextEvent();
 end,
 --ĞòÕÂ½áÊø
 --µÚÒ»ÕÂ¡¡½çÇÅÖ®Õ½
 [23]=function()
 --Dark();
 --PlayBGM(0);
 --DrawSMap();
 --Light();
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d1ƒa¡¡„T„W ‚B„e";
 DrawStrBoxCenter("d1ƒa¡¡„T„W ‚B„e");
 LoadPic(4,1);
 DrawMulitStrBox("‚l…aS „Qƒd…x ‚ZŠbŠB ‚T†]ƒb …BW‚TG ‹e‚S‚C…x ‚E…x ~‚C„S ‰Bn‰tM. †_‚K ƒQm‚b „T‚vƒm„S o‚DƒP ƒG‚K‚h Šf„hn †nƒ{S †Z†E‚C„S |‚b ƒn ƒoƒ}S Gƒ^„kM.");
 DrawMulitStrBox("ƒG‚K‚h ‡Yf †pƒb ƒQm‚b G‚S ‚J‡Y‡ZƒP ~‚C‚h ƒYuƒG ‚VJPM. ƒQm‚b ‚J‡Y‡ZƒP ~‚C‡z ŠG‹fƒb „T„Wf ‚_‚TS †L†@‚V…sM.");
 LoadPic(4,2);
 --PlayBGM(11);
 SetSceneID(0,11);
talk(10,"ŠoM, ‚J‡Y‡ZS IH„]ƒ`‚f! ‡kƒwS …VƒmA ‡k‹J …Y…AG ƒ_ ƒuG ˆYM. ‚[ ‡y†G„S ƒv†u‚S ‡kƒwS „Q„C, ƒaWƒb †E…lƒm„S, }ƒP‚b ‰Ra„S g‚pa‚f.",
 103,"k! ‰bƒU„S †E…lS „Q†yKLM!",
 61,"ƒ[†{ …f‚b ‰Ra„S ‚TS ‹gLM.");
 Dark();
 PlayBGM(3);
 DrawSMap();
 Light();
talk(13,"ƒQm^ ŠPƒR‚S…oLM!",
 60,"ƒ[ŠQKLM. }ƒ@ƒP „T„WfƒW …b_B ‰Ra‡z †E…l ‚[ ‡y†G„S ‹hƒ`[ƒd „OKLM.",
 13,"‡m‚S¡­¡­. ƒ[†{ ‡n‚I, ƒ[‚_‚b ‚TS Gˆnƒd ‰Ra„S ^‚f. ƒv‚b †E…lƒm„S g‚ToM. ˆzT ƒc…q‚b „T„WM. ƒQm‚h ƒq‚S‚f.",
 60,"k!");
 PlayBGM(0);
 DrawMulitStrBox("‚[ ‚Tƒb ‰Ra‡z †E…lfƒW ‚_„Qa†B ƒW„SƒP ˆl„LRS †j‹iM. }ƒ@S ‚rGf ‰Q ‚_„Q‚b b…e ˆG G‚SƒFM.");
 NextEvent();
 end,
 [24]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒwƒQ";
 JY.Base["D‚wC"]=2; --ÓÃµÄÊÇ±±Æ½µÄÉÌµê£¬Êµ¼ÊÆ½Ô­Ã»ÓĞÉÌµê
 AddPerson(1,25,17,2);
 AddPerson(2,20,9,1);
 AddPerson(3,11,16,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒwƒQ ƒP‚r‰R");
talk(2,"ˆEŠi, ‚J‡Y‡Z‚T{ ƒQm‚TG ‚_„Qo ‚C ‹j [†G‹kKLM.",
 3,"G‚_„S „T…{ ‚_„Q„V aƒ`‚b ‚@YZ?",
 2,"ƒ[Šl u ‚aM. ‚Cƒgƒb †o‹J M Fƒs‚BS ‰rG‚b ‚eGL Šc‚C‚kn ‰jˆlG ‰r‚S‹T ƒuGM.",
 3,"…M, ƒv‚b ‚Z‚j†ym.",
 2,"‹l‰Ro ƒu! ‚_ƒaG Iƒ}„Vƒm„S „C†y†sŠm. ‚C‡z „oS ‡[‚PB…E †~ˆY ‚_ƒaG‚C. ƒ[ŠQ‚C ‚kKLY, ˆEŠi.",
 1,"ƒA‹mGM.",
 3,"‡m, ƒ[†{ ƒnˆEŠiD ƒX ƒ[ Fƒs‚Bj^ a‚b ‚@ a‡ILY?",
 1,"ƒA‹mGM. ‚Cƒg ƒ{‚oS Še…eƒs†B ‚KˆMƒRfQƒW m‚yS „an…R †~GM.",
 2,"{…B ˆEŠiG‡ILM. Šoƒb …Iƒb ƒWŠe…e…E‚CZ. …f‡z ƒa‚P^ †LS ‚C‰J†yKLM. …IG `ƒGA ‚^‚j…e ^†yKLM."
 );
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<ËÑ¼¯Çé±¨>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [25]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"I‡H …IG „OƒmA ‚^‚j…e ^†yKLM.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒ{‚of‚b ‚K‡f‹n†{ ‚r†vG ‚ZG‚b ‡EG „OKLM. m‚yS …Vƒmƒ`A ‚r†v ‡Aƒb ‡EG ‹o‚CZ.");
 --
talk(2,"ˆEŠi, …y‡rG‚f‚b …x^ ˆEŠiS ‹p†yMƒd ‹qnŠXKLM.");
 AddPerson(83,2,4,0);
 MovePerson( 83,8,3);
 NextEvent();
 JY.Tid=-1;
 end
 end,
 [26]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠiŠ_ƒW ˆ|Š[a‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…f‚b ŠU ‚Z‚j†yKLM. ƒnˆEŠiŠ_ƒW „ND‚h ƒ_‡I‚V[.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚G‚PŠi, …f‚b …y‡rG‚f WLM. †O‰Hƒb …SŠW ƒR„kKLM. GŠQQ ‹qn‡z ˆuS ƒP…aaƒd…x aL †E‚[‚S ‚K‡I‚V[.");
 ModifyForce(83,1);
 PlayWavE(11);
 DrawStrBoxCenter("…y‡rG ‚G‚PƒP ‚^a^ „C„kM!");
 AddPerson(365,-1,4,0);
 MovePerson( 365,6,3);
 PlayBGM(11);
talk(365,"‚G‚PŠi, †hJƒ~‚R ‹qn‹pKLM. ‚J‡Y‡ZŠ_ƒW ƒsˆZ ‚r…xhLM. ƒQ‚TS ‰Ra…e ŠXKLM.");
 NextEvent();
 JY.Tid=-1;
 end
 end,
 [27]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚r…xƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚r…xƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚J‡Y‡ZfQ I‡H …IG `‹Hm?");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(1,"‚r…xb! ƒQm‚TG „T„WfƒW ‚l‹Jƒm„S „T…{ g‚ToM ƒR„k‚b…h¡­¡­",
 365,"ƒ[ŠQKLM. ƒQm‚TG G†w ‡Aƒb ~‰S‚h Šf„hƒd „l ‰KG ‹hƒd ƒR‚S[ƒd „OKLM. …fŠs ‚K‚JŠ_ƒW‚b ‡kƒwfƒW …b‚~aŠVKLM.",
 1,"ƒ[†GƒW ‚B‚Uƒb ‚S‹cm?",
 365,"‚K‚JŠ_ƒW Gˆa‚b ‚Kƒ}ƒb „T„WfƒW, ‚J‡Y‡c‚T{ ‡n‚I‚Tƒb ‚E‚E †E…l{ ‰RafƒW ‰jƒOƒd „Oƒmƒv ˆEƒo^ Šo‚C ‚kKLM. ‚G‚PŠi, ‚^ƒZ …fŠs‚h D‡z‚K‡I‚V[.",
 3,"‚J‡Y‡ZG ‚n‚|„BKLM. ƒnˆEŠi, ‚SƒW DƒO…e ^‚V‚CZ.",
 1,"„a†ym. ‚r…x‚b ‰Bn^ ‚J‡Y‡ZŠ_ ‰b ‚CƒQa…e ^†yMƒd ‚Ba‚V[.",
 365,"[, ‡N‚rWLM.",
 83,"‚K‚J, „T„W„S ^ƒ`A ƒwƒQfƒW ‚[ †rG „OKLM. aƒv‚b ‚H‚sS ‚Cƒvƒd, aƒv‚b ƒNDƒ{S ‚C‹_LM.",
 1,"‚M, ‚H‚s{ ƒNDƒ{G‚f. ‚S†s ‹Jƒm„S ^…E aƒv?",
 83,"ƒNDƒ{ƒm„S ^A „T„WY‚C ‹D ‰Bn^‚C„V D‚w‡FG „OƒmL ‹r‹rŠW …^„E ‚[‚b „KG ŠoKLM.",
 3,"n„LD ƒ[ G…EƒGhLY. ƒWŠe…e ^‚C ‚kƒmA ‚J‡Y‡ZG ‚n…UWLM. ƒnˆEŠi, ‚SƒW ^‚V‚CZ.",
 2,"ƒe‚P^ „CA …d…e ‚K‡I‚V[. …f‚b D‚w‡Ff ^ƒW ‚~ƒG‚h ‹D ‚r [†yKLM.",
 83,"‚J‡Y‡ZƒP †Z†E‚C ‡kƒwfƒW ‚~ƒG‚h †V‚b ‡KWLM. ‡kƒwƒb ƒwƒQƒP ‡k‹Jf „OKLM.");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥Ö§Ô®¹«Ëïè¶>
 NextEvent();
 JY.Tid=-1;
 end;
 end,
 [28]=function()
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
talk(2,"ƒ[†{ …b_a…x.");
 PlayBGM(12);
 NextEvent();
 JY.Status=GAME_SMAP_AUTO;
 end
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚SƒW …b_a‚V‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"bƒGƒW „T„W„S ^ƒ`A ‚H‚sGƒv ƒNDƒ{ ‚e o ‡ES ‚Cƒv…E WLM.");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(365,"‚G‚PŠi, ‚^ƒZ ƒWŠe…e DƒO…e ^ ‚K‡I‚V[.");
 end;
 end,
 [29]=function()
 JY.Smap={};
 SetSceneID(0);
talk(2,"ˆEŠi, ‚H‚s †r„S ^‚V†yKLY, ƒNDƒ{ †r„S ^‚V†yKLY?");
 NextEvent();
 end,
 [30]=function()
 local menu={
 {" ƒNDƒ{ƒm„S",nil,1},
 {"¡¡‚H‚sƒm„S",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
 NextEvent(); --goto 31
 elseif r==2 then
 NextEvent(40); --goto 40
 end
 end,
 [31]=function()
talk(2,"ƒNDƒ{ƒm„S …yM. ‚_‚AS ‹s‹t‚f!");
 WarIni();
 DefineWarMap(3,"d1ƒa ƒNDƒ{ ‚B„e","1. „AƒOƒ@ ‚p…D*2. ‚G‚P^ ƒ{…Z DˆG",30,0,105);
 SelectTerm(1,{
 0,21,7,3,0,-1,0,
 -1,20,6,3,0,-1,0,
 -1,20,8,3,0,-1,0,
 -1,21,5,3,0,-1,0,
 220,1,0,1,0,-1,0,
 245,3,0,3,0,-1,0,
 244,0,0,4,0,-1,0,
 });
 SetSceneID(0,11);
talk(10,"„AƒOƒ@, ƒ[‚_‚b ƒNDƒ{ƒm„S ^ ‚J‡Y‡ZƒP †c…C‚h ‚S‚CŠp‹u‚f.",
 106,"k.",
 106,"ƒa‚~ƒRGb! ‚J‡Y‡ZƒP †c…C„S ‰Bn^ ƒNDƒ{S ˆjM! ‚i‚j‚f!");
 SetSceneID(0);
talk(13,"I‡JG! ƒQm‚TG ƒOu †c…C‚h ˆjMƒd? ƒn…IG‚T! ƒ[ŠQMA ƒOu‚b ƒQmƒP „vgS ˆjM! „T„W„S g‚pa‚f!");
 SetSceneID(0,3);
talk(2,"ƒNDƒ{ƒm„S g‚Ta…x!");
NextEvent();
end,
[32]=function()
 SelectEnemy({
 105,1,4,2,4,8,7,7,3,-1,0,
 256,8,3,3,4,4,1,9,4,-1,0,
 257,4,6,2,4,4,1,9,9,-1,0,
 258,7,1,3,0,4,1,0,0,-1,0,
 292,7,4,3,1,1,7,0,0,-1,0,
 293,5,4,3,4,1,7,8,3,-1,0,
 274,0,4,2,4,3,4,2,4,-1,0,
 310,4,7,2,4,2,10,9,9,-1,0,
 311,6,3,3,1,2,10,0,0,-1,0,
 328,3,3,3,4,3,13,8,2,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
end,
 [33]=function()
 PlayBGM(11);
 DrawStrBoxCenter("ƒNDƒ{");
talk(221,"„l‚b ‚C‡Q q ‚a†yM¡­¡­ ƒQm‚TG ‚SŠS bƒGf ƒv…@Šg†M ˆ|j^.",
 106,"ŠoM. ƒNDƒ{G ‰b „n‚SgM. ‚Z‚[ „@S „l ƒ_‚f.",
 2,"ˆEŠi, ƒQm‚Tj ‡KWLM. ƒNDƒ{G ƒQm‚TƒP K‚pS …Hƒd „OKLM.",
 83,"ƒQm‚TG ‚SŠS bƒGY‚C ŠX†M ˆ|j^? ‚J‡Y‡Zƒb ‚SŠS „C„kS‹v.",
 106,"‡m, …fw ‚SƒZ ‚^‚_Šm? ƒwƒQƒP ‚G‚P‚T „Gƒb…h, ‚G‚P^ ‚SŠS bƒGf? Ce‚aM, G†~f ‚G‚P‚h ƒq†yM! ‚B‚T! ‚G‚P‚TS ŠP‚f.",
 3,"ƒnˆEŠi, ƒQm‚TG ŠPƒR‚S…oLM.",
 2,"ˆEŠi, ƒNDƒ{S ‚wa‚V‚CZ. ƒ{„V ‚C‰aƒ_A ƒQm‚Tƒb ƒA…eƒS q‹wf ‚aKLM. ƒ{…Zƒm„S ŠP ƒv^‚V‚CZ!");
 WarShowTarget(true);
 
 WarModifyAI(245,2);
 WarModifyAI(220,2);
 WarModifyAI(244,2);
 PlayBGM(9);
 NextEvent();
 end,
 [34]=function()
 if (not GetFlag(1002)) and War.Turn==3 then
 WarModifyAI(105,2);
 WarModifyAI(257,1);
 WarModifyAI(310,1);
 SetFlag(1002,1);
 end
 if (not GetFlag(1003)) and War.Turn==14 then
 WarModifyAI(105,1);
 SetFlag(1003,1);
 end
 if WarMeet(3,106) then
 WarAction(1,3,106);
talk(3,"ƒLƒaƒb †u‚wŠm? GƒsQ, ƒv‚b ƒa‚PM. †u^ ƒv‡z „}ƒ^†y†sŠm!",
 106,"ŠoM, ƒU‚fŠB ƒUM.");
 if fight(3,106)==1 then
 WarAction(4,3,106);
 WarAction(19,106,3);
talk(106,"G¡­¡­! G‰S…l ‚IaML¡­¡­",
 3,"ƒ[ FD Nƒ}ƒm„S‚b ƒv‚h G†r q ‚aM!");
talk(106,"‡iB‰M q^ ‚a‚wƒv. dƒGŠJ, Du ‚aM. ˆGnƒv‚b Q C‚uGM.");
 WarAction(16,106);
 WarLvUp(GetWarID(3));
 NextEvent();
 else
talk(106,"ƒa‚P! ƒq‚S‚f!");
 WarAction(8,106,3);
 WarAction(17,3);
 WarLvUp(GetWarID(106));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 if (not GetFlag(61)) and WarCheckLocation(-1,5,6) then
 GetMoney(100);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°S ƒYƒC!")
 SetFlag(61,1);
 end
 WarLocationItem(7,9,28,181); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¾Æ
 --WarLocationItem(5,11,140,502); --»ñµÃµÀ¾ß:Æ¤¼×
 if WarCheckLocation(0,3,1) then
talk(106,"dƒGŠJ, vƒg„V „l ‹hA ‰Hˆyj…h. ‚S‹W q ‚aG ‚B‚T …C…DM!");
 PlayBGM(7);
 DrawMulitStrBox("„AƒOƒ@G ƒA…eŠgM. ‚G‚P‚TG ƒQm‚TS I‹xŠjM.");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £²£°£°S ƒYƒC!")
 WarGetExp();
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(36);
 end 
 end,
 [35]=function()
talk(106,"dƒGŠJ, vƒg„V „l ‹hA ‰Hˆyj…h. ‚S‹W q ‚aG ‚B‚T …C…DM!");
 PlayBGM(7);
 DrawMulitStrBox("„AƒOƒ@G ƒA…eŠgM. ‚G‚P‚TG ƒQm‚TS I‹xŠjM.");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £²£°£°S ƒYƒC!")
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [36]=function()
 SetSceneID(0,3);
talk(2,"ˆEŠi, ƒQm‚TG ƒA…e‚q ‡KWLM.",
 1,"‡mƒv ƒQm‚TG bƒGY‚C ŠZ‚l‚_‚h ƒs‰M FD‚fL, ‚B‚UG Šo‚C ‚kƒb ‚Z†oGM.",
 83,"Šo‚C ‚kƒb ‡KWLM. ƒO…m ƒNDƒ{ƒm„S …w‚V‚CZ.");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<½øĞÅ¶¼³Ç>
 NextEvent();
 end,
 [37]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒND";
 JY.Base["D‚wC"]=3;
 AddPerson(1,10,17,0);
 AddPerson(2,11,9,3);
 AddPerson(3,25,17,2);
 AddPerson(83,27,16,2);
 AddPerson(221,19,12,1);
 SetSceneID(87,5);
 DrawStrBoxCenter("ƒND ƒP‚r‰R");
talk(221,"‚G‚PŠi, ƒND‚h ‚wB ‚K‚VL †~ƒm„S ‡N‚rWLM.",
 1,"ƒd…X„EX ƒu ‚am. …Xƒl ƒND‚h ‚CƒvŠB †~G„km.",
 221,"¡­¡­",
 1,"ƒOu‚b ‚J‡Y‡ZS DƒO…e ^‚b †rf ƒND‚h ‚Cƒvƒ`M G‡EG ‚J‚p…H‚b ƒuS ƒsƒtm.",
 221,"[, ¡­¡­ ‚G‚PŠi, ƒND‚h ‚wB ‚KƒN ƒbƒp‚h ‹yƒd…x …fD ƒQ‚Tf ŠY„E ‚K‡I‚V[.");
 ModifyForce(221,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚W†XG ‚G‚P‚Tf ^†iPM!");
talk(2,"ƒ[†{ ˆEŠi, ‚SƒW ‚CƒQa…e ^‚V‚CZ. ƒe‚P„C‚VA ˆ|Š[B ‚K‡I‚V[.");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥Ö§Ô®¹«Ëïè¶>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [38]=function()
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
 NextEvent();
 JY.Status=GAME_SMAP_AUTO;
 end
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚Cƒg ‹Xƒv‚C ‚kƒmA ‹zS‚CD ‚Z‹{LM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚K‚J, ‹XƒvƒG ‚Bf ‚~ƒG‚h „V…w‚b D‚w‡FS Še…eƒs‚V‚b Q ‚S‹c†yKLY?");
 end
 if JY.Tid==221 then--·ª¹¬
talk(221,"ƒvD ƒ[‚_ƒRƒP ƒQ‚Tf †~^a†ym.");
 end;
 end,
 [39]=function()
 JY.Smap={};
 SetSceneID(0,12);
talk(2,"ˆEŠi, ‚SƒW DƒO…e ^‚V‚CZ.",
 1,"…y‡r, bƒGƒW „T„WY‚C‚b ^‡P†y‚C?",
 83,"ƒ[u ^‡P‚C ‚kKLM. bƒGƒW „T„WY‚C‚b ‚[ †rG „O‚b…h, aƒv‚b ‰Ra‚h ‚Cƒvƒd M‡M aƒv‚b †E…lS ‚C‹_LM.",
 1,"‰Ra‡z †E…lG‚f. ‚S†s †r„S ^D „T„Wf G‚j‚b^?",
 83,"ƒ[ŠQKLM.",
 2,"‡mƒv ƒQm‚TG bƒGY‚C ‚~ƒ}S ƒs„jƒmL ƒ[‹JfD ƒLG „O†y‚CZ.",
 3,"„OƒmA „O‚b ‚_„S‚CZ. d^ ‹nua†yKLM. ƒnˆEŠi, ‰Ra‡z †E…l ‚e ‚S†s †r„S ^‚VŠqLY? ‚SƒW Fa‡I‚V[.");
 NextEvent(49); --goto 49
 end,
 [40]=function()
talk(2,"ƒ[†{ ‚H‚sƒm„S …yM. ‚_‚AS ‹s‹t‚f.");
 WarIni();
 DefineWarMap(2,"d1ƒa ‚H‚s ‚B„e","1. ‡WƒG ‚p…D",30,0,54);
 SelectTerm(1,{
 0,18,0,3,0,-1,0,
 -1,17,0,3,0,-1,0,
 -1,19,0,3,0,-1,0,
 -1,19,1,3,0,-1,0,
 });
 SetSceneID(0,11);
talk(10,"‡WƒG, ƒ[‚_‚b ‚H‚sƒm„S ^ ‚J‡Y‡ZƒP †c…C‚h ‚S‚CŠp‹u‚f.",
 55,"k.",
 55,"ƒa‚~ƒRGb, ‚J‡Y‡ZƒP †c…C„S ‰Bn ‚H‚sƒm„S g‚ToM!");
 SetSceneID(0);
talk(13,"I‡JG! ƒQm‚TG ƒOu †c…C‚h ˆjMƒd? ƒn…IG‚T! ƒ[ŠQMA ƒOu‚b ƒQmƒP „vgS ˆjM! „T„W„S g‚pa‚f!");
 SetSceneID(0,3);
talk(2,"‚H‚sƒm„S g‚Ta…x!");
 NextEvent();
 end,
 [41]=function()
 SelectEnemy({
 54,0,2,4,0,6,1,0,0,-1,0,
 256,4,6,4,4,4,1,7,6,-1,0,
 257,7,7,4,1,4,1,0,0,-1,0,
 274,1,3,4,0,3,4,0,0,-1,0,
 292,9,8,4,1,1,7,0,0,-1,0,
 293,10,8,4,1,1,7,0,0,-1,0,
 310,1,4,4,0,3,10,0,0,-1,0,
 311,6,5,4,1,2,10,0,0,-1,0,
 312,4,4,4,1,2,10,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [42]=function()
 PlayBGM(11);
 DrawStrBoxCenter("‚H‚s ‚Bƒa");
talk(2,"…fw? ˆEŠi, ƒQm‚Tj ‡KWLM.",
 83,"I‡JG, ƒQm‚TG‚f! ƒQm‚Tƒb ‚J‡Y‡Z‚T{ ‰jƒO‚b ‚e…I ‹|…h ‚SŠS bƒGf ƒv…@Šg†M ˆ|j^?",
 3,"ƒQm‚TG bƒGY‚C ŠXMA ‚J‡Y‡Z‚Tƒb G†w OPS‚CD ‚Z‹{LM.",
 55,"I‡JG, ‚T‚_^ „OMƒd? †u‚wƒP ‚TGŠm? [, ƒwƒQƒP ‚G‚P‚TG„S‚T. ‚J‡Y‡ZS DƒO…e ^‚b †rGŠ@M. „v†G‚b bƒGf gS „Qƒd ‚J‡Y‡ZƒP †c…C‚h †R †~G„kM„V, ‚G‚P‚h „Q‚b ƒuD Šo†y‚C. ƒa‚~ƒRGb, ‚G‚P‚TS ŠGn ‰j„E‚f.",
 3,"ƒnˆEŠi, ƒQm‚TG ŠPƒR‚S…oLM.",
 2,"ŠPƒR‚S†[ GC „v„U‚h ƒsb ‚K…x.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [43]=function()
 if WarMeet(2,55) then
 WarAction(1,2,55);
talk(2,"ŠGƒb„K ƒLƒaƒb ƒRƒm‚f. G eƒO^ t‚^‚h „}ƒ^†yM!",
 55,"ŠoM, ‹R‹S‚f!");
 WarAction(6,2,55);
talk(55,"„p GŠKG I‡JGŠm?",
 2,"ƒv‚b eƒO, …x‚b ‡SƒaGM.",
 55,"eƒO¡­¡­? I‡JG! eƒO‚fƒd? ƒ[ GŠK ‰Eƒb eƒO ˆ|GŠm?",
 2,"[, ƒ_ GŠKS n‚b‚T. ƒ[ŠQMA ƒ_ ‹MƒTD ‚S†s FD‚b „a†y‚wƒv.",
 55,"‰umu! ŠP‚f!");
 if fight(2,55)==1 then
talk(55,"{…B b†a‚TS ƒAuˆj ~†]G„SM¡­¡­ D…fŠW ‡iB‰M q ‚aM.",
 2,"‹FS …Hn‚f!");
 WarAction(4,2,55);
talk(55,"[! „l‚b „q‹} q ‚aM. C‚_^ eƒO‚fA ‚SƒW ˆGnƒv‚b Q ‹o†yM.");
 WarLvUp(GetWarID(2));
talk(55,"G ‚H‚sD †aƒGX q‹wf ‚a‚wƒv. ‚B‚T …C…D!");
 WarAction(16,55);
 NextEvent();
 else
talk(55,"b†a‚TS ƒAuˆj ~†]D ŠZƒu nL„S‚T.",
 55,"eƒO! „p ƒc…~S †E‚[†yM!");
 WarAction(4,55,2);
 WarAction(17,2);
 WarLvUp(GetWarID(55));
 end
 end
 WarLocationItem(6,15,31,60); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¶¹
 --WarLocationItem(6,7,80,503); --»ñµÃµÀ¾ß:¸«
 if (not GetFlag(180)) and WarCheckLocation(-1,9,5) then
 GetMoney(100);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°S ƒYƒC!")
 SetFlag(180,1);
 end 
 if JY.Status==GAME_WARWIN then
talk(55,"‡m, ‚G‚P‚TG dˆF ‚Ia‚wƒv! ‚H‚sD †aƒGX q‹wf ‚aM. ‚B‚T …C…D!");
 NextEvent();
 end
 end,
 [44]=function()
 PlayBGM(7)
 DrawMulitStrBox("‡WƒG^ ƒA…eŠgM. ‚G‚P‚TG ƒQm‚TS I‹xŠjM.");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £²£°£°S ƒYƒC!")
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [45]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚H‚s";
 JY.Base["D‚wC"]=4;
 AddPerson(1,8,18,0);
 AddPerson(2,11,11,3);
 AddPerson(3,21,17,2);
 AddPerson(83,23,16,2);
 SetSceneID(97,5);
 DrawStrBoxCenter("‚H‚s g~");
talk(2,"ˆEŠi, ƒQm‚TG ƒA…e‚q ‡KWLM.",
 1,"‡mƒv ƒQm‚TG bƒGY‚C †[ ƒuS ƒsA ˆEƒo^ Šo‚C ‚kƒb ‡KaM.",
 83,"Šo‚C ‚kƒb ‡KWLM. „i? ‚K‚J, †u^ [‚b ‚Z†ohLM.");
 AddPerson(245,30,6,0);
 AddPerson(246,32,7,0);
 MovePerson( 245,7,1,
 246,7,1);
talk(245,"‚G‚PŠi, I‹~o „N…ZS „oƒWa‡I‚V[. …fŠs‚b ƒNDƒ{ƒP Iƒaƒm„S, …f‚b o~G‚f WLM.",
 246,"…f‚b ‡jƒLG‚f WLM. ‹n‚M ‹pKLM.",
 1,"ƒ[‚_ƒRG ‚SŠS bƒGY‚C ŠXm?",
 245,"ƒNDƒ{G ƒQmfQ ‡F‚Y‡iPKLM. …fŠs Šeƒb ƒ{S ‚C‰J‚f‚b ‚XS …Hƒtƒmƒv ƒQm‚TƒP ‚Jƒo^ „E„Y †Eƒo‚S¡­¡­",
 246,"ƒQmƒP ‚^a „AƒOƒ@fQ ‰Hˆy„C„kKLM.",
 2,"I‡JG! ƒQm^ ƒNDƒ{Y‚C ŠPƒR‚SŠX†M ˆ|j^?",
 246,"ƒ[ŠQKLM. ƒ[ ‡D ‚G‚P‚TG ‚CƒQa…e †[M‚b ˆ|S Š^ƒd GŠQQ ‹qnŠXKLM.",
 245,"ƒQm^ …fu dŠA‚_„S ‚w‚b ƒuS ‚[ƒd ƒs…xL †~ƒm„S „Y†iƒ~ŠpKLM. ‚G‚PŠi, …fŠs‚h …Hn ‚K‡I‚V[.",
 246,"…A…w‚V G ƒQq‚h ‹y†yKLM. ‚^ƒZ …fŠs‚h …Hn ‚K‡I‚V[.",
 3,"ƒnˆEŠi, …Hn ‚K‚V‚CZ. Œ@aƒGD aƒdZ.",
 1,"‚[ ‚r†vG ƒOu ‚Tf ƒR‚S[L g~G o‰F ˆeˆeBƒFm. ŠU ‚^…aa[!",
 245,"ƒdŠOKLM.",
 246,"…fŠs ˆd‡CS ‚C‰a‰} ‚K‡I‚V[.");
 ModifyForce(245,1);
 ModifyForce(246,1);
 PlayWavE(11);
 DrawStrBoxCenter("o~, ‡jƒLG ‚G‚P‚Tf ^†iPM!");
 NextEvent();
 end,
 [46]=function()
talk(83,"g„oD ˆeˆeBƒFƒmL ‚SƒW ‚wƒQa…e ^‚V‚CZ.",
 1,"…y‡r, bƒGƒW „T„WY‚C‚b ^‡P†y‚C?",
 83,"ƒ[u ^‡P‚C ‚kKLM. bƒGƒW „T„W„S ^‚b †rƒb Šej…h, aƒv‚b ‰Ra‚h ‚Cƒvƒd M‡M aƒv‚b †E…lS ‚C‹_LM.",
 1,"‰Ra‡z †E…l, ‚S†s †r„S ^D „T„Wf G‚j‚b^?",
 83,"ƒ[ŠQKLM.",
 2,"‡mƒv ƒQm‚TG G†w bƒGY‚C ŠXƒmL ƒ[‹JfD ƒLG „O†y‚CZ.",
 3,"„OƒmA „O‚b ‚_„S‚CZ. d^ ‹nua†yKLM.",
 2,"‚SƒW …bFS ƒe‚Pa‚V‚CZ. ‚_ƒaƒaG‚h …d…e ‚[„kƒmL ŒA‚f ˆ`‡I‚V[.");
talk(375,"ŠU ‚^…a…w„tLM. ‚S†A ‹F{ †gG „sZaƒN‚C ˆ|Š[B ‚K‡I‚V[.");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥Ö§Ô®¹«Ëïè¶>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [47]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW ^‚V‚CZ. …f‚b „l ˆf †~†yKLM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"…bF ‚Bf ‚[ ^‚C‚h ƒe‚Pa‡I‚V[. aƒv‚b IƒG‚h ‚r‚b ƒuGƒd, Šeƒb ƒG…lS …gƒG‚b ƒuhLM.");
 end
 if JY.Tid==245 then--º«Ó¢
talk(245,"„@Šy ƒLS ƒq†yKLM. ‚XS ƒ_u‡I‚V[.");
 end;
 if JY.Tid==246 then--¹ùÊÊ
talk(246,"„@Šy ƒLS ƒq†yKLM. ‚XS ƒ_u‡I‚V[.");
 end;
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [48]=function()
talk(2,"…b_a…x!");
 JY.Smap={};
 SetSceneID(0,12);
talk(2,"ƒnˆEŠi, ‰Ra‡z †E…l ‚e ‚SƒZ„S ‡yYZ? ‚SƒW Fa‡I‚V[.");
 NextEvent(); --goto 49
 end,
 [49]=function()
 local menu={
 {" †E…lS ‚CƒvƒW",nil,1},
 {" ‰Ra‚h ‚CƒvƒW",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
 NextEvent(56); --goto 56
 elseif r==2 then
 NextEvent(); --goto 50
 end
 end,
 [50]=function()
talk(2,"„a†yKLM. ƒ[†{ ‰Ra„S ^†yKLM.");
 PlayBGM(3);
 NextEvent();
 end,
 [51]=function()
 SetSceneID(0);
talk(2,"ƒLj ‡KaM. ‚_‚AS ‹s‹t‚f.");
 WarIni();
 DefineWarMap(5,"d1ƒa ‰Ra ‚B„e","1. }ƒP ˆL†U",30,0,60);
 SelectTerm(1,{
 0,24,11,3,0,-1,0,
 -1,23,11,3,0,-1,0,
 -1,22,10,3,0,-1,0,
 -1,22,12,3,0,-1,0,
 -1,23,12,3,0,-1,0,
 59,3,10,3,0,-1,0,
 });
 SelectEnemy({
 60,2,10,4,2,9,7,0,0,-1,0,
 256,4,9,4,0,5,1,0,0,-1,0,
 257,10,7,4,4,5,1,12,7,-1,0,
 258,9,9,4,4,4,1,12,8,-1,0,
 328,8,8,4,4,4,13,11,8,-1,0,
 292,3,8,4,0,2,7,0,0,-1,0,
 274,2,9,4,0,4,4,0,0,-1,0,
 275,10,10,4,4,4,4,11,9,-1,0,
 310,14,0,4,1,3,10,0,0,-1,1,
 311,13,1,4,1,3,10,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [52]=function()
talk(60,"}ƒP! G ‡n‚IG H‡z …I‚_…I„S „}ƒ^†yM!",
 61,"†iƒb „^M„V ‡SG ‚a‚wƒv! G }ƒP‚h G†r q „OMƒd ƒs†sŠm? ŠP‚f!");
 if fight(61,60)==1 then
talk(61,"‡n‚I, ‹FS …Hn‚f!");
 WarAction(8,61,60);
talk(60,"ƒm…v!");
 WarAction(18,60);
talk(61,"‚J‡Y‡ZƒP ‚_ƒa ‡n‚IG ƒqŠbM!",
 2,"ƒnˆEŠi, o_ ‹zƒb ‡KWLM. ‡n‚IG ƒqGƒd ‰RaƒP ‡kƒw‚TG IHƒFKLM.",
 1,"o_ ‹z„k‚wƒv. ŠoM! ‰X‚b ‰X„S ‹yn…E‚C!",
 61,"„i? …fw ‚G‚P‚TG nLŠm? [, ‚J‡Y‡ZS DƒO…e ŠX‚wƒv. G }ƒP^ ƒsƒ_ ‚K‚C ‚k†yM!");
 else
talk(60,"}ƒP, ‹FS …Hn‚f!");
 WarAction(5,60,61);
talk(61,"…M!");
 WarAction(6,60,61);
 WarAction(6,60,61);
 WarAction(10,60,61);
talk(60,"‹U‹Va‚wƒv!",
 2,"ƒnˆEŠi, o_ ‹zƒb ‡KWLM. ‰RaƒP ‡kƒw‚TG IHƒFKLM.",
 1,"o_ ‹z„k‚wƒv. ŠoM! …{ŠW ‡n‚IS ‚wƒQa‚f!",
 61,"„i? …fw ‚G‚P‚TG nLŠm? [, ‚J‡Y‡ZS DƒO…e ŠX‚wƒv. G }ƒP^ ƒsƒ_ ‚K‚C ‚k†yM!");
 end
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [53]=function()
 if WarMeet(2,61) then
 WarAction(1,2,61);
talk(2,"G‡EƒP ‚_ƒaƒb ƒRƒm‚f! ƒv‡z …I‚_…I„S „}ƒ^…x!",
 61,"I‡JG? ‡NŠW ƒ_Q D‚Ba‚b …x^ ‡O „O†sŠm! ŠoM, C‚_B ‚K…X!");
 WarAction(6,2,61);
 if fight(2,61)==1 then
talk(61,"G‹@ …x^! ‚_†Ma‚wƒv¡­¡­",
 2,"‚Io …x ‚nf „l ‚Io …x^ „O‚b ˆF. ‡SG ‚a‚wƒv, „p ƒcS ƒq†yM.");
 WarAction(8,2,61);
 WarAction(18,61);
talk(2,"ƒ_ IkD n„L I‚j…S‚C ‚kƒt‚T. G‹@ …x‚h C‚_a‚b …h „@G ‚^„QML¡­¡­");
 WarLvUp(GetWarID(2));
 PlayBGM(7);
 DrawMulitStrBox("¡¡eƒO^ }ƒP‚h ƒqƒd,*¡¡‚G‚P‚TG ‰Ra‚h ‰B†VPM.");
 NextEvent();
 else
talk(61,"HD „Nƒg ƒ[ ‡n‚I{ „Gƒb ŒB„S „VƒR‚S ‚K…X!");
 WarAction(4,61,2);
talk(2,"ƒ_ IkD n„L I‚j…S‚C ‚kƒt‚T. G‹@ …x‚h C‚_a‚b …h „@G ‚^„QML¡­¡­");
 WarAction(17,2);
 WarLvUp(GetWarID(61));
 end
 end
 if (not GetFlag(1004)) and War.Turn==7 then
talk(1,"‚M! …fw!?");
 WarShowArmy(310);
 WarShowArmy(311);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM!");
 SetFlag(1004,1);
 end
 if JY.Status==GAME_WARWIN then
talk(61,"GƒsQ, ‚G‚P! bƒG‚h ‚Cƒv‡y `‚Eƒb …X‚f.");
 PlayBGM(7);
 DrawMulitStrBox("‚G‚P‚TG ‰Ra‚h ‰B†VPM!");
 NextEvent();
 end
 WarLocationItem(9,1,28,62); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¾Æ
 --WarLocationItem(7,19,85,504); --»ñµÃµÀ¾ß:¹³
 --WarLocationItem(9,11,89,505); --»ñµÃµÀ¾ß:Ç¹
 if (not GetFlag(182)) and WarCheckLocation(-1,12,12) then
 GetMoney(100);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°S ƒYƒC!")
 SetFlag(182,1);
 end
 end,
 [54]=function()
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £²£°£°S ƒYƒC!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [55]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(103,"I‡JG! ‰RaƒP }ƒP^ ‚J‡Y‡Z‚TfQ ŒC„~ML. Du ‚aM. ‚K‚JG „TƒN „T„W„S ƒA…eƒv‚f!",
 26,"dƒGŠJ, ‚~ƒ}G vƒg„V „l ‚IP‚SD ƒaWS ‚r„S‹QƒtS ‹|…h.");
 SetSceneID(0);
talk(2,"‹IG ƒU„S ƒQmƒP ‚Kƒ}G „O‚b „T„WM!",
 3,"ƒnˆEŠi, ‚SƒW „T„W„S ^‚V‚CZ!");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥½çÇÅÖ§Ô®¹«Ëïè¶>
 --61 ´¢´æ½ø¶È:Õ½³¡´æÅÌ
 --15 ¶ÁÈë¶ÎÖ¸Áî:¶ÁÈëµÚ<15>¶ÎÖ¸Áî
 NextEvent(61); --goto 61
 end,
 [56]=function()
talk(2,"„a†yKLM. ƒ[†{ †E…lƒm„S ^†yKLM.");
 PlayBGM(3);
 SetFlag(133,1);
 NextEvent();
 end,
 [57]=function()
 SetSceneID(0);
talk(2,"ƒLj ‡KaM. ‚_‚AS ‹s‹t‚f.");
 WarIni();
 DefineWarMap(4,"d1ƒa †E…l ‚B„e","1. ƒaW ‚p…D*2. ‚G‚P^ ƒW‹J ƒ{…^ DˆG",30,0,102);
 SelectTerm(1,{
 0,2,2,4,0,-1,0,
 -1,4,3,4,0,-1,0,
 -1,3,1,4,0,-1,0,
 -1,1,2,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 25,10,4,4,0,-1,0,
 221,9,5,4,0,-1,0,
 58,17,13,3,0,-1,1,
 57,17,12,3,0,-1,1,
 });
 SelectEnemy({
 102,5,17,4,0,10,22,0,0,-1,0,
 51,6,15,4,0,7,7,0,0,-1,0,
 103,4,14,4,0,7,4,0,0,-1,0,
 91,12,6,3,1,6,1,0,0,-1,0,
 54,11,14,4,1,7,1,0,0,-1,0,
 256,10,6,3,1,5,1,0,0,-1,0,
 257,7,16,4,0,5,1,0,0,-1,0,
 274,9,17,4,0,4,4,0,0,-1,0,
 292,10,14,4,1,3,7,0,0,-1,0,
 336,13,5,3,1,4,15,0,0,-1,0,
 348,4,16,4,0,4,19,0,0,-1,0,
 310,2,0,4,1,3,10,0,0,-1,1,
 311,1,1,4,1,3,10,0,0,-1,1,
 312,0,2,4,1,3,10,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [58]=function()
 PlayBGM(11);
talk(52,"ƒaW, ‚SƒW ‡kƒw‚TS Fuaƒd „T„WƒP ‚Kƒ}{ W]a‚V[.",
 103,"‡mƒv ‚J‡Y‡ZƒP †_ƒOj ‚G‚P‚TG ƒOu Fk o ‡y†G‚h „_ƒd †E…lƒm„S [ƒd „OM ƒR„km. I‡H q‚h ‰lƒW‚fD ‚J‡Y‡Z{ ‚G‚P^ W]a‚C ˆfaQ B…E a[.");
talk(1,"‚J‡Y‡cŠi, ƒwƒQƒP ‚G‚P^ DƒO…e ŠXKLM.",
 26,"[, ‚G‚P„S‚T. Gd †jƒtM. d‚TƒR, ƒQ‚TG ŠXM.",
 103,"ŠX‚wƒv. ‚G‚P! G ƒaWG †rS ‡fƒtƒmL „T„Wf‚b ‡y q ‚aM.",
 52,"eƒO! ƒa‚P! G ‚o„X{ „}‹a †cŒDG „O†sŠm?",
 2,"ƒnˆEŠi, ƒLG `‚EƒsM ‚Io ‡KWLM. ‚Cƒgƒb bƒGƒW ŠGŒES ƒuG nL‚f ƒLgS ŒCƒd ƒEˆkƒv^…E WLM. M‚]ŠW „[ n†G ƒW‹Jf ƒ{…^^ aƒv „OƒmL, ƒ[‡Ef G‚jA ƒLD ‡Y„P Du^ ‚aS ƒuhLM.");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [59]=function()
 if WarMeet(3,52) then
 WarAction(1,3,52);
talk(3,"[, dˆF ‚Io C‚_j ‡Ka‚T. ƒ_^ C‚_a†yM.",
 52,"H‚b †u‚wŠm? G‹Jƒm„S [‚b ƒuƒb ƒv‡z ‰jƒO†yM‚b ƒuGŠm? ŠoM, ŠP‚f!");
 WarAction(6,3,52);
 if fight(3,52)==1 then
talk(3,"dˆF ‹MƒT^ „O‚wƒv. ƒv‚h „V‚q ƒuG „p …d‡SGM.",
 52,"G ‹FŠTS ƒsb ‚K…X.");
 WarAction(9,52,3);
talk(3,"ƒ[Q I‡H IkŠm? ƒ[…eƒdD ƒv‚h GƒG†y†sŠm?",
 52,"‡m, ƒ_ ‹FY‚C ‰XaML. ‚_†Mo …x„S‚T.",
 3,"ƒ[ FD Nƒ}‹wf ‚o „C‚b‚T.");
 WarAction(8,3,52);
talk(52,"ƒmŒF! ‡iB‰M q ‚aM, ˆGnƒv…x!");
 WarAction(16,52);
 WarLvUp(GetWarID(3));
 else
talk(3,"dˆF ‹MƒT^ „O‚wƒv. ƒv‚h „V‚q ƒuG „p …d‡SGM.",
 52,"G ‹FŠTS ƒsb ‚K…X.");
 WarAction(8,52,3);
 WarAction(17,3);
 WarLvUp(GetWarID(52));
 end
 end
 if (not GetFlag(1005)) and War.Turn==3 then
talk(1,"‡m! …fw!?");
 WarShowArmy(310);
 WarShowArmy(311);
 WarShowArmy(312);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ŠXM!");
talk(1,"I‡JG? ‹I‹JfƒWD [‚b ƒuGŠm!?");
 WarShowArmy(57);
 WarShowArmy(58);
 PlayBGM(12);
talk(59,"…f‚b e„A, „v†G o‚DƒP ‚^aŠbKLM. G‚Wf ‚G‚P‚Tf ^†iaƒd…x ŠXKLM.",
 58,"…fŠs ‚K‚J o‚Dƒb ƒQmƒP „T‚vf ƒG‚K‚h Šf„h‹HKLM. ƒ[ ƒQoS ŠkS q ‚a‚S G ƒ@ID ‚G‚P‚Tf ^†ia…e ŠXKLM.",
 1,"…fw ‚SƒZ ‚T‚_j^?",
 83,"ŒG‚O‚aG e„A{ ƒ@IhLM. ƒQmfQ ƒG‚K‚h Šf„hŒI o‚DƒP ‚^aƒRG‚CZ.",
 1,"[, ƒQq‚h ‹yƒmƒ`‚b Q„S‚T.",
 83,"n…X ƒ[Šl ƒuhLM.",
 3,"‚SŒJˆe ƒLƒb nL†y‚CZ? ƒ[ŠQMA ƒOu ƒQ‚TG†y‚TZ.");
 DrawStrBoxCenter("ƒ@I‡z e„AG ‚CƒQa…e ŠXM!");
 PlayBGM(14);
 SetFlag(1005,1);
 end
 if JY.Status==GAME_WARWIN then
talk(103,"dƒGŠJ! ‚G‚PfQ ‚CML! …C…Da‚f!",
 1,"ŠoM, ƒOu ‚TG G‹HM!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒaWG ƒA…eƒvƒd ‚G‚P‚TG ƒQm‚TS I‹xŠjM.");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £²£°£°S ƒYƒC!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if (not GetFlag(162)) and WarCheckArea(0,8,4,13,10) then
talk(103,"‚G‚P^ †E…lS ŒCQ Še q ‚aM. ‚B‚Tƒb ‚G‚P‚h ‡fn‚f!",
 2,"ƒnˆEŠi, ƒ{…^^ „I‹IhLM. ‚S‹cQˆe ŒCƒd ƒv^‚V‚CZ.");
 WarModifyAI(102,3,0);
 WarModifyAI(51,3,0);
 WarModifyAI(103,3,0);
 WarModifyAI(257,3,0);
 WarModifyAI(274,3,0);
 WarModifyAI(348,3,0);
 SetFlag(162,1);
 end
 if WarCheckLocation(0,10,0) then
talk(103,"dƒGŠJ! ‚G‚P‚h ‚Cƒv^Q Še q ‚aM!",
 1,"ŠoM, †E…lS ‰B†VPM.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG †E…lS ‰B†VPM.");
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(8,5,32,183); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÂó
 --WarLocationItem(7,11,95,506); --»ñµÃµÀ¾ß:êª
 --WarLocationItem(13,7,99,507); --»ñµÃµÀ¾ß:°ë¹­
 end,
 [60]=function()
 SetSceneID(0,11);
talk(61,"I‡JG? †E…lƒP ƒaWG ‚J‡Y‡Z‚TfQ ŒC„~Mƒd? Du ‚aM. ‚K‚JG „TƒN „T„W„S ‰Bn‡y q‹wf.",
 60,"dƒGŠJ, ƒ_ Iƒ}G vƒg„V „l ‚IP‚SD }ƒP‚h ‚r„S‹QƒtS ‹|…h.");
 PlayBGM(3);
talk(59,"‚G‚PŠi, …f‚b „v†G o‚DƒP ‚^aŠbŠB e„AG‚f WLM.",
 58,"…f‚b ƒ@I‚f WLM.",
 1,"ƒ[ŠQ‚T.",
 59,"…fŠs ‚K‚J o‚Dƒb ƒQmfQ ƒG‚K‚h Šf„hƒGƒd ‚Cƒgƒb ‚VŒAfƒW v„oŠW ‚Cƒ_‡ILM. n„L ƒQmfQ ƒQoS ‹y‚C ˆfPƒmL, ‚G‚PŠi, ‚^ƒZ …fŠs‚h …hƒ`^ ‚K‡I‚V[.",
 1,"„a†ym. ƒ[†{ ƒv‚h ‚i‚j‚V[.",
 58,"k, ‡N‚rWLM.");
 ModifyForce(59,1);
 ModifyForce(58,1);
 PlayWavE(11);
 DrawStrBoxCenter("e„A{ ƒ@I^ ‚G‚PƒP ‚^a^ „C„kM!");
talk(2,"‹IG ƒU„S ƒQmƒP ‚Kƒ}G „O‚b „T„WM!",
 3,"ƒnˆEŠi, ‚SƒW „T„W„S ^‚V‚CZ.");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥½çÇÅÖ§Ô®¹«Ëïè¶>
 NextEvent(); --goto 61
 end,
 [61]=function()
change_mode()
talk(2,"ƒnˆEŠi, „T„Wf G‚jŠjKLM. ‚_‚AS ‹s…c‚V‚CZ.");
 LvUp(13,4);
 WarIni();
 DefineWarMap(6,"d1ƒa „T„W ‚B„e","1. ƒQm ‚p…D*2. ‚G‚P^ ‚T„Xƒd Šxl",40,0,9);
 SelectTerm(1,{
 0,0,14,4,0,-1,0,
 -1,2,14,4,0,-1,0,
 -1,3,13,4,0,-1,0,
 -1,1,13,4,0,-1,0,
 -1,1,15,4,0,-1,0,
 12,3,15,4,0,-1,0,
 222,6,14,4,0,-1,0,
 227,4,15,4,0,-1,0,
 53,0,17,4,0,-1,1,
 });
 if GetFlag(133) then
 SelectEnemy({
 9,25,15,3,0,13,1,0,0,-1,0,
 49,26,16,3,0,8,4,0,0,-1,0,
 52,4,16,3,0,10,7,0,0,-1,0,
 98,15,23,3,0,8,19,0,0,-1,0,
 50,7,20,3,0,8,4,0,0,-1,0,
 138,14,22,3,0,7,4,0,0,-1,0,
 60,25,19,3,0,10,7,0,0,-1,0,
 139,9,18,3,0,7,4,0,0,-1,0,
 56,24,16,3,0,7,1,0,0,-1,0,
 55,25,16,3,0,7,13,0,0,-1,0,
 92,27,3,3,0,7,1,0,0,-1,0,
 256,29,6,3,0,5,1,0,0,-1,0,
 257,28,6,3,0,5,1,0,0,-1,0,
 292,15,21,3,0,3,7,0,0,-1,0,
 293,23,19,3,0,3,7,0,0,-1,0,
 310,8,19,3,1,6,10,0,0,-1,0,
 328,10,17,3,1,5,13,0,0,-1,0,
 });
 else
 SelectEnemy({
 9,25,15,3,0,13,1,0,0,-1,0,
 49,26,16,3,0,8,4,0,0,-1,0,
 52,4,16,3,0,10,7,0,0,-1,0,
 98,15,23,3,0,8,19,0,0,-1,0,
 50,7,17,3,0,8,4,0,0,-1,0,
 138,25,16,3,0,7,4,0,0,-1,0,
 102,23,19,3,0,10,22,0,0,-1,0,
 51,25,19,3,0,10,7,0,0,-1,0,
 92,27,3,3,0,7,1,0,0,-1,0,
 91,24,16,3,0,7,1,0,0,-1,0,
 54,6,18,3,0,8,1,0,0,-1,0,
 103,9,18,3,1,7,4,0,0,-1,0,
 256,28,6,3,0,5,1,0,0,-1,0,
 257,29,6,3,0,5,1,0,0,-1,0,
 292,15,21,3,0,3,7,0,0,-1,0,
 293,5,19,3,0,3,7,0,0,-1,0,
 274,8,19,3,1,3,4,0,0,-1,0,
 328,7,20,3,1,5,13,0,0,-1,0,
 329,16,22,3,0,5,13,0,0,-1,0,
 });
 end
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [62]=function()
 PlayBGM(11);
talk(10,"ƒL‚Tƒb Gd o „NGA IHgM. …Z…c! ^ƒW ‚J‡Y‡ZƒP ƒcS ƒq‚S [‚f!",
 53,"ƒv‚b …Z…cM. ‚J‡Y‡Z, ƒ_‰z [ƒXG „p dŒKƒSG Š} ƒuGM.",
 13,"‚SŠS ˆY …IGŠm! ƒQ‚TG n„LD [‚C ‚k‚b‚wƒv.",
 228,"‚K‚J, G …Iƒb dQ ŠEƒG‡I‚V[. …Z…c, ‡zƒW …G‚S‚f!",
 53,"ŒL, I‚XƒP Šz†K„S‚T. ‚SƒW ŒMˆk‚f.");
 WarAction(1,53,228);
 fight(53,228);
talk(53,"…G‚S‚f¡­¡­");
 WarAction(4,53,228);
talk(228,"n¡­¡­");
 --WarAction(19,228);
talk(228,"G, G‰S…l ‚IaML.",
 53,"aaa, ‚S‹XŠm! ƒ[ FD Nƒ}ƒm„S ƒv‚h GƒG†yMƒd!");
 WarAction(17,228);
talk(53,"‚J‡Y‡Z, ‚SƒZ„S ˆGnƒv†sŠm! ƒc…~S ƒ_‹^n‚f!",
 13,"ƒ_ ‚XD bƒGY‚Cj^!");
 WarShowArmy(53);
 PlayBGM(12);
talk(54,"‡dŠu. G‚W‰` ƒ_^ C‚_a†yM.",
 53,"H‚b †u‚wŠm?");
 WarMoveTo(54,3,16);
 WarAction(1,54,53);
 WarAction(5,54,53);
talk(53,"…GS „{D ‚Z‚j‚b ŒNG„S‚T. ‚J‡Y‡Z{ ‰HŠ_ ƒ_ †g‹[ƒP ˆHƒNG „C‚S‚f.");
 if fight(54,53)==1 then
talk(54,"…M!!");
 WarAction(4,54,53);
talk(53,"[! ŠP‚f! dƒGŠJ, ‚Ia‚wƒv. …I†M ƒA…e‚qM.");
 WarAction(19,53);
 WarMoveTo(53,15,22);
 WarAction(0,53,3);
 WarLvUp(GetWarID(54));
 else
 WarAction(6,54,53);
talk(53,"aaa, [ƒXƒb ‚J‡Y‡Z „p ƒc…~S †jƒ` ‚[…X.");
 WarMoveTo(53,15,22);
 WarAction(0,53,3);
 end
talk(13,"[, a…XƒhA ƒc…~S ŒOS ŒPPm. †~ƒm„S ƒdŠOm. ‡N‚r j‚r‚h …wuƒd Š]ƒmL †O‰HS „aƒ` ‚K‚V[.",
 54,"…f‚b v‡SG‚f WLM.",
 54,"‚Bf‚b ƒQm‚h ‚i„gƒmƒv, ƒ[^ RƒgfQ ‡tƒ{a‚CD †eƒ{S nŠY‚CD ‚k‚MS „aƒd ƒ[‚h ‹Xƒv ƒd†Yƒm„S ‰Bn^‚b †rG„kKLM.",
 13,"ƒQm^ ‚Su„Zƒb ŒQS P‚wƒ`. ‚S‹cm, ƒv‚h D‡z„{ q „O†ym?");
talk(54,"ŠoKLM!",
 54,"„i? ‚J‡Y‡Z, …f ‚T‚_‚b?",
 13,"[, …fw ƒwƒQ ‚G‚PƒP ‚T‚_M! d‚TƒR, ‚G‚PƒP ƒQ‚TG D†WPM!",
 3,"ƒnˆEŠi, d„U ‹fƒb ‡KWLM.",
 1,"‚J‡Y‡ZŠ_ƒW ‰jƒOƒd „T‚VM‚b ˆ|S Š^ƒd ƒwƒQfƒW …I‚^…e DƒO…e ŠXm.",
 2,"ƒnˆEŠi, ƒL‚TG ‚IWLM. ƒLƒP ‚T„Xƒd‚h „Q‚V‚CZ.",
 51,"‚K‚J, ‚G‚P‚TG ŠXKLM.",
 10,"‡m‚S, ƒ[ ‚G‚P‚T ˆ|GŠm?",
 50,"‚K‚J, ‚[ƒ`…[ Q I‡JhLY. G ƒG‚}‚h ‹^†R q ‚aKLM.",
 10,"¡­¡­ŒR†EL, ŠoM. ‰HŠ_ ƒq‚S ‹C_f d‚h ƒiu…x!");
 WarModifyAI(54,1)
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [63]=function()
 if WarMeet(3,53) then
 WarAction(1,3,53);
talk(53,"nY‚b „N†dB ‡iPM„V G‚W‰` M‚jM. ƒ_ ‹MƒT‚h ƒsb ‚K…X.",
 3,"GƒsQ, ‹D †cŒD „O‚b …x‚b ‚a†sŠm? fŒS, ƒ_^ C‚_B ‚K‚C.");
 WarAction(6,3,53);
 if fight(3,53)==1 then
talk(3,"‚SŠS Gu ‚VƒQƒKƒb^. ‚V‚Va‚T.",
 53,"G, GŠl u^ ‚aM.",
 3,"‰Bn^‚b Q Šo†yM. C‚_X …X‚MD ‚aM.",
 53,"GŒN! ‚r†vS ‚ZŒTa‚C …X‚f!");
 WarAction(9,53,3);
talk(53,"aa, ‚S, ‚S‹XŠm¡­¡­",
 3,"¡­¡­„p^ ƒv‚h ƒ{ƒvQ PM. Q ŒU†E‚f!");
 WarAction(8,3,53);
talk(53,"ƒmŒF! nYD ‚Cƒd G‚WfD ‚C‚b‚wƒv.");
 WarAction(16,53);
 WarLvUp(GetWarID(3));
 else
talk(53,"aa, ‚S, ‚S‹XŠm¡­¡­");
 WarAction(8,53,3);
 WarAction(17,3);
 WarLvUp(GetWarID(53));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 if (not GetFlag(213)) and (not GetFlag(148)) and WarCheckArea(-1,17,10,23,15) then
 PlayBGM(11);
talk(50,"‚K‚J, …f FD ‚~ƒ}„Qƒd‚b †~ƒm„S ‰A‹TŒVLM. ƒOu ‹Jƒm„S M^†[ ‡KWLM.",
 10,"‡m, …fƒRD „V„V„Q ‚k‚wƒv. ŠoM, ‚B‚T ‚J‚p †K‚V!!");
 if GetFlag(133) then
 WarModifyAI(49,4,15,21);
 WarModifyAI(9,4,16,22);
 WarModifyAI(293,4,16,21);
 WarModifyAI(56,4,15,23);
 WarModifyAI(55,4,14,22);
 WarModifyAI(60,4,13,23);
 WarModifyAI(98,1);
 WarModifyAI(138,1);
 WarModifyAI(292,1);
 else
 WarModifyAI(9,4,16,22);
 WarModifyAI(91,4,15,23);
 WarModifyAI(49,4,15,21);
 WarModifyAI(51,4,14,22);
 WarModifyAI(102,4,13,23);
 WarModifyAI(293,4,16,21);
 WarModifyAI(98,1);
 WarModifyAI(138,1);
 WarModifyAI(292,1);
 WarModifyAI(329,1);
 end
 SetFlag(213,1);
 PlayBGM(13);
 end
 if (not GetFlag(148)) and WarCheckArea(0,6,23,9,29) then
 PlayBGM(11);
talk(93,"‚K‚J, ‚G‚P^ ‚T„Xƒd‚h ƒYuƒd ƒOu g~ƒm„S †YPKLM.",
 10,"I‡JG!! ‚G‚P, †~ƒm„S „`o q‚h ˆ`‚b‚wƒv! †PŠW g~ƒm„S ‰Bn^‚f!");
 if GetFlag(133) then
 WarModifyAI(9,3,0);
 WarModifyAI(49,3,0);
 WarModifyAI(60,3,0);
 WarModifyAI(293,3,0);
 WarModifyAI(56,3,0);
 WarModifyAI(55,3,0);
 else
 WarModifyAI(9,3,0);
 WarModifyAI(91,3,0);
 WarModifyAI(49,3,0);
 WarModifyAI(138,3,0);
 WarModifyAI(51,3,0);
 WarModifyAI(102,3,0);
 end
 SetFlag(148,1);
 PlayBGM(13);
 end
 if WarCheckLocation(0,1,27) then
talk(1,"ŠoM! ƒOu^ ƒQmƒP ‚T„Xƒd‚h Šf„hƒtM.",
 2,"[, ˆEŠi. †|†}WLM.",
 3,"Gd ƒQm‚Tƒb ‚T„XG ‚aKLM.",
 83,"G ‰jˆlƒb ƒOu^ GŒI ƒuGƒv MŠK‚aKLM.");
 SetFlag(1100,1);
 NextEvent();
 end
 WarLocationItem(21,8,66,64); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º»ğÁúÊé ¸ÄÎª ÎäµÀÖ¸ÄÏÊé
 WarLocationItem(23,14,20,184); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º³¤Ç¹
 WarLocationItem(1,29,22,185); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºåó
 WarLocationItem(3,22,32,186); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÂó
 --WarLocationItem(17,2,104,508); --»ñµÃµÀ¾ß:åó
 --WarLocationItem(19,24,109,509); --»ñµÃµÀ¾ß:ÊÖÅÚ
 end,
 [64]=function()
talk(10,"fŒS, ‚G‚P G ‹U‹Vo ŒN. vƒg„V ‹zQ ŠX‚SD ‚J‡Y‡ZS ‚{ q „O„k†EƒX¡­¡­ dƒGŠJ, G‚_„S ‹[ƒ_‚C ‚k†yM! ‚J‡Y‡ZGb, O‚BƒP ƒQoƒb ˆAŒW^ …A…w‚V ‹yƒmu‚f. ‚B‚T …C…D!");
 PlayBGM(7);
 DrawMulitStrBox("„T„W ‚B„e‚b ‚J‡Y‡ZƒP tu„S ‹[ŠgM.");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £²£°£°S ƒYƒC!");
bonus_moneyexp_4()
 if GetFlag(1100) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [65]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(10,"‚J‡Y‡Z, ƒv‚b †@ŠH O†c‚h jFa‚C ‚k‚bM!");
 SetSceneID(0);
talk(13,"‚G‚P, „UŠG‹t ŠU ‡z ‚K„km. G‚W‰` ƒ[‚_ ‡VS „^Q ƒsƒtm.",
 1,"ŠZˆ|Š[S. d„U ‹fƒtƒGf OŒYS tƒo„S ‰B„u q „O„k‚CZ.",
 13,"[, †~. ‚G‚P, m†Ka†ym. G‹Jƒb v‡SG[. ƒ_^ ‚n‚|„S…[ „U ‚wB ‚K„km. v‡S, G‡LG ‚G‚PZ.",
 1,"ƒv‚b ‚G‚P, …x‚b r‡VG[.",
 54,"‡iƒNG ƒU„S ‚G‚PŠiG‚V‚TZ. †O‰Hƒb …SŠW ƒR„kKLM. …f‚b v‡S, …x‚b …x‡lG‚f WLM.",
 13,"d‚TƒR, ‚SŒJˆe ƒOu^ G‹Hm. tu‚h ‚nab, w†c!");
 NextEvent();
 end,
 --µÚÒ»ÕÂ¡¡Ö§Ô®±±º£ĞìÖİ
 [66]=function()
 JY.Smap={};
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d1ƒa¡¡‡kB¡¤ƒW‚K ‚CƒQ";
 DrawStrBoxCenter("d1ƒa¡¡‡kB¡¤ƒW‚K ‚CƒQ");
 LoadPic(5,1);
 DrawMulitStrBox("¡¡‚J‡Y‡Z{ ƒQmƒP „T„W ‚B„e‚b ‚G‚P‚T{ v‡SƒP ‡L‚Bf „@h‚S ‚J‡Y‡ZƒP †K^„S ‹[ŠgM.");
 DrawMulitStrBox("¡¡ƒ[…eƒv ŒZ ˆGf ‚@ˆj ‰jˆlƒm„S ‚~‚rƒRƒb Œ[‚V ‚CŠP „O„kM. G‚h ‚o ‚l…aƒb `ŒYS ƒ_ƒd…x ‚UdƒP GŠKƒm„S ‚[ ‚r†vfQ @B‚h ‡bPM. ‚[ ‚r†vfQD ƒU‚fŠB ƒUŠbƒmL, „T„W ‚B„e‚b ƒ[ŠQQ ‡fS ƒ_„~M.");
 LoadPic(5,2);
 LoadPic(29,1);
 DrawMulitStrBox("¡¡ƒ[ ‡D dDfƒW ƒn…IG ‰r‚SƒFM. b†a^ ‚l…aS ‹x…e …Gj ƒuGM.*¡¡b†a‚b ‡e‡h{ ƒ|…mƒP …B†I„Tf ‚@ƒ` ‚l…aS ƒq„kM. ƒ[…eƒv ‰b ‚l…aƒP Œ^ ‚^aƒRfQ OB dD‚h ‹Xƒv ˆGnŠgM.");
 LoadPic(29,2);
 AddPerson(9,25,9,1);
 AddPerson(17,14,9,3);
 AddPerson(18,12,10,3);
 AddPerson(20,10,11,3);
 AddPerson(69,25,15,2);
 AddPerson(19,23,16,2);
 AddPerson(63,21,17,2);
 JY.Base["ÏÖÔÚµØ"]="g]";
 JY.Base["D‚wC"]=0;
 SetSceneID(86,11);
 DrawStrBoxCenter("g] ƒP‚r‰R");
 AddPerson(367,3,20,0);
 MovePerson(367,7,0);
talk(367,"‚K‚J, ƒn…I ŠgKLM!",
 9,"I‡H m‚dGŠm? ‚l…aG …Gƒb ƒuƒsM „l ƒn…IG „O†y†sŠm. ƒW‚[‚h ƒu ‚aM.",
 367,"a[ƒv¡­¡­",
 9,"…X‚MS ^‚fŒ_ŠWƒd ˆ|a‚f.",
 367,"k, ‚K‚JƒP ‚^ˆj vŒ`Š_ƒW D‡[ƒP ‚^afQ †jB„CŠVKLM.",
 9,"I‡JG!? ƒ[ƒuG ‚rNGŠm?");
 MovePerson(9,1,2);
 MovePerson(9,1,1);
 MovePerson(9,1,3);
 MovePerson(9,2,1);
talk(9,"D‡[G ‚SŠSab ƒ_ n„qŠiS …GŠb†M ˆ|GŠm! ‚SŠSab!",
 367,"ƒsƒdf ‚i‚jA, ‚^ˆjŠ_ƒW g]„S [‚VŠB †rf D‡[G ‚_‰naƒd †q‚nY‚C ŒEb †c†]PM WLM. ƒ[‹@…h ƒ[ †q‚nƒP ‡Yf †~‚tS ‡iaŠVKLM.",
 9,"ƒmŒF¡­¡­ D‡[, †@ŠH „oƒW„Q ‚k†yM. ƒOƒg!",
 63,"k.");
 MovePerson(63,1,1);
 MovePerson(63,3,2);
 MovePerson(63,0,0);
talk(9,"ƒ[‚_‚b Œa‚V ‚TS Gˆnƒd ƒW‚K„S ˆGƒ`^ ƒ[ƒRS ƒq‚S n„qŠiƒP ŒbS ‚n„Sa‚f. ƒv‚b ‡DG‚S ‚TS Gˆnƒd mO„S ^†yM. ƒ[‚_^ …m‡WGM.",
 63,"k, „l‚a‚b ~‚HhLM. ‰bƒU„S ƒW‚K„S ˆGƒ`^ D‡[ƒP ƒcS ƒq‚S [†yKLM.");
 MovePerson(63,7,1);
 DecPerson(63);
 NextEvent();
 end,
 [67]=function()
 JY.Smap={};
 SetSceneID(0);
talk(63,"‰bƒU„S ƒW‚K„S ŠPƒR‚S^ ‚^ˆjƒP ƒQq‚h ‹y†yKLM.");
 SetSceneID(0);
talk(9,"D‡[ G ŠRƒbG, †@ŠH „oƒW„Q ‚k†yM! mO„S g‚Ta‚f!");
 NextEvent();
 end,
 [68]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒwƒQ";
 JY.Base["D‚wC"]=2;
 AddPerson(1,25,17,2);
 AddPerson(2,20,9,1);
 AddPerson(3,11,16,0);
 AddPerson(65,17,13,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒwƒQ ƒP‚r‰R");
talk(2,"ƒnˆEŠi, ƒW‚K D‡[ƒP ^ƒN †wcG ‹pƒG‚h ‰RWLM. ˆEŠiŠ_ …w„u ˆ|Š[G „OM WLM.");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÓëÃÓóÃÌ¸»°>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [69]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"IˆA^ ‚eZo G…EƒG^ „O‚b ‡KWLM. ƒnˆEŠi, ‚SƒW ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ‰q…f †wc{ G…EƒG‚h ƒv†u‚V‚CZ.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚G‚PŠi, ‹n‚M ‹pKLM. ŠU ‚^…a…w„tLM. …f‚b D‡[ƒP ^ƒN †wcG‚f WLM.",
 1,"D‡[ ‚J{‚b ‚l…a ‰S‰r …BW‚TfƒW „V‚q ƒLG „Om. G‚W‰` I‡H …I„S [ŠVm?",
 65,"Nƒb ‚G‚PŠiŠ_ ‰RG „O‚S ŠXKLM.",
 1,"I‡H …IG[?");
talk(65,"ƒU„S GŒG ‚B, vvƒP ‚^ˆjŠ_ƒW ƒW‚K‚h ‚CƒvŠVKLM. …fŠs ‚K‚JŠ_ƒW ‰x„Q‚h ƒq‹E‚S ‚_‰naƒd †q‚nY‚C ŒEb †c†]aŠV‚CZ.",
 3,"Šoƒb …IG nL[?",
 65,"ƒ[‹@…h ƒ[ †q‚n^ Œc…X‚MS ƒBƒd vvƒP ‚^ˆjS …GGƒd sƒAS Šf„hn ˆGnŠgKLM. G‚h ‚o vv^ „^Q ƒYB ‚_‚TS Gˆnƒd ƒW‚K‚h „Qƒd „OKLM.",
 2,"‚SŠS G‹@ …IG. ‚_‰naƒ`M Du‚S ƒQq^ „C„k‚wƒ`.");
talk(65,"‰RG‚d ƒU„S G …IhLM. ‚^ƒZ ƒW‚Kf ƒQ‚TS ƒsƒ_ ‚KN q ‚a†yKLY? …fŠs‚h, nL ƒW‚K‚h ‚wB ‚K‡I‚V[. G‚_„S‚fA …fŠs‚b ƒ[ŠQM ŠPD †eƒ{ƒRY‚C ‚B@f ‚gˆ|„tLM.",
 1,"¡­¡­„a†ym. G ˆuƒm„S „C†yMA ‰I†ym.",
 65,"[, ‡N‚rWLM. G ƒbƒp ƒw` Šk‚C ‚k†yKLM.",
 1,"ŠZˆ|Š[S. ‰q †rf ‚C‡RS ƒhGL ˆO„NfƒW ‹]‚V[.",
 65,"‡N‚rWLM. ƒ[†{ ƒA…e^†yKLM.");
 MovePerson(65,8,2);
 DecPerson(65);
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÑĞ¾¿ÏÂÒ»²½ÎÊÌâ£®>
 NextEvent();
 end;
 end,
 [70]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ƒQ‚TS ƒsƒ_ vv‡z ‰jƒOƒGf‚b ƒOu ‚~ƒ}G ‚Z…xŒeLM. ‚SŠSXYZ?");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒQ‚TS ƒsƒ_ vvf ŠGƒWƒGf‚b ‚Cƒg ƒOu ‚~ƒ}G ‚^„RWLM.",
 1,"‚M, ‚J‡Y‡ZfQ ‚~ƒ}S ‹D Œfu…x.",
 2,"Šoƒb `‚EhLM. ƒ[†{ ‚SƒW ‚J‡Y‡ZG „O‚b ‡kƒwƒ{ƒm„S ^‚V‚CZ.");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÎªÇóµÃ¹«Ëïè¶Ö§Ô®È¥±±Æ½£®>
 NextEvent();
 end
 end,
 [71]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW ‡kƒwƒm„S ^‚V‚CZ.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚SƒW ‡kƒwƒm„S ^‚V‚CZ. ‡kƒwƒb ƒwƒQƒP ‡k‹Jf „OKLM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [72]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡kƒw";
 JY.Base["D‚wC"]=2;
 AddPerson(13,27,8,1);
 AddPerson(1,21,11,0);
 AddPerson(2,15,12,0);
 AddPerson(3,19,14,0);
 SetSceneID(48,5);
 DrawStrBoxCenter("‡kƒw ƒP‚r‰R");
talk(13,"[, ‚G‚P. ‚Sj ƒU†vG …d‚S bƒGY‚C [ŠVm?");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [73]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, ‰q…f ‚J‡Y‡ZŠ_ j‚r‚^ƒh a‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒOu…E ƒJƒK‚C„V ‚J‡Y‡ZŠ_‚b ˆ|Š[…wu‚b „KG Šo†yKLM.");
 end
 if JY.Tid==13 then--¹«Ëïè¶
talk(13,"‚G‚P, I‡H …IG[?",
 1,"ƒW‚KƒP D‡[G ‚r…x‚h ƒsƒ_ ƒQ‚TS ‰RPm. ‚~S ƒ_‚S ‰Iƒd…x aƒv ƒ_ ‚~ƒ}„Vƒm„S‚b ‚Sƒ`…[ ‡Ka[. ‚~ƒ}S ‹D Œfƒ` ‚KN q „O†ym?",
 13,"‚G‚P‚b „T„WfƒW ƒv‚h D‡S ƒbjG[. ƒGŒMG ‚~ƒ}S Œfƒ` …wu†ym.",
 1,"ƒdŠOKLM.",
 13,"ƒ[†{ …f ‚r†vS …hƒ`^‚V[.");
 AddPerson(54,3,20,0);
 MovePerson(54,7,0);
talk(54,"…f‚h ‚^‚jŠVKLY?",
 13,"v‡S, ƒ[‚_‚b ‚G‚P‡z ‰HŠ_ ƒW‚K‚h DƒO…e ^‚f.",
 54,"ƒW‚K„S ˆ|hLY?",
 13,"ƒ[ŠQM. ƒ[‹JfƒW ‚G‚PfQ ƒQ‚TS ‰RPM. v‡S, ƒ[‚_‚h ‰HŠ_ ƒsƒ_ƒd…x oM.",
 54,"‚G‚PŠi{ ‰HŠ_ ‰j…[ q „OML †~ƒm„S ƒGŒgLM. ƒGŒMG ^†yKLM.");
 ModifyForce(54,1);
 PlayWavE(11);
 DrawStrBoxCenter("v‡SG ‚G‚P‚Tf ^†iPM!");
talk(13,"ƒ[†{ v‡S, qƒd‚h ‹D B ‚KQ. ‚G‚P, I‡SS ‚P[.",
 1,"ƒdŠOKLM.");
 MovePerson( 54,7,1,
 2,7,1,
 3,7,1);
 DecPerson(2);
 DecPerson(3);
 DecPerson(54);
 --<·µ»ØÆ½Ô­×÷³ö±ø×¼±¸>
 NextEvent();
 end
 end,
 [74]=function()
 if JY.Tid==13 then--¹«Ëïè¶
talk(13,"tu‚h ‚P[.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [75]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒwƒQ";
 JY.Base["D‚wC"]=2;
 AddPerson(1,25,17,2);
 AddPerson(2,20,9,1);
 AddPerson(3,11,16,0);
 AddPerson(54,9,15,0);
 AddPerson(65,17,13,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒwƒQ ƒP‚r‰R");
talk(65,"‚G‚PŠi, „T…{ ƒGMuƒd „O„kKLM. ‚^ƒZ …b‚~S ƒe‚PB ‚K‡I‚V[.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [76]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, †wcG ƒGMuƒd „OKLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, †wcG Œi…@Q ƒGM„tLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ‡L‚^„V ƒ_u‡I‚V[.");
 end
 if JY.Tid==65 then--ÃÓóÃ
 if talkYesNo( 65,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [77]=function()
 PlayBGM(12);
talk(65,"ƒ[†{ ‚SƒW ƒW‚K„S ^‚V‚CZ.");
 WarIni();
 DefineWarMap(7,"d1ƒa ‡kB ‚B„e","1. eB ‚p…D",30,0,216);
 SelectTerm(1,{
 0,22,3,1,0,-1,0,
 -1,21,4,1,0,-1,0,
 -1,20,5,1,0,-1,0,
 -1,22,5,1,0,-1,0,
 -1,21,3,1,0,-1,0,
 53,21,2,1,0,-1,0,
 7,3,0,1,0,-1,0,
 149,2,0,1,0,-1,0,
 233,1,0,1,0,-1,0,
 });
 JY.Smap={};
 SetSceneID(0,3);
talk(65,"ƒW‚K‚b G ƒwƒQƒP …g‹JhLM. ƒWŠe…e ‚]‚Ta‚V‚CZ.");
 SetSceneID(0);
talk(3,"„i? C‚UG †dC„Q ‚k‚wƒv. I‡H …IGŠm?");
 SetSceneID(0);
talk(217,"aaa, ŠP‚f ŠP! vƒg„V „l ‹hA G ƒ{ƒb ƒ_ ƒuGM.",
 150,"G‚_„S‚fA ‡kB^ ‰HˆyŒjLM. ‚J‡XŠi, ƒ{S ƒv^ ‰Xa‡I‚V[.",
 8,"nL, ƒ[Šl q‚b ‚aM! ƒ{G „n‚S‚C‚b ƒuD ƒsƒd Š]‚C ‚k‚C„V, ƒ{S „quƒd ˆGnƒv‚b ƒuƒb „l„m ŒkM.",
 150,"¡­¡­",
 217,"ŠP‚f! ŠP‚f! ƒgƒbƒs@^ …fƒG „OM!");
 SetSceneID(0);
talk(2,"nI†GD DƒL Œl^ ‚q‚lS ‚^u‚b ‡KWLM.",
 65,"G‡Eƒb ‡kB, ‚J‡XG Mƒ~u‚b ˆmhLM.",
 1,"‚J‡XG‚f. ‚J‡XD …A‚l…a …BW‚Tf †~^P„k‚C.",
 83,"‚K‚J, ‚SŠSXYZ? G‚_„S ‚Z‡M „fa‚V†yKLY?",
 1,"nL, ƒ[ˆ} ‚Cƒv†R q‚b ‚am. †wc, †w‚oa[. †rS ‹D ‰Bn^…E†ym.",
 65,"a‚b q ‚a‚CZ. ‚G‚PŠi„V o ‡LG ‡O ‚SƒZ „O†yKLY.",
 54,"{…B ‚G‚PŠiG‡ILM. d^ „d‚Da‚b ‡LG‚CZ.");
 NextEvent();
 end,
 [78]=function()
 ModifyForce(150,8);
 ModifyForce(234,8);
 SelectEnemy({
 216,6,7,3,6,10,10,7,10,-1,0,
 310,2,9,2,6,6,10,9,15,-1,0,
 311,3,8,2,6,6,10,9,16,-1,0,
 312,7,6,3,6,5,10,8,10,-1,0,
 313,10,10,3,0,5,10,0,0,-1,0,
 314,10,12,3,0,6,10,0,0,-1,0,
 315,8,14,3,0,6,10,0,0,-1,0,
 316,18,11,3,0,5,10,0,0,-1,0,
 317,18,12,3,0,5,10,0,0,-1,0,
 274,1,7,2,6,6,4,5,11,-1,0,
 275,9,7,3,6,6,4,14,11,-1,0,
 332,13,8,3,6,4,14,17,11,-1,0,
 333,6,12,3,6,4,14,7,13,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [79]=function()
 PlayBGM(11);
 WarModifyAI(7,2);
 WarModifyAI(149,2);
 WarModifyAI(233,2);
talk(217,"aaa, G ƒ{ƒb ‡Yf †pƒb ƒuGƒv MŠK‚aM. GŒNƒRn, ƒ{‚oƒP ƒgƒbƒs@‚h ‡~ˆm ^ˆk[H‚f.",
 8,"ƒ_^ G‚_„S ‹[ƒvƒd …X‚b^.",
 150,"ƒOu ‚Tƒ}G ‚Z…x‚d ˆ~hLM. nL, †j†rG `‹HKLM.",
 2,"ƒnˆEŠi, ƒW‚[‚j‚C ‚kƒmA G ƒ{G „[ƒLƒP ‡Yf „|‚S†hLM.",
 3,"„[ƒL ‚Kdf ‡NŠW ƒ{‹YS „QML †iG „^‚wƒv. ƒOu‚h „V‚q ƒuG …fƒRƒP …d‡SGM.",
 1,"ŠoM, ‚C…rX q ‚aM. „[ƒLS mŒma‚f.",
 217,"„i? HŠs‚b I‡JGŠm? ƒOu‡z ŠGƒW†yM‚b †EŠm? aaa, s†w„O‚T. GŒNƒRn, „N†YS ‰Bƒ` ŠP‚f. „v„U‚h ƒsb Œn‚f.");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [80]=function()
 if WarMeet(54,217) then
 WarAction(1,54,217);
talk(54,"…fƒuG „[ƒLƒP ‚[ƒcG„S‚T. ‚G‚PŠi ‹IfƒW ƒ_ ‹MƒT‚h ƒsb …wƒ`…E†yM.",
 217,"‡m, aaa. †~ƒm„S ‚Su„Zƒb ŒNG„S‚T. ƒv‚h G†r q „OMƒd bƒG‚b ‚Z†oGL ‚S‹W q ‚a‚C, C‚_B ‚K…X.");
 WarAction(6,54,217);
 if fight(54,217)==1 then
talk(217,"ƒv‚b eBM. …ftƒm„S ƒsƒ_ ‚K…X¡­¡­",
 54,"…iŒoG „OM.");
 WarAction(4,54,217);
talk(217,"…v!");
 WarAction(18,217);
talk(54,"†eƒ{S B„Q‚b DƒLS ‚SŠS „oƒWa†y†sŠm.");
 WarLvUp(GetWarID(54));
 PlayBGM(7);
 DrawMulitStrBox("v‡SG eB‚h ƒqƒd ‚G‚P‚TG DƒL Œl‚h I‹xŠjM.");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £³£°£°S ƒYƒC!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
talk(217,"ƒv‚b eBM. …ftƒm„S ƒsƒ_ ‚K…X¡­¡­",
 54,"…v!");
 WarAction(4,217,54);
 WarAction(17,54);
 WarLvUp(GetWarID(217));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(217,"sq ‚a‚wƒv! vƒg„V ‹zQ ŠX‚SD G ƒ{ƒb ƒ_ ƒuG„kS ‹|…h.");
 PlayBGM(7);
 DrawMulitStrBox("‚G‚P‚TG DƒL Œl‚h I‹xŠjM.");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £³£°£°S ƒYƒC!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if (not GetFlag(163)) and WarCheckArea(-1,7,9,19,14) then
 PlayBGM(11);
talk(150,"‚K‚J, †[ …xƒRG †u‚wj‚C‚b ‚Z‚j[ƒv ‚Cƒg ƒ{S ƒv^ †q„iB…E WLM.",
 8,"ƒ[†G, ŠoM. ƒ{…ZS ‚A‚S‚f! ƒOuD ƒv^ ‰j‡SM.",
 234,"k.");
 --38 ¸Ä±äµØĞÎ:½«×ø±ê<2,2>µÄµØĞÎĞŞ¸ÄÎª£º0
 SetWarMap(3,3,1,0);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=60;
 WarDelay(12);
 DrawStrBoxCenter("ƒ{…ZG ‚Auƒd ‚J‡X‚TG „Hnˆk ƒvŠXM!");
 WarModifyAI(7,1);
 WarModifyAI(149,1);
 WarModifyAI(233,1);
 SetFlag(163,1);
 end
 WarLocationItem(5,11,85,68); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÌØ¼¶¾Æ ¸ÄÎª ¹³
 WarLocationItem(17,13,47,187); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÆ½ÆøÊé
 --WarLocationItem(11,18,125,510); --»ñµÃµÀ¾ß:ÌúµÑ
 end,
 [81]=function()
 SetSceneID(0,3)
talk(150,"…IA‚yD ‚aƒmƒv ƒn ƒb‡VS h„kKLM. †O‰HS bŒq‚SD „C†yKLY?",
 1,"ƒv‚b ‚G‚P‚f a[.",
 150,"[, ‡iƒNG ƒU„S ƒwƒQƒP ‚G‚PŠiG‚V‚TZ. ‚n†PX „U ‚wB ‚K‚VL †~ƒm„S ‡N‚rWLM. ‚^ƒZ ƒ{ƒm„S …w‚V‚S ‚J‡XŠiD Œr‚S ‚K‡I‚V[.");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚ±±º£³Ç¼û¿×ÈÚ£®>
 NextEvent();
 end,
 [82]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡kB";
 JY.Base["D‚wC"]=5;
 AddPerson(8,25,17,2);
 AddPerson(150,22,10,1);
 AddPerson(1,17,13,3);
 AddPerson(2,14,13,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("‡kB ƒP‚r‰R");
talk(150,"‚K‚J, ‚G‚PŠiS ‚ZŒs ŠXKLM.",
 8,"[, ‚G‚P. ‡kB‚h ‚wB ‚K‚VL †~ƒm„S ƒdŠOm.");
talk(8,"G ‚J‡X, ‡N‚ro …X‚M Gƒ^ M ˆ|X q ‚am.",
 1,"{‡Lo k‚b †E‚[‚V[. ƒOu‚b †wcƒP ‰Rƒm„S ƒW‚K„S ^ŠB †rG[.",
 8,"ƒW‚K„S ˆ|G[? ƒQ‚TS ^‚V‚b‚T. ƒvD vv^ ƒW‚K‚h ˆjM‚b ˆ|ƒb ƒR„km.",
 1,"ƒ[ŠQm. ‚CƒvŠB †rf ‚|‚r…x^ ‚J‚p…H‚b ƒuS ƒsƒd „@S ƒsŒuS ŠFG[.",
 8,"ƒ[ŠQm? ƒ[ŠQMA ‚T„XS ‹D ƒ_‚S …wu†ym. G‚W Dˆlf ‚_o ‡N‚rƒP ƒ]G[.");
talk(2,"ƒnˆEŠi, ƒW‚[‚j‚C ‚kƒmA …IS ƒ[‚jŠ~LM.",
 1,"ƒ[ŠQ‚T. ƒ[†{ ‚J‡X, ƒOu‚b ‡y †rG †PaL G„V ƒA…e^†ym.",
 8,"I‡SS ‚P[.",
 150,"†~ƒm„S ƒdŠOm.",
 2,"‚B‚T, …bFS ƒe‚Pa‚f.");
 --48 ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ĞìÖİÖ§Ô®ÌÕÇ«£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [83]=function()
 if JY.Tid==8 then--¿×ÈÚ
talk(8,"„@ƒ_‚V[.");
 end
 if JY.Tid==150 then--Ì«Ê·´È
talk(150,"ƒdŠOKLM. ‚G‚PŠiG DƒO‚VL ƒW‚K‚b ‚o†dhLM.");
 end
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [84]=function()
 PlayBGM(12);
 LvUp(150,4);
 LvUp(16,6);
 WarIni();
 DefineWarMap(8,"d1ƒa ƒW‚KI ‚B„e","1. ƒL ‚B†U*2. ‚G‚P^ ƒW‚Kƒ{ hƒ{",30,0,-1);
 SelectTerm(1,{
 0,3,16,4,0,-1,0,
 -1,1,15,4,0,-1,0,
 -1,2,15,4,0,-1,0,
 -1,2,16,4,0,-1,0,
 -1,4,17,4,0,-1,0,
 -1,3,17,4,0,-1,0,
 53,2,17,4,0,-1,0,
 15,29,12,3,0,-1,0,
 81,29,11,3,0,-1,0,
 63,29,13,3,0,-1,0,
 149,6,17,4,0,-1,1,
 });
 DrawSMap();
talk(65,"‚SƒW ƒW‚K„S †h‚VM.");
 JY.Smap={};
 SetSceneID(0,3);
talk(65,"‚G‚PŠi, ƒW‚K‚b ‡kBƒP …g‹JhLM. ‚SƒW ^‚V‚CZ.");
 NextEvent();
 end,
 [85]=function()
 SelectEnemy({
 62,25,12,4,6,14,1,22,13,-1,0,
 217,15,1,4,3,11,7,0,0,-1,0,
 115,26,9,4,6,11,1,22,12,-1,0,
 61,24,14,4,6,10,4,21,15,-1,0,
 19,8,1,4,1,11,23,0,0,-1,0,
 17,4,1,4,4,11,22,27,12,-1,0,
 256,5,0,4,4,7,1,27,11,-1,0,
 257,5,2,4,3,7,1,0,0,-1,0,
 336,25,14,4,6,7,15,20,12,-1,0,
 292,15,0,4,3,7,7,0,0,-1,0,
 293,15,2,4,3,7,7,0,0,-1,0,
 294,3,0,4,1,7,7,0,0,-1,0,
 295,3,2,4,1,6,7,0,0,-1,0,
 274,7,0,4,3,7,4,0,0,-1,0,
 348,6,1,4,4,6,19,27,10,-1,0,
 310,26,10,4,6,7,10,20,14,-1,0,
 328,25,16,4,6,7,13,22,14,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [86]=function()
 PlayBGM(11);
 WarModifyAI(15,2);
 WarModifyAI(63,2);
 WarModifyAI(81,2);
talk(63,"I‡JG‚f? ‚G‚P^ ŠPƒR‚S†[Mƒd? ‚~ƒ}ƒb Œv…XŠm? ¡­¡­Šo‚C ‚k‚T. ‚S‹cQˆe a…C…BG ƒi „UY‚C „qŒw…E oM.",
 18,"‚Z‚[ ƒWŠe…e‚f, ƒOƒgS ‚CƒQa…e …yM!",
 54,"ƒLƒP ƒQ‚TG ^YG ŠXKLM. ‰jˆlf ‡GˆGu‚C ˆ|ƒd ‚SƒW ƒW‚Kƒ{ƒm„S …w‚V‚CZ.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [87]=function()
 if (not GetFlag(1006)) and War.Turn==5 then
 PlayBGM(12);
 WarShowArmy(149);
 WarModifyAI(149,4,27,12);
talk(150,"‚G‚PŠi, ‚J‡XŠiƒP ‚XS …HƒR‚S G ‚|‚r…x^ DƒO…e ŠXKLM.");
 DrawStrBoxCenter("‚|‚r…x^ ‚CƒQa…e ŠXM!");
 PlayBGM(9);
 SetFlag(1006,1);
 end
 if WarCheckArea(0,10,28,14,29) then
 PlayBGM(7);
talk(1,"ŠoM, ƒW‚Kƒ{ƒm„S ƒRbƒsƒ_‚f. ‚Z‚[ Iua‚C ˆ|ƒd ƒ{ƒm„S ƒA…eƒv‚f.");
 DrawStrBoxCenter("‚G‚P‚TG ƒA…eŠgM.");
bonus_moneyexp_4()
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(3,"†|†}WLM, ƒnˆEŠi.",
 2,"ƒLƒP ƒQ‚TG [ƒG ‚Bf ‚SƒW ƒ{ƒm„S ƒR‚S†h‚VM.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG vv‚TS ƒAu„Qƒd ƒW‚Kƒ{f ƒR‚S‰tM.");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £³£°£°S …V„kM!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarMeet(2,63) then
 WarAction(1,2,63);
talk(2,"ƒv‚b eƒO, …x‚b ‡SƒaGM. IƒaG „O†Eˆe ƒv[H‚f.",
 63,"I‚XƒP Šz†K^ ƒSˆc‚C …X‚f. ƒ_^ C‚_a…X.");
 WarAction(6,2,63);
 if fight(2,63)==1 then
talk(2,"{…B vvƒP ‚^a ‚_ƒaG„S‚T. ‡mƒv ƒ[ Ik„S‚b ƒv‚h G†r q ‚aM.",
 63,"ˆEƒo^ Šo‚C ‚k‚wƒv! eƒO, „p GŠKS ƒG„FB ‚[…X.");
 WarAction(16,63);
 WarLvUp(GetWarID(2));
 else
talk(2,"{…B vvƒP ‚^a ‚_ƒaG„SM.");
 WarAction(17,2);
 WarLvUp(GetWarID(63));
 end
 end
 --WarLocationItem(16,1,117,511); --»ñµÃµÀ¾ß:È¦
 --WarLocationItem(5,19,131,512); --»ñµÃµÀ¾ß:±âÏá³µ
 end,
 [88]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒW‚K";
 JY.Base["D‚wC"]=0;
 AddPerson(9,25,9,1);
 AddPerson(69,11,10,3);
 AddPerson(62,7,12,3);
 AddPerson(17,24,17,2);
 AddPerson(18,20,19,2);
 SetSceneID(63,11);
 DrawStrBoxCenter("vv‚T g~");
 AddPerson(63,3,21,0);
 MovePerson(63,7,0);
talk(63,"‡p‚wWLM. …m‡WS ŠE„} ‚KŠVƒmƒv d‚_„S ‰jƒO‚C ˆfPKLM¡­¡­",
 9,"‚r{‚h ƒRƒmƒ`‚b Q nLM. ‚SŠS D‡[S ‹Q‚C ˆfP†sŠm? ƒOu ‚TG D‡[fQ ‹T u ‚aM.",
 63,"ƒwƒQƒP ‚G‚P^ ƒW‚K‚h DƒO…e †[ ˆ~f D‡[S ‹Q‚C ˆfPKLM.",
 9,"I‡JG! ƒ[ ‚G‚P ˆ|GŠm? ‡q…h ‚G‚P^ ‚SŠSab D‡[S ‰I‚b†M ˆ|j^?",
 63,"ƒ[ƒuƒb …fD ‚B‹u „a‚C ˆfWLM.",
 9,"‚M, D‡[S ‰I‚b GC ‚G‚PD ƒLGM! †@ŠH „oƒW„Q ‚k†yM! G‚W‰` ƒ_^ „L‰n …bFoM.");
 NextEvent();
 end,
 [89]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒW‚K";
 JY.Base["D‚wC"]=6;
 AddPerson(16,25,9,1);
 AddPerson(64,14,9,3);
 AddPerson(65,10,11,3);
 AddPerson(66,25,15,2);
 --AddPerson(18,20,19,2);
 AddPerson(1,5,19,0);
 AddPerson(2,3,18,0);
 AddPerson(3,7,20,0);
 SetSceneID(86,5);
 DrawStrBoxCenter("ƒW‚K ƒP‚r‰R");
talk(65,"‰BnŠXKLM.",
 16,"[, †wc. G‚Wf ‚G‚P‚h ŠU EƒDP‚wƒv. ‚G‚P, [ˆs„VG[.",
 1,"d„U DƒO…e ƒi q „O‚S M‚]hLM.",
 16,"†~ƒm„S ƒdŠOm.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÓëÌÕÇ«ÌÖÂÛ½ñºóµÄÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [90]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"d„U DƒO…e ƒi q „O‚S M‚]hLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"nGƒd ƒnˆEŠi, n…jn…jPKLM. vƒg„V ‹z„k‚SD ‚n…UP‚CZ.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚G‚P, †~ƒm„S ƒdŠOm.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚G‚PŠiG [‚C ‚kƒmŠVMA ƒOu ‚Z‚[ ƒc…~S ŒOS ŒPPKLM.");
 end
 if JY.Tid==66 then--³ÂµÇ
talk(66,"‡mƒv ‰p ‰jˆlƒb G‹HM BD ƒLG ‚IaL G‚_„S ƒA…eƒW‚C‚b ‚kS ƒuG[.");
 end
 if JY.Tid==16 then--ÌÕÇ«
talk(16,"vv‚Tƒb …A…w‚V M‚V ŠPƒR‚Sƒi ‹|…h ‚SŠSXYZ?",
 1,"vv‚b Šcu^ ‚Lƒd G„Q‚h n‚b ‚r†vG[. ƒ[fQ F‚BS ‰RB ‹b‚VM.",
 64,"‡mƒv …IG ƒ[u „Av„S…[YZ?",
 3,"B ƒsƒd ‚o „CA ƒ[„U ^ƒW `‚Ea‚CZ. ƒ[ …Iƒb dQ ŠEƒG‡I‚V[.",
 2,"…f‚b ‚TS ƒ_‚S ‰j„E…E oMƒd ‹bLM. ‰j„E…E„V IƒaG‚f X q „O‚CZ.");
talk(3,"‡m, eƒO ˆEŠi†C‚C ‚kƒm‡ILM. …fƒsM „l ‰jƒOƒd Š]‚S a‚VML.",
 2,"‚Io ƒL{ ŠGŒE‚S…E IƒaG‚f X q „OM. C‚_^ vv‚TG‚fA ƒU‚fŠB ƒU‚C. ˆEŠi, ƒa‚P‚h ƒsƒ_ @ˆjS ‰RX‚C ‰j…[‚C ‚S†s ‹JS …na‚V†yKLY? ˆEŠiŠ_ƒW Fa‡I‚V[! Fa‚VA ƒa‚Pƒv …ffQ ˆ|Š[B ‚K‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<¾ö¶¨ÊÇºÍ²Ü²Ù×÷Õ½»¹ÊÇÅÉÕÅ·ÉÇóºÍ£¿>
 NextEvent();
 end
 end,
 [91]=function()
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"[, ˆEŠi. …bFaƒG„S FaŠVKLY?") then
 RemindSave();
 SetFlag(219,1);
 PlayBGM(12)
talk(2,"‚SƒW …bF ƒe‚P‚h a‚V‚CZ.");
 JY.Status=GAME_SMAP_AUTO;
 WarIni();
 DefineWarMap(9,"d1ƒa mO ‚B„e","1. vv …D‚E",30,0,8);
 SelectTerm(1,{
 0,21,4,3,0,-1,0,
 -1,19,6,3,0,-1,0,
 -1,19,7,3,0,-1,0,
 -1,21,6,3,0,-1,0,
 -1,22,5,3,0,-1,0,
 -1,23,4,3,0,-1,0,
 53,20,7,3,0,-1,0,
 15,23,2,3,0,-1,0,
 63,20,3,3,0,-1,0,
 81,20,5,3,0,-1,0,
 --149,6,17,3,0,-1,1,
 });
 DrawSMap();
talk(2,"‚SƒW …bFa‚V‚CZ.",
 16,"ƒ[‚_ƒRG FPMA ƒOuD …bFa†ym. ƒLƒb ‚Cƒg mOf „OM a[.");
 JY.Smap={};
 SetSceneID(0,3);
talk(16,"bƒGƒW ƒW…g‹Jƒm„S ^A mO‚f‚b ‡EG „OKLM. vv‚TG †EƒGf gS ‡RKLM.",
 2,"vv‚TG Œy ‚_†MWLY? ˆEŠi, ‚SƒW mO„S g‚Ta‚V‚CZ.");
 NextEvent();
 end
 end
 if JY.Tid==3 then--ÕÅ·É
 if talkYesNo( 3,"ƒnˆEŠi, …f‚h ƒsƒ_ vv‚Tf @ˆjS ‰Ra‚VŠqLY?") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
talk(3,"ƒ[u FaŠVMA …y†Ma‚CZ. ŠoKLM, ‰bƒU„S MˆQ[†yKLM.");
 --15 ¶ÁÈë¶ÎÖ¸Áî:¶ÁÈëµÚ<8>¶ÎÖ¸Áî
 NextEvent(96); --goto 96
 end
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"vv‚Tƒb Œ[‚V ‚IaL FAƒm„S ŠGŒE‚b ƒuƒb a‚uhLM. ƒa‚P‚h ƒsƒ_ @ˆjS ‰Ra‚V‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"ƒv‚b ‰jˆlS …na†ym. C‚_^ ‚IaM aƒv ‚rƒGfƒW‚b ‚C‚C ‚km.");
 end
 if JY.Tid==66 then--³ÂµÇ
talk(66,"ƒL‚TG ‚IaL „A„AŠW ƒA…eƒv‚C ‚kS ƒuhLM. ƒa‚P‚h ƒsƒ_ @ˆjS ‰Ra‚V‚CZ.");
 end
 if JY.Tid==16 then--ÌÕÇ«
talk(16,"E…X ‡g‚Da‚b ƒuG C‚uG‚d ˆ|j^?");
 end
 end,
 [92]=function()
 LvUp(16,1);
 LvUp(64,1);
 LvUp(82,1);
 SelectEnemy({
 8,1,13,4,0,23,8,0,0,-1,0,
 386,0,13,4,3,18,15,8,0,-1,0,--µäÎ¤S
 68,0,14,4,0,14,13,0,0,-1,0,
 61,4,8,4,0,13,16,0,0,-1,0,
 16,2,13,4,0,14,7,0,0,-1,0,
 17,0,12,4,0,14,22,0,0,-1,0,
 115,3,12,4,0,14,1,0,0,-1,0,
 217,7,10,4,1,13,7,0,0,-1,0,
 62,8,14,4,1,14,1,0,0,-1,0,
 19,5,13,4,0,14,23,0,0,-1,0,
 256,10,14,4,1,10,1,0,0,-1,0,
 257,6,9,4,1,10,1,0,0,-1,0,
 258,6,14,4,0,10,1,0,0,-1,0,
 274,6,11,4,1,10,4,0,0,-1,0,
 275,9,13,4,1,9,4,0,0,-1,0,
 276,2,11,4,0,9,4,0,0,-1,0,
 292,7,15,4,1,10,7,0,0,-1,0,
 293,3,15,4,0,10,7,0,0,-1,0,
 294,1,14,4,0,9,7,0,0,-1,0,
 328,7,12,4,1,10,13,0,0,-1,0,
 329,0,10,4,0,10,13,0,0,-1,0,
 348,1,10,4,0,10,19,0,0,-1,0,
 349,1,15,4,0,9,19,0,0,-1,0,
 --
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [93]=function()
 PlayBGM(11);
talk(9,"‚G‚P G Œi‡pG, ƒ_ ƒQq‡z ŒzG „CML †@ŠH „oƒW„Q ‚k†yM. ‚G‚P‚TS Œ{†ja‚f.",
 2,"vv‚Tƒb {…B ‚_‚ThLM. ‡mƒv ‚rƒGfƒW‚b ƒOuD ‚C‚C ‚kKLM. ƒnˆEŠi, ‚Cƒgƒb …GƒG„S ŠGƒW ‰jƒO‚V‚CZ.");
 WarModifyAI(15,1);
 WarModifyAI(63,1);
 WarModifyAI(81,1);
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [94]=function()
 if WarMeet(3,18) then
 WarAction(1,3,18);
talk(3,"ƒv‡zƒW o‚F ŒE…x! ‰xˆ| ˆ|ƒd! †cŒD „O‚b …x‚b ƒv[H‚f.",
 18,"dˆF ƒGƒo^ …}…}a‚T. ƒ_^ C‚_a†yM.",
 3,"…yM!");
 WarAction(6,3,18);
 if fight(3,18)==1 then
talk(3,"†gS …Hn‚f!");
 WarAction(5,3,18);
talk(18,"HD ƒ_ ‹FS …Hn‚f.");
 WarAction(5,18,3);
talk(3,"o ‚W „l ŠS‡MM, …Hn‚f.");
 WarAction(4,3,18);
talk(18,"‡m, ‚_†Ma‚wƒv. G†r q ‚aM.");
 WarAction(16,18);
talk(3,"ˆGnƒvƒ`†sŠm, †~ƒm„S „Wˆda‚wƒv. „y‚fu O†c‚h jFB‚f.");
 WarLvUp(GetWarID(3));
 else
talk(3,"‡m, ‚_†Ma‚wƒv. G†r q ‚aM.");
 WarAction(17,3);
 WarLvUp(GetWarID(18));
 end
 end
 if (not GetFlag(1007)) and War.Turn==4 then
 PlayBGM(11);
talk(9,"…M, G‹@ ‚Bƒ}ƒm„S ‰jˆlG „C†y†sŠm? „l ‡G†bQ ŠP‚f.");
 WarModifyAI(61,1);
 WarModifyAI(115,1);
 WarModifyAI(19,1);
 WarModifyAI(258,1);
 WarModifyAI(276,1);
 WarModifyAI(293,1);
 SetFlag(1007,1);
 PlayBGM(10);
 end
 if (not GetFlag(1008)) and War.Turn==8 then
 PlayBGM(11);
talk(9,"„l‚b „Dn ‚K‚C ‚k†yM. ‚B ƒa‚~, ‡T‚J‚p!",
 1,"‡m, {…B vv‚TG„SM¡­¡­");
 WarModifyAI(8,1);
 WarModifyAI(68,1);
 WarModifyAI(16,1);
 WarModifyAI(17,1);
 WarModifyAI(294,1);
 WarModifyAI(329,1);
 WarModifyAI(348,1);
 WarModifyAI(349,1);
 SetFlag(1008,1);
 PlayBGM(10);
 end
 if (not GetFlag(1009)) and War.Turn==10 then
 PlayBGM(11);
talk(9,"I‡JG! g]^ b†aƒP ƒGKS …HƒtMƒd! ƒn…IG‚T, b†a‚h Škƒd „O„kM. fŒS, Du ‚aM. ‚B‚T …C…D! D‡[, ‚G‚P. ƒc…~ƒb ‡d‚V ŒEb ‚[…X!");
 WarAction(16,9);
 SetFlag(1009,1);
 PlayBGM(7);
 DrawMulitStrBox("¡¡vv‚TG ƒA…eŠgM.");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(9,"GŒNƒR! M‚V ‚J‚p ‚_ˆES ‹s‹t‚f! I‡JG! g]^ b†aƒP ƒGKS …HƒtMƒd? ƒn…IG‚T! g]ƒP q‚P‚h ‚P„E ‰Q ƒuG a‚uG„k‚wƒv. fŒS¡­¡­ Du ‚aM. ‚B‚T …C…D! D‡[, ‚G‚P. ƒc…~ƒb ‡d‚V ŒEb ‚[…X!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡vv‚TG ƒA…eŠgM.");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £³£°£°S …V„kM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 --WarLocationItem(4,20,135,513); --»ñµÃµÀ¾ß:±Ş
 --WarLocationItem(9,15,123,514); --»ñµÃµÀ¾ß:Á÷ĞÇ´¸
 end,
 [95]=function()
 JY.Smap={};
 SetSceneID(0,11);
talk(9,"‚B‚T Œa‚V ‚}‚TB g]‚h ‚C‰a‚f! ƒWŠe…e‚f!");
 SetSceneID(0);
talk(3,"‚S? vv^ ‚SŠS †h…xƒG ˆGnŠg‚C?",
 1,"‚Z‚j†ym. ‡mƒv ƒW‚K^ ‚wƒQ…Hƒb ƒuƒb ‡L‚Xa[. ƒO…m ƒW‚K„S ‰Bn†h‚VM.");
 --¶ÁÈëµÚ<10>¶ÎÖ¸Áî
 NextEvent(98); --goto 98
 end,
 [96]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒW‚K";
 JY.Base["D‚wC"]=0;
 AddPerson(9,25,9,1);
 AddPerson(69,11,10,3);
 AddPerson(62,7,12,3);
 AddPerson(17,24,17,2);
 AddPerson(18,20,19,2);
 SetSceneID(63,11);
 DrawStrBoxCenter("vv‚T g~");
 AddPerson(369,2,20,0);
 MovePerson(369,7,0);
talk(369,"‚K‚J, ƒn…IhLM. b†a^ g]‚h ‡RKLM.",
 9,"I‡JG? ‚SŠS G‹@ …IG. ƒn…IG‚T, HI „N†dPM. b†a G ‰ct „Gƒb ŒN, ƒ_^ ‚a‚b ŒoS ƒYƒ` ƒGKaML.");
 AddPerson(367,4,21,0);
 MovePerson(367,7,0);
talk(367,"ƒa‚P‚f‚b …x^ ‹qn‡z F‚BS ‰RWLM. ‚SŠSXYZ?",
 9,"ƒa‚P? ‚G‚PƒP ƒ[ ƒPd ˆ|GŠm. ‚G‚P^ F‚BS ‰RoMƒd? ‡m, aƒXG ‰I‚b‚wƒv. ƒa‚PfQ F‚BS …HnƒRG†yMƒd ‚Ba‚f. ŠoM, ƒWŠe…e g]„S ‰Bn^ b†a‚h Œ{nˆZM.");
 NextEvent();
 end,
 [97]=function()
 JY.Smap={};
 SetSceneID(0,11);
talk(9,"b†afQ g]‚h Šf„h†r q‚b ‚aM. ƒWŠe…e ‚}‚Ta‚f!");
 SetSceneID(0);
talk(3,"ƒ[‹@…h vv‚b ‚SŠS ƒA…eŠgSYZ? …f „GƒmA …A…w‚V ‹h‚SŒEŠbS ‹|…hZ.",
 1,"‚Z‚j†ym. ‡mƒv ƒW‚K^ ‚wƒQ…Hƒb ƒuƒb ‡L‚Xa[. ƒ{ƒm„S ‰Bn†h‚VM.");
 SetFlag(97,1);
 NextEvent(98);
 end,
 [98]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒW‚K";
 JY.Base["D‚wC"]=6;
 AddPerson(16,25,9,1);
 AddPerson(64,14,9,3);
 AddPerson(65,10,11,3);
 AddPerson(66,25,15,2);
 AddPerson(1,5,19,0);
 AddPerson(2,3,18,0);
 AddPerson(3,7,20,0);
 SetSceneID(86,5);
 DrawStrBoxCenter("ƒW‚K ƒP‚r‰R");
 MovePerson(1,7,0);
talk(16,"‚G‚P, G‚W‰` †~ƒm„S ƒn DˆlS …Hƒtm.");
 if GetFlag(97) then
talk(1,"n‚`LM. …fŠs^ o …Iƒb ‚aƒd vv^ ƒ~ƒ~„S ‚}‚TPS ŠFhLM.",
 16,"nL[, nL[. ƒOu‚h DƒO…e †[ G‚b ƒ[‚_ŠFG„km. ‚Cƒg ƒ_ …X‚MG †~ƒm„S ƒGŒ}[.");
 end
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÓëÌÕÇ«µÈÌ¸»°£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [99]=function()
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"ƒdŠOm. G„S‰l ƒW‚K^ ‚wƒQ…Hƒt‚wƒ`.");
 end
 if JY.Tid==66 then--³ÂµÇ
talk(66,"‚G‚P, ƒdŠOm.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"[ƒXG „O‚b ƒuƒb ‚Z‚[ ‚G‚PŠi ‡VhLM.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒW‚K^ I‚raL †~ƒm„S M‚]hLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…gS ‰I‚b …Iƒb †J‚V …X‚MG „Ka‚TZ.");
 end
 if JY.Tid==16 then--ÌÕÇ«
 if GetFlag(97) then
talk(16,"‚G‚P, Gƒuƒb ƒ_ Jƒb Fƒ{G[. ‚^ƒZ …Hn ‚K‚V[.");
talk(1,"Gƒuƒb?",
 16,"ƒOu ƒW‚Kf k„S‚^ƒh ‚BB [‚b ‚~ƒG„S …x†]†`ˆVG‚f a[.",
 1,"G‰S…l ˆHo ƒuS dQ ‚KƒNM‚b ˆ|Š[hLY?",
 16,"ƒOu^ ^gƒR I‡H m„oG†ym. d‚_„S Mƒ^‚CD ˆfaL ˆ|G[. †~ƒm„S „P ‚r†vfQ ‚Kƒd Š]m. ‚^ƒZ …Hn ‚K‚V[.");
 GetItem(1,58);
 end
talk(16,"‚G‚P, Nƒb ƒ[‚_fQ ‚^…aX …IG „Om.",
 1,"d^ X q „O‚b …IG‚fA „@S Ma†yKLM. ˆ|Š[a‡I‚V[.",
 16,"ƒdŠOm. mO‚h ƒ[‚_fQ ŠE„} Mƒ~uQ aƒd Š]m.",
 1,"k? …f „Gƒb ‚r†vG ƒ[‹@ ƒn…IS ‡N‡iX q ‚aKLM.",
 16,"nL[. G‚b ‚eƒNƒR{ CƒPB Fo …IG[. ƒW‚KƒP †eƒ{S D‡z‚KƒG ƒU‚fL ‚^ƒZ …Hn ‚K‚V[.",
 1,"„a†yKLM. ƒ[†{ ‚r†o„Q ‚kƒd ‚XS ‚i‚j†yKLM.",
 16,"…Hn ‚K‚V‚b‚wƒ`. Šom, ‡YwS …hƒ`^‚V[. ‡Ywƒb s‚K^ ˆc‚SƒvL ZŒIaQ „P q „OS ƒuG[.");
 NextEvent();
 end
 end,
 [100]=function()
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"mO‚h ‚^ƒZ ŠU ‚^…aa[.");
 end
 if JY.Tid==66 then--³ÂµÇ
talk(66,"‚G‚P, ƒdŠOm.");
 end
 if JY.Tid==16 then--ÌÕÇ«
talk(16,"‡YwS …huƒd mO„S ^‚V‚CZ.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, ƒ[†{ mO„S ^‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ƒ[†{ mO„S ^‚V‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚G‚PŠi, nL ‚K‚J. ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 ModifyForce(64,1);
 PlayWavE(11);
 DrawStrBoxCenter("‡YwG ‚G‚PƒP ‚^a^ „C„kM!");
talk(64,"‰bƒU„S mO„S ^‚V‚CZ. mO‚b ƒW‚K ƒW…g‹JƒP Jƒb ƒdShLM.");
 JY.Smap={};
 SetSceneID(0);
talk(64,"d^ mO„S ‚oƒ_a†yKLM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [101]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="mO";
 JY.Base["D‚wC"]=7;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,11,16,0);
 AddPerson(54,17,13,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("mO ƒP‚r‰R");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÓëÕÔÔÆµÈÌ½ÌÖ½ñºóÖ®ÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [102]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ƒ{‚KŠ_ƒW G ƒ{S …Hn ˆG‚f aŠVƒmL †~ ŠUˆY …IhLM. Gd ƒOufQD ƒ{G `‹HKLM.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ‚Z‚[^ ƒGŒ~aƒd „OKLM. …wƒZ‚S ƒOu ƒ{G `‹HƒmLYZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚G‚PŠi, ƒW‚KƒP †a‚n^ ‹Eƒj ‡KaL …f‚b ‚J‡Y‡ZŠ_ ‰Bn^ƒ` WLM.",
 1,"ƒ[ŠQm? v‡S, G‚Wf ƒn DˆlS …Hƒtm. ˆAŒW^ M‚V ‰HŠ_ vFS ‚nB „@„P ƒSG [u‚f ˆ[m.");
 ModifyForce(54,0);
talk(2,"v‡S, M‚V „VƒvƒG‚h ƒU‚f[.",
 3,"ƒv„VAƒb nL‚SD dˆF ‚_†Ma„l‚T. ‡O ƒsQ „CƒG‚h ƒU‚f„p.",
 54,"{‡Lo ˆ|Š[hLM. …f ‡Oo b…e‡L{ ‰HŠ_ ‚JS ƒoƒOƒd Š]KLM. ‚^ƒZ ˆuv†da‡I‚V[.",
 3,"[ƒX Bƒb v‡SƒP ‡pŠZ…BGM. …X‚V…x!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 --µÚÒ»ÕÂ¡¡¶ö»¢ÂÀ²¼À´·Ã
 [103]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d1ƒa¡¡Šv‚Kƒj ‚m b†a";
 DrawStrBoxCenter("d1ƒa¡¡Šv‚Kƒj ‚m b†a");
 LoadPic(6,1);
 DrawMulitStrBox("¡¡‚G‚P^ mOf …xu ‹QS IŠq, b†a‡z vv‚b g]fƒW ‰jƒOƒd „O„kM. b†a‚b g]‚h Šf„hn ˆu ŒE…I ‡Eƒm„S |ƒmƒ` PM. ‹n‚Mf‚b ˆEƒo^ b†afQ ‚GuPƒmƒv vvƒP „T‚vf ‚@ƒ` M‚V Oaƒd, b†a‚Tƒb ‡OM‚V ‹XD‚b ƒNƒo^ „C„kM.");
 LoadPic(6,2);
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="mO";
 JY.Base["D‚wC"]=7;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,11,16,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("mO ƒP‚r‰R");
talk(2,"ƒnˆEŠi, vv^ b†a‚h „_‚S b†a‚b G‡E…f‡E ‹XD‚b ‚Z†ohLM.",
 3,"C„wG‚CZ. k‚Bf oƒP D‹YfƒW …M‰R†Eƒj †nƒshLM.",
 64,"‡mƒv b†a‚b ‹Iƒm„S ‚SŠSX‚CZ? d ~‚CD ‚a‚b ‹n‚Cj…h ˆ|hLM.",
 1,"¡­¡­");
 AddPerson(83,1,5,3);
 MovePerson(83,7,3);
talk(83,"‚K‚J, ƒ{‚oS Še…eƒsƒd ‰BnŠXKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Ìı¼òÓº»ã±¨£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [104]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, …y‡rƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, …y‡rƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, …y‡rƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"ƒ{‚o †eƒ{ƒR ˆ|„S‚b mOf „[ƒLG …x‚K …bŒ{oMƒd WLM.",
 64,"ƒ[ŠQKLM. …fŠsD ŒZ „y‹~ ƒ[ „[ƒLƒRS „P‚S„quƒ` P‚CZ.",
 83,"G‡Ef †[ ‚C Œv…X „C‚C ‚kƒtKLM. ˆM†dS …Vƒmƒ`A ƒO…m j†ZƒP „[ƒLS mŒmB…E WLM.",
 1,"ŒRƒb ˆ|G[. ƒ[†{ DƒLƒRƒb ‚SƒZf …~‚S „Om? ‡Yw, n‚b ƒU^ „Om?",
 64,"„[ƒLƒb ‚|„[, a‚w, Eƒ{ ƒo ‡Ef …~‚S „OKLM.",
 1,"‚|„[, a‚w, Eƒ{G‚f. ŠoM, ‚TS ƒ_‚S „[ƒLS „P‚S„qu…x.",
 2,"ƒnˆEŠi, …bF ƒe‚P‚h a‚V‚CZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<É¨Æ½É½Ôô£®>
 NextEvent();
 end
 end,
 [105]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW …bFa‚V‚CZ. ‹DDF ŒZGG…E …f‚h „VƒvA ‡YD ‚o ‚_ƒd FuŒjLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"„[ƒL Iu‚f BD „N†dƒb ƒgƒAhLM. ƒ[ƒRfQ gMA HG ƒW‚C ‚k‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"„[ƒLG …fu ƒSˆcQ Še q‚b ‚aM. DƒL mŒmƒb o‚VD †w‹a q ‚aM.");
 end
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [106]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(2,"ƒnˆEŠi, ‚SƒZ„S ‡yYZ?");
 NextEvent();
 end,
 [107]=function()
 local menu={
 {" mOƒ{ƒm„S",nil,1},
 {"¡¡‚|„[ƒm„S",nil,1},
 {"¡¡Eƒ{ƒm„S",nil,1},
 {"¡¡a‚w„S",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 local n=0;
 if GetFlag(8) then
 n=n+1;
 end
 if GetFlag(9) then
 n=n+1;
 end
 if GetFlag(10) then
 n=n+1;
 end
 if r==1 then
 if n==0 then
talk(2,"ƒnˆEŠi, DƒLS aƒvD ‹Q‚C ˆfPKLM. ‚SƒW mŒma‚V‚CZ.");
 elseif n<3 then
 if talkYesNo( 2,"ƒnˆEŠi, DƒLS M ‹Q‚C ˆfP‚b…h ƒJƒK†yKLY?") then
 NextEvent(121); --goto 121
 else
talk(2,"g‚TX ƒc…q‚h M‚V FB ‚K‡I‚V[.");
 end
 else
 NextEvent(121); --goto 121
 end
 elseif r==2 then
 if GetFlag(8) then
talk(2,"‚|„[ƒP DƒLƒb G†w mŒmPKLM. M‡M ‡ES „Q…e †h‚VM.");
 else
talk(2,"„a†yKLM, ‚|„[ƒm„S ^†yKLM.");
 SetSceneID(0);
 NextEvent(108); --goto 108
 end
 elseif r==3 then
 if GetFlag(9) then
talk(2,"Eƒ{ƒP DƒLƒb G†w mŒmPKLM. M‡M ‡ES „Q…e †h‚VM.");
 else
talk(2,"„a†yKLM, Eƒ{ƒm„S ^†yKLM.");
 SetSceneID(0);
 NextEvent(112); --goto 112
 end
 elseif r==4 then
 if GetFlag(10) then
talk(2,"a‚wƒP DƒLƒb G†w mŒmPKLM. M‡M ‡ES „Q…e †h‚VM.");
 else
talk(2,"„a†yKLM, a‚w„S ^†yKLM.");
 SetSceneID(0);
 NextEvent(116); --goto 116
 end
 end
 end,
 [108]=function()
--if n>=1 then
	change_mode()
--end
talk(2,"‚_‚AS ‹s…c‡I‚V[.");
 PlayBGM(12);
 WarIni();
 DefineWarMap(10,"d1ƒa ‚|„[ ‚B„e","1. ƒL ‚B†U*2. ƒL‚T ‡g‚D",40,0,-1);
 SelectTerm(1,{
 0,23,11,3,0,-1,0,
 -1,22,11,3,0,-1,0,
 -1,22,12,3,0,-1,0,
 -1,24,10,3,0,-1,0,
 -1,25,10,3,0,-1,0,
 -1,25,11,3,0,-1,0,
 -1,21,10,3,0,-1,0,
 });
 SelectEnemy({
 375,4,2,4,2,12,14,0,0,-1,0,
 310,26,1,4,4,10,10,29,6,-1,0,
 311,14,5,4,1,10,10,0,0,-1,0,
 312,15,5,4,1,8,10,0,0,-1,0,
 313,9,2,4,0,10,10,0,0,-1,0,
 314,7,1,4,0,8,10,0,0,-1,0,
 315,4,1,4,0,7,10,0,0,-1,0,
 316,5,2,4,0,7,10,0,0,-1,0,
 332,25,2,4,4,8,14,29,6,-1,0,
 333,5,1,4,0,8,14,0,0,-1,0,
 336,24,3,4,4,10,15,29,6,-1,0,
 337,8,3,4,0,9,15,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [109]=function()
talk(376,"‚SŠS ‚G‚P‡z ‰j‡S†M ˆ|j^? ƒw`ƒP {[^ Š} ƒuGL „y‚fu ‡g‚Da…x.",
 3,"DƒL ƒaqƒRn, ‚SƒW ƒv‡z C‚_B M[. ZŠr ˆuG ‹D I„k‚wƒv.");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [110]=function()
 if (not GetFlag(1010)) and War.Turn==3 then
talk(64,"‚K‚J, G‡E DƒLƒb bƒaq^ G‰AMƒd WLM.",
 3,"I‡JG? bjG‚fƒd?",
 1,"b…x ‚[ƒcG‚d ˆ|G[? †~ƒm„S ‚_†ia‚T.",
 3,"ƒnˆEŠiG ^ƒW ‡g‚DS ‡baƒd ˆj‡LGƒv J‚V‚CZ. ŠIŠI!",
 1,"I‡H `‚ES a‚b QŠm?",
 376,"†[ …x^ ƒ[ GŠK‚q ‚G‚P‚f BD ‚[ƒcƒP ‚n‡nƒb ƒo„E…E‚C. ŠP‚f.");
 WarModifyAI(310,1);
 WarModifyAI(313,1);
 WarModifyAI(314,1);
 WarModifyAI(332,1);
 WarModifyAI(333,1);
 WarModifyAI(336,1);
 WarModifyAI(337,1);
 SetFlag(1010,1);
 end
 if WarMeet(1,376) then
 PlayBGM(11);
 WarAction(1,1,376);
talk(376,"‚G‚P, ƒv‚h G†r q „O†ym?");
 WarAction(5,376,1);
 if fight(1,376)==1 then
talk(376,"n, ‚o „C†ym. nI†GD ‚G‚PŠiŠ_ ‹FS ƒR q‚b ‚am. ˆH„Aa†ym. ‚G‚PŠi, nY‚b d^ ŠUˆfPKLM.");
 ModifyForce(376,1);
 PlayWavE(11);
 DrawStrBoxCenter("G‚XG ‚G‚P‚Tf ^†iPM!");
 SetFlag(11,1);
 WarLvUp(GetWarID(1));
 NextEvent();
 else
 JY.Status=GAME_WARLOSE;
 PlayBGM(4);
 WarDelay(4);
 WarLastWords(GetWarID(1));
 WarAction(18,GetWarID(1));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 WarLocationItem(0,10,35,12); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÂäÊ¯Êé
 WarLocationItem(8,8,34,188); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÕ¨µ¯
 --WarLocationItem(11,13,140,515); --»ñµÃµÀ¾ß:Æ¤¼×
 --WarLocationItem(3,17,147,516); --»ñµÃµÀ¾ß:ÊÖÅÆ
 end,
 [111]=function()
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG ‚|„[ƒP DƒLS mŒmPM.");
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £´£°£°S ƒYƒC.");
 SetFlag(8,1);
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(120); --goto 120
 end,
 [112]=function()
--if n>=1 then
	change_mode()
--end
talk(2,"‚_‚AS ‹s…c‡I‚V[.");
 PlayBGM(12);
 WarIni();
 DefineWarMap(12,"d1ƒa Eƒ{ ‚B„e","1. ƒL ‚B†U*2. ƒL‚T ‡g‚D",30,0,-1);
 SelectTerm(1,{
 0,7,15,4,0,-1,0,
 -1,6,14,4,0,-1,0,
 -1,5,14,4,0,-1,0,
 -1,5,15,4,0,-1,0,
 -1,8,14,4,0,-1,0,
 -1,8,15,4,0,-1,0,
 -1,9,15,4,0,-1,0,
 });
 SelectEnemy({
 223,19,2,3,2,12,10,0,0,-1,0,
 310,17,4,3,0,10,10,0,0,-1,0,
 311,18,4,3,0,10,10,0,0,-1,0,
 312,4,2,4,4,6,10,16,5,-1,0,
 313,5,3,4,4,6,10,17,5,-1,0,
 314,6,3,4,1,8,10,0,0,-1,0,
 315,6,4,4,1,7,10,0,0,-1,0,
 332,18,2,3,0,8,14,0,0,-1,0,
 292,16,5,3,1,6,7,0,0,-1,0,
 293,18,5,3,1,5,7,0,0,-1,0,
 294,2,1,4,1,6,7,0,0,-1,0,
 295,3,2,4,1,6,7,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [113]=function()
talk(224,"‚G‚P‚b ‚UwƒP ‚qS ƒwFX „U‚^ƒh ‚IBg …xM. ‚Cƒgƒb „A„AŠW ‡g‚Da‚b „KG ‹o†yM.",
 3,"ƒnˆEŠi, DƒLD ‚r†vhLM. G„Q„S …@G‚jA …X‚MS ƒdŠPKS‚CD ‚Z‹{LM.",
 1,"„a†yM, B ƒs…x.");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [114]=function()
 if WarMeet(1,224) then
 PlayBGM(11);
 WarAction(1,1,224);
talk(224,"‚G‚P, ƒv‚h G†r q „O†ym?");
 WarAction(5,224,1);
 if fight(1,224)==1 then
talk(224,"‚G‚PŠi, ‹FS „}„I …I ‡p‚wWLM. ‹Iƒm„S‚b …X‚MS ƒdŠPKƒd ‡iƒNS ‚i‚j†yKLM.");
 ModifyForce(224,1);
 PlayWavE(11);
 DrawStrBoxCenter("va^ ‚G‚P‚Tf ^†iPM!");
 SetFlag(13,1);
 WarLvUp(GetWarID(1));
 NextEvent();
 else
 JY.Status=GAME_WARLOSE;
 PlayBGM(4);
 WarDelay(4);
 WarLastWords(GetWarID(1));
 WarAction(18,GetWarID(1));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 WarLocationItem(12,16,19,14); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º½£ÊõÖ¸ÄÏÊé
 --WarLocationItem(8,4,75,517); --»ñµÃµÀ¾ß:¸Öµ¶
 --WarLocationItem(6,16,81,518); --»ñµÃµÀ¾ß:°å¸«
 end,
 [115]=function()
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG Eƒ{ƒP DƒLS ‰S‰rPM.");
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £´£°£°S ƒYƒC.");
 SetFlag(9,1);
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(120); --goto 120
 end,
 [116]=function()
--if n>=1 then
	change_mode()
--end
talk(2,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 PlayBGM(12);
 WarIni();
 DefineWarMap(11,"d1ƒa a‚w ‚B„e","1. ƒL ‚B†U*2. ƒL‚T ‡g‚D",30,0,-1);
 SelectTerm(1,{
 0,23,15,3,0,-1,0,
 -1,23,16,3,0,-1,0,
 -1,24,15,3,0,-1,0,
 -1,22,15,3,0,-1,0,
 -1,23,14,3,0,-1,0,
 -1,24,17,3,0,-1,0,
 -1,25,16,3,0,-1,0,
 });
 SelectEnemy({
 228,3,3,4,4,12,10,5,9,-1,0,
 310,4,2,4,4,10,10,6,8,-1,0,
 311,4,4,4,4,10,10,6,10,-1,0,
 312,5,3,4,4,9,10,8,8,-1,0,
 313,6,3,4,4,9,10,8,9,-1,0,
 314,6,4,4,4,8,10,8,10,-1,0,
 315,15,5,4,1,8,10,0,0,-1,0,
 316,17,5,4,1,7,10,0,0,-1,0,
 317,16,6,4,1,7,10,0,0,-1,0,
 336,9,7,4,1,11,15,0,0,-1,0,
 337,7,9,4,1,11,15,0,0,-1,0,
 274,8,8,4,1,10,4,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [117]=function()
talk(229,"Šo‚C ‚kM. D‡[ƒP ‚TG‚fA G†r qD „O†yƒmƒv ‚G‚PƒP ‚Tƒb „V„V„Q ‚kM. ‰jƒO‚C ˆ|ƒd ‡g‚Da…x.",
 83,"‚K‚J, DƒLS „Q‡I‚V[. ƒ[†G…E„V …f B…vS ‚aL q „OKLM.");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [118]=function()
 if WarMeet(1,229) then
 PlayBGM(11);
 WarAction(1,1,229);
talk(229,"‚G‚P, ƒv‚h G†r q „O†ym?");
 WarAction(5,229,1);
 if fight(1,229)==1 then
talk(229,"ƒn…IG‚T, ‚SŠS ƒ[ GŠK„V ƒR‚SD …y†iG ƒWƒXo ‚G‚P‚d ˆ|j^? D…fŠW ‰j…[ q ‚aM. ‚G‚PŠi, ‡g‚Da†yKLM.");
 ModifyForce(229,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚l„XG ‚G‚P‚Tf ^†iPM!");
 SetFlag(15,1);
 WarLvUp(GetWarID(1));
 NextEvent();
 else
 JY.Status=GAME_WARLOSE;
 PlayBGM(4);
 WarDelay(4);
 WarLastWords(GetWarID(1));
 WarAction(18,GetWarID(1));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 WarLocationItem(0,7,38,16); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºäöÎĞÊé
 --WarLocationItem(11,20,130,519); --»ñµÃµÀ¾ß:Í­Âà
 --WarLocationItem(9,8,126,520); --»ñµÃµÀ¾ß:¹Ä½Ç
 end,
 [119]=function()
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG a‚wƒP DƒLS mŒmPM.");
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £´£°£°S ƒYƒC.");
 SetFlag(10,1);
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(120); --goto 120
 end,
 [120]=function()
 JY.Smap={};
 SetSceneID(0,3);
 if GetFlag(8) and GetFlag(9) and GetFlag(10) then
talk(2,"ƒnˆEŠi, DƒLS ‚Z‚[ mŒmPKLM. mO„S ‰Bn^‚V‚CZ.");
 NextEvent(121); --goto 121
 else
talk(2,"ƒnˆEŠi, ‚SƒZ„S ‡yYZ");
 NextEvent(107); --goto 107
 end
 end,
 [121]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="mO";
 JY.Base["D‚wC"]=7;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,11,16,0);
 AddPerson(83,9,15,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("mO ƒP‚r‰R");
talk(2,"mOƒP †eƒ{ƒRG ƒnˆEŠiŠ_ ‡N‚r‚h ‚Baƒd Š]M WLM.");
 AddPerson(355,1,5,3);
 MovePerson(355,7,3);
talk(355,"‚G‚PŠi, …fŠs‚h ‚nB „[ƒLS ‚aŒi ‚K‚VL ‡N‚rWLM. Gd …X‚M ‹^ƒd M†t q „OQ „C„kKLM. Gƒuƒb ƒdS †eƒ{ƒRƒP Jƒb Fƒ{GL …Hn ‚K‡I‚V[.");
 if GetFlag(8) then
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°S …V„kM.");
 end
 if GetFlag(9) then
 GetItem(1,17);
 end
 if GetFlag(10) then
 GetItem(1,152); --´Ó39×ÇÁ÷Êé ¸ÄÎª 152Á¬»·îø
 end
 --¶îÍâÔÙÔùËÍÎäµÀÖ¸ÄÏÊé
 if GetFlag(8) and GetFlag(9) and GetFlag(10) then
 GetItem(1,66);
 end
talk(355,"‚G‚PŠi, ‹Iƒm„SD mO‚h ‚C‰a ‚K‡I‚V[. ƒ[†{ ƒA…e^†yKLM.");
 MovePerson(355,9,2);
 DecPerson(355);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë¹ØÓğµÈÌ¸»°£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [122]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"DƒLS M „Qƒd ƒvL mOD …Xƒlƒ_ ‚oF„C„k‚wƒv.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"†@} ƒ[ ‹DDFƒRƒb G ƒa‚PƒP C‚_^ ˆf ‹k‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"„N†dƒb ƒgƒAhLM. ‡O I‡H ‚tƒd^ „OS‚C ‚Z‹{LM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚K‚J, †P‚r^ †[ ‡KWLM.");
 AddPerson(367,1,5,3);
 MovePerson(367,7,3);
talk(367,"‚G‚PŠi, D‡[ŠiƒP ‚~ƒo^ ‚n‚eWLM. ‚SƒW ƒW‚K„S [‡I‚V[.",
 3,"I‡JG? D‡[ ‚JƒP ‚~G ‚n‚eaMƒd.",
 64,"„a†ym. ‰bƒU„S ^†ym.",
 367,"k, D‡[Šiƒb ƒW‚K e…ff „T‡ILM. ‚^ƒZ ƒWŠe…e ‚K‡I‚V[.",
 2,"ƒnˆEŠi, ‚SƒW ^‚V‚CZ.",
 367,"‚G‚PŠi, ‚SƒW ƒW‚K e…f„S ^‡I‚V[. o‚V^ †PWLM. D‡[ŠiG ‚n„`a‡ILM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ĞìÖİÌÕÇ«¹ÙÛ¡¿´ÍûÌÕÇ«£®>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [123]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒW‚K";
 JY.Base["D‚wC"]=6;
 AddPerson(2,7,10,3);
 AddPerson(3,5,11,3);
 AddPerson(1,7,11,3);
 AddPerson(65,19,13,1);
 AddPerson(82,24,16,1);
 SetSceneID(45,2);
 DrawStrBoxCenter("ƒW‚K D‡[ e…f");
talk(65,"[, ‚G‚PŠi. …Xƒl ŠU [ŠVKLM. ‚SƒW ‚K‚JS ‹p‚CZ.");
 MovePerson(1,5,3);
 MovePerson(1,1,0);
talk(1,"D‡[ ‚J, ‚^ƒZ ˆuvu ŠUa‡I‚V[.");
talk(16,"[, …Xƒl ŠU [ŠVm. ‚G‚P, ƒ[‚_fQ X ˆ|G „Om. ƒ_ ‚XG Œv…X …g‚C ‚kƒtƒmL ‚^…aX …IG „Om.",
 1,"I‡H …IG‡ILY?",
 16,"ƒ[‚_^ ƒW‚K ‚|q‚h ŠEn ‚K‚C ‚k†ym?",
 1,"ƒ[ I‡H ˆ|Š[G‡ILY.");
talk(65,"†hJƒ~ŠpQ bƒG†y‚C„V G‚b ‚eƒNƒR{ CƒPB Fo …IG[.",
 82,"‚G‚PŠi, …fŠs ‚K‚Jƒm„S ^ƒa ‚S…[u‚b ‡LG‡ILM. ‚^ƒZ ƒW‚K‚h ‚C‰a ‚K‡I‚V[.");
 MovePerson( 2,4,3,
 3,4,3);
talk(2,"ˆEŠi, I‡JS ˆoEG‡ILY. ˆEŠi„VƒP ~‚C^ `ƒG‚b …IhLM.",
 3,"D‡[ ‚JG …fu ‡ba‡ILM. ƒnˆEŠi, ‚SƒW Fa‚V‚CZ.");
talk(65,"ƒW‚K‚b ‚r„NfƒW ‚J‚p…H‚b ˆmhLM. ƒLfQ Šf„hƒG†sL ‚G‚PŠiŠ_ ŠEƒG‚b „KG ‹oMƒd b‹HKLM.",
 82,"‚G‚PŠi, ‚^ƒZ ‰RS ƒR‚S ‚K‡I‚V[.");
talk(16,"ƒ_ ‰RS …Hn ƒeMA boG ‚a†ym. ‚G‚P, ‚^ƒZ …Hn ‚K‚V[.",
 1,"„a†yKLM. G ‚^„Ro ‚G‚P, …HƒR†yKLM.",
 16,"…Hn ‚K‚V‚b‚wƒ`. ƒdŠOm. Gd boG ‚am. †wc, ŠU „OQ.",
 65,"‚K‚J!");
 DrawMulitStrBox("¡¡D‡[G ƒoCS ‹XŠgM.");
talk(65,"‚G‚PŠi, Gd …fŠs ‚K‚JG‡ILM.",
 82,"ŠU ‚^…a…w„tLM.");
 LvUp(65,3);
 ModifyForce(65,1);
 if GetFlag(219) then
 LvUp(82,3);
 else
 LvUp(82,4);
 end
 ModifyForce(82,1);
 PlayWavE(11);
 DrawStrBoxCenter("†wc{ †w„NG ^†iPM.");
talk(65,"…jMf„V ‡d„} „OS q‚b ‚aKLM. ‚G‚PŠi, …fŠs‚b ‰q…f ƒP‚r‰Rƒm„S ^†yƒmL [Œs ‚K‡I‚V[.",
 82,"‚K‚J, ‰q…f ^ „O†yKLM.");
 MovePerson( 65,2,2,
 82,4,2);
 MovePerson( 65,1,1,
 82,1,1);
 MovePerson( 65,4,2,
 82,4,2);
 DecPerson(65);
 DecPerson(82);
 DrawSMap();
talk(2,"ƒOuD ƒP‚r‰Rƒm„S ^…x. ƒa‚P, ^…x.",
 3,"k.");
 MovePerson( 2,4,2,
 3,4,2);
 DecPerson(2);
 DecPerson(3);
 DrawSMap();
 NextEvent();
 end,
 [124]=function()
 JY.Smap={};
 SetSceneID(-1);
 LoadPic(7,1);
 DrawMulitStrBox("¡¡G IŠq vv‚b ‚l…aƒP ‰x‡iS „P‚Sƒ_ƒd ‡qd‚h ‚wB „Y†ofƒW ‡m†gƒm„S D‹YS ‹Z‹HM. ‡qd‚b vv ƒkf ƒGN ‡EG ‚a‚S ‡d…xŠH ƒ[ƒP ƒ]S ‚i„gƒd, vv‚b ‚Ud‚h ‡Y‚of †p„kM.");
 DrawMulitStrBox("¡¡„m…It‚sƒP ƒGƒo‚h „d vvfQD …X‚Mf ‚@u‚b …x^ „O„kƒmL, ƒU„S b†a‡z ‚G‚PŠbM.");
 LoadPic(7,2);
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒW‚K";
 JY.Base["D‚wC"]=6;
 AddPerson(1,25,9,1);
 AddPerson(2,14,9,3);
 AddPerson(3,10,11,3);
 AddPerson(65,25,15,2);
 AddPerson(82,21,17,2);
 SetSceneID(86,5);
 DrawStrBoxCenter("ƒW‚K ƒP‚r‰R");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ÒéÊÂÌüÑĞ¾¿½ñºóµÄ¶Ô²ß£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [125]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"†~ƒm„S nY‡S ‚r†vS ŒO„k‚wƒv.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"D‡[ ‚JS ‚nBƒW‚fD …A…w‚V ƒW‚K‚h ‚C‰a…E‚CZ. ƒ[ŠQ‚C ‚kKLY, ƒnˆEŠi.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"ƒW‚K‚b ‚r„NG ƒLf Še…e‰jb ‚C‰JƒG ‚Sƒ`‡S ˆmG[.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, b†a^ ŠXKLM.");
 PlayBGM(11);
 AddPerson(5,-5,24,0);
 DrawSMap();
 MovePerson(5,5,0);
talk(5,"n, ‚G‚P. [ˆs„VG[. ƒ[‚_fQ ‰RX …IG ‹D „Om.");
 MovePerson(5,5,0);
 AddPerson(76,3,18,0);
 AddPerson(80,7,20,0);
 MovePerson( 76,3,0,
 80,3,0);
 NextEvent();
 end
 end,
 [126]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"b†a ˆ|G[? ƒv‚b b†a‚h …HnƒRG‚b …h …A‚_a[.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, C‚_^ ƒ[ b†ahLY? `‚EX ƒuD ‚aKLM. b†a ‚i‚n‚b „VƒS „sZD ‚aKLM.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, b†a^ I‡H ˆ|S X‚C‚b ‰cJaN OLM. C‚_a‚C ‚k‚b „KG ƒW‚Kf G„BMƒd ‹bLM.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"b†aƒP ‚Cƒg ‹n‚C^ Œ@aƒG‚b aƒv, ƒ[…xfQ‚b ƒNƒP‚f‚b ƒuG ‚aKLM.");
 end
 if JY.Tid==76 then--³Â¹¬
talk(76,"‚G‚P, ‚^ƒZ ƒOu‚h D‡z‚K‚V[.");
 end
 if JY.Tid==80 then--ÕÅÁÉ
talk(80,"‚G‚P, Šoƒb †CS ƒGMuƒd „Om.");
 end
 if JY.Tid==5 then--ÂÀ²¼
talk(5,"vvfQ Oo ‡D„S [R‚l‚o G‡E…f‡ES ‹X‰Bƒtm. ƒ[‚_^ ƒW‚Kf „OM‚b ˆ|S Š^ƒd ‹qnŠXƒmL ‚^ƒZ †E‚[‚S ‚K‚V[. ‚^…aa[.");
 NextEvent();
 end
 end,
 [127]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"b†a ˆ|hLY? ƒnˆEŠiƒP ƒ]S †Eƒ~‚jƒd Š]‚C‚b ‚kƒmƒv …f‚b …A‚_hLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, C‚_^ ƒ[ b†ahLY? `‚EX ƒuD ‚aKLM. b†a ‚i‚n‚b „VƒS „sZD ‚aKLM.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, b†a^ I‡H ˆ|S X‚C‚b ‰cJaN OLM. C‚_a‚C ‚k‚b „KG ƒW‚Kf G„BMƒd ‹bLM.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"b†aƒP ‚Cƒg ‹n‚C^ Œ@aƒG‚b aƒv, ƒ[…xfQ‚b ƒNƒP‚f‚b ƒuG ‚aKLM.");
 end
 if JY.Tid==76 then--³Â¹¬
talk(76,"‚G‚P, ‚^ƒZ ƒOu‚h D‡z‚K‚V[.");
 end
 if JY.Tid==80 then--ÕÅÁÉ
talk(80,"‚G‚P, Šoƒb †CS ‚K‚V[.");
 end
 if JY.Tid==5 then--ÂÀ²¼
talk(5,"‚G‚P, Šoƒb †CS ‚K‚V[.",
 1,"„a†ym. ƒO…m mOf ŠcI‚b ƒuS ‡mˆya†ym.",
 5,"n, ƒdŠOm. Gu Šoƒb †CS ƒRS „{ƒb Œ{„gm. ƒW‚K^ vvfQ ‚J‚p…HS „UD ƒOu^ g]‚h ˆj ‡Vf ƒ[‚_^ ƒW‚Kf S…eŒ_S q „O„k‚C. ƒ[…eƒd ƒsA GƒuD j…BG‚wƒ`. aa!",
 3,"I‡H ‰umuŠm?");
 MovePerson(3,1,1);
 MovePerson(3,2,3);
 MovePerson(3,0,0);
talk(5,"ƒa‚P!",
 3,"ƒnˆEŠi{ j…BG „OML I‡H ‰umuŠm. ƒOu^ ƒW‚K‚h …Vƒb ƒuG „p ‡VG‚fD ˆYM‚b QŠm. b†a, ‡iƒa t‚^‚h ^u…x.");
 MovePerson(2,1,0);
 MovePerson(2,2,3);
 MovePerson(2,2,1);
talk(2,"ƒa‚P, ƒ[„V‚[‚S‚f.",
 3,"ˆ|u‚C …X‡I‚V[, eƒO ˆEŠi. …f @†ZS ‚aŒi…E WLM.",
 2,"ƒa‚P, ‰q…f ƒv^ „O†E‚f.");
 MovePerson(3,6,1);
 DecPerson(3);
 MovePerson(2,2,0);
 MovePerson(2,2,2);
 MovePerson(2,1,1);
 MovePerson(2,0,3);
talk(1,"†w‚oa[. nƒO^ ‚Cƒg ‚pB „OS ŠFGL ‹UŠ|„Q …X‚V[. mO„S ^‚V[.",
 5,"ƒ[†{ ˆ|Š[‚_„S ‰b mO„S ^†ym.",
 76,"ƒdŠOKLM.");
 MovePerson(5,7,1);
 DecPerson(5);
 MovePerson( 76,4,1,
 80,4,1);
 DecPerson(76);
 DrawSMap();
talk(2,"ƒ[‚_‚b ƒaU^ n†m^?")
 MovePerson(2,1,0);
 MovePerson(2,2,3);
 MovePerson(2,9,1);
 MovePerson(2,0,3);
 MovePerson(80,0,2);
talk(80,"eƒO, I‡H …IG[?",
 2,"†q„befƒW ‰jƒOŠB ƒ[‚_ƒP ‚ZKS n„L ƒG„Fa[. ƒW„S ƒLG„kƒmƒv ƒ[ ‰jˆl†Df „d‚DPm. ‡q…h ƒ[‰S…l †|†}o ƒ[‚_^ ‚SŠS b†a‚h ‚i‚j‚b^?",
 80,"‚rFG ƒ[u U…e‰tS ŠFG[. ‡mƒv o‚W ‚KjS Fo GC ‹]G ƒU†N q‚b ‚a‚b ˆF, ƒ[‚_D „a ƒuG[.",
 2,"‡mƒv ‚KjfQ ‰bƒb …X‚MG „OMA ‚Z‚hY. b†afQ ƒ[‹@ …X‚MG „OMƒd ƒs‚b^?",
 80,"ƒv„SƒW‚b b†a‚h ‚SŠSX Du^ ‚am. ‚Cƒgƒb GƒuG ˆz…mG[.",
 2,"ƒ[ŠQMA ƒvD „l X ˆ|G ‚a‚wƒ`.");
 MovePerson(80,3,1);
 DecPerson(80);
 DrawSMap();
 DrawMulitStrBox("¡¡Guab b†a‚b mOf ‚K‰QPM. ƒ[…eƒv G …m…nG {…B ŒRƒtSY.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [128]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒW‚K";
 JY.Base["D‚wC"]=6;
 AddPerson(1,25,9,1);
 AddPerson(2,14,9,3);
 AddPerson(3,10,11,3);
 AddPerson(65,25,15,2);
 AddPerson(82,21,17,2);
 SetSceneID(86,5);
 DrawStrBoxCenter("ƒW‚K ƒP‚r‰R");
 --<ÑĞ¾¿½ñºóµÄ¶Ô²ß£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [129]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, …f‚b b†a‚h ˆ[‚C ˆfa†yKLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…Y‚_ ‚lƒPX q ‚aKLM. ‚SŠS ƒ[‹@ …x‚h ƒW‚Kf ‚[‡ILY?");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"b†a‚b d †on„q‚CY‚C ‹G …xhLM. ƒNƒP‚fƒd‚b ‚aKLM.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"[, ‚K‚J. ‡YwG ŠXKLM.");
 AddPerson(64,5,19,0);
 DrawSMap();
 MovePerson(64,4,0);
 NextEvent();
 end
 end,
 [130]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‡YwG I‡H …I„S ŠXSY?");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…Y‚_ ‚lƒPX q ‚aKLM. ƒnˆEŠi, ‚SŠS ƒ[‹@ …x‚h ƒW‚Kf ƒRG‡ILY.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‡YwG ŠXƒmL ƒ[ƒP ƒP†TS ƒR‚S ‹b‚VM.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"ƒO…m ‡YwƒP ƒP†TS ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ‡o‚r^ ŠXKLM. ‚SŠSXYZ?",
 2,"‡o‚r‚fL I‡H …I…IYZ? ƒnˆEŠi, ƒO…m ‚oƒm„S ‚Z‚V‚CZ.",
 1,"‚oƒm„S …w‚V‚CZ.",
 64,"k.");
 MovePerson(64,3,3);
 MovePerson(64,2,1);
 MovePerson(64,0,2);
 AddPerson(365,5,19,0);
 DrawSMap();
 MovePerson(365,5,0);
 NextEvent();
 end
 end,
 [131]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, ‡o‚rƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…Y‚_ ‚lƒPX q ‚aKLM.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, ‡o‚rƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"‚K‚J, ƒO…m ‡o‚rƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"ƒv‚b ƒJƒKƒmL ‰q…f ‡o‚rƒP ˆ|S ƒR‚S ‹b‚VM.");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(365,"ƒ[‚_^ ‚G‚Pj^? ƒv‚b vFfƒW ƒsˆZ ‡o‚rZ.",
 1,"k.",
 365,"‚UdƒP vƒWZ. ‚}…gƒP ƒQƒHS ‰S‰ra‚f ‚XaŠVm. …HƒR†y‚b^?",
 1,"k, …HƒR†yKLM.",
 365,"ƒ[†{ ƒv‚b M‡M …IG „O‚S G„V ƒA…e^†ym.");
 MovePerson(365,6,1);
 DecPerson(365);
 NextEvent();
 end
 end,
 [132]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi ƒ]‚_„S a‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒQƒH ‚i‚n…E …ZdD n‚`LM. ƒnˆEŠi, FaŠVƒmA ‚SƒW …b‚~a‚V‚CZ.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"…fŠs‚b ‚Z‚[ ‰p …b‚BhLM. „@Šy ƒLS ƒq†yKLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‡q…h ‚UdŠ_ƒW ‚SŠS a„s ‚Cƒg ƒQƒH ‰S‰rS ‚XaŠVSYZ?");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, G vƒWf I‡H ‰V…YG „O‚b ƒuƒb n†tYZ?",
 1,"n…X vvƒP ƒ]…I ƒuG[. ‚Cƒg ‚Ud‚b vvƒP ‚P†q n†G „T‚VL ‚rNC vvƒP ‚XG‚f ƒsn…E†y‚C. ‡mƒv vƒW‚h ‚S†r q‚b ‚am.",
 65,"ƒ[ŠQ‚TZ. …b‚~ ƒe‚Pf ƒR‚S^‚V‚CZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<½ø¾ü»´ÄÏ£¬ÌÖ·¥Ô¬Êõ£®>
 NextEvent();
 end
 end,
 [133]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒQƒH ‚i‚n…E …ZdD n‚`LM. ƒnˆEŠi, FaŠVƒmA ‚SƒW …b‚~a‚V‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"…b‚~aƒG„S FaŠVMA ‚i‚h q‹wfZ.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"…b‚~S ƒe‚PPKLM.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"…fŠs‚b ‚Z‚[ ‰p …b‚BhLM. „@Šy ƒLS ƒq†yKLM.");
 end
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
talk(2,"‚~ƒ}{ ƒaq‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(13,"d1ƒa ‚}…g ‚B„e","1. ƒL ‚B†U",30,0,-1);
 SelectTerm(1,{
 0,14,5,1,0,-1,0,
 -1,15,4,1,0,-1,0,
 -1,15,6,1,0,-1,0,
 -1,13,6,1,0,-1,0,
 -1,13,4,1,0,-1,0,
 -1,16,5,1,0,-1,0,
 -1,12,5,1,0,-1,0,
 -1,12,3,1,0,-1,0,
 -1,14,3,1,0,-1,0,
 });
 DrawSMap();
talk(2,"…b‚~a†yKLM.");
 JY.Smap={};
 SetSceneID(0,3);
talk(3,"ŠoM, ƒQƒHG „O‚b ‚}…gƒm„S g‚TGM. ‰OG †Z‹T†Eu‚b‚T.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [134]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚}…g";
 JY.Base["D‚wC"]=0;
 AddPerson(12,29,7,1);
 AddPerson(43,14,9,3);
 AddPerson(27,12,10,3);
 AddPerson(71,10,11,3);
 AddPerson(70,25,15,2);
 AddPerson(102,23,16,2);
 AddPerson(72,21,17,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("‚}…g ƒP‚r‰R");
 DrawMulitStrBox("¡¡‚Ud^ ƒQƒH ‰S‰rS ‚Xo …hf‚b YVG „O„kM. ƒQƒHG ƒ~ƒ~„S ‚Ud‚h WPƒG „U…ZGM. …_†D‚h ‡Yf †pƒb ƒQƒHƒb d‚n‚h …xWa†B ‚}…gfƒW ‚r„Qƒ~…e‡S `ˆdS †uuƒd „O„kM.");
talk(70,"‚G‚P‚TG G†w ŠPƒR‚S…oLM. ‚K‚J, ‚SŠSXYZ?",
 12,"‚G‚P ƒ[ Œi‡pG^ ƒ_ ~‰S‚h „|ƒsML †~ƒm„S „N…xa‚wƒv. ƒQ‡h, Šoƒb „T‚uG „O†sŠm?");
talk(43,"„OKLM.",
 12,"[, I‡JGŠm? ‚SƒW ˆ|a‚f.",
 43,"k. ‚Cƒg b†a^ ‚G‚PƒP ‚P†q‚h …Hn mOf ‚K‰QB „OƒmL, b†a‚h ‚^…c„} ‚G‚PƒP †c…C‚h „QQ a‚b ƒuhLM.",
 12,"I‡JG? b†a‚h ‚^…cŒIMƒd? ‡mƒv b†a^ ƒ[u ˆl„LG†y†sŠm? ‚G‚PƒP ƒNƒo‚h ‚Cƒd „O‚C ‚k†sŠm?",
 43,"‡mƒv ŠU„V EƒDaA b†a‚b …A…w‚V ˆl„L…I ƒuhLM.");
talk(70,"ƒ[ŠQ‚C. ‚l…aG ƒ[‰S…l nY‚SD †cƒNo …xGL.",
 12,"ŠoM, ‚SƒW ‡YS ˆ`‚f. Œa‚V ‚r…x‚h ƒsƒ_ ƒWƒNS ‚Ba‚f.",
 43,"k.");
 NextEvent();
 end,
 [135]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="mO";
 JY.Base["D‚wC"]=7;
 AddPerson(5,25,17,2);
 AddPerson(76,22,10,1);
 AddPerson(75,20,9,1);
 AddPerson(73,18,8,1);
 AddPerson(80,11,16,0);
 AddPerson(81,9,15,0);
 AddPerson(74,7,14,0);
 SetSceneID(54,11);
 DrawStrBoxCenter("mO ƒP‚r‰R");
talk(74,"ƒQƒHƒP ƒWƒNf‚b Œy‚f ƒL‹u „Om?",
 5,"ƒ[ŠQ‚T.");
 DrawMulitStrBox("¡º„v†G oŠt ˆN‚^f ‚Cƒv‚C ‚kŠB ‚G‚P^ ‡LqD ‚Z‚jƒd ƒ_ ~‚C‚h „|ƒsƒd „Om. ƒ[‚_‚b G‚h ‚[ƒd ƒs‚C ‚kS ƒuG[. …XˆmŠW ƒ[ DƒLƒP ‡YfƒW ƒW‚K‚h „C‹qn „N…xo …xfQ d ‚Su„Z‚MS ZƒOŠP ‚K‚V[. …Co k„S ƒs†Ca†ym.*¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡ƒQƒH¡»");
talk(75,"G‹@ ƒWƒNS ƒsƒ_‚b ‚@ ƒsL ƒQƒHG ‹jƒv M†Po ‚Z†oG[.",
 80,"ƒWƒNƒP ˆ|„e^ †~ƒm„S [„Va‚TZ. G ‚Cƒ@f G‚j…eƒWD I‡H †E…wŠKj‚C.",
 76,"‡mƒv ‚K‚J, G …Iƒb ƒN‚eŠW ŠInuŒs…E WLM.",
 5,"I‡JGŠm? ‚SŠS ˆY …IGŠm?");
talk(76,"‚Cƒg ƒW‚K^ ‚P‚S „OKLM. G ŒoS …@ ƒW‚K‚h Šf„hƒd ƒ[‡EfƒW Fk‚h ƒG‚jŒs…E WLM.",
 5,"‡mƒv ‚G‚P^ ƒOu‚h †E‚[‚S ‚K„k‚b…h ƒ[uoMA¡­¡­",
 76,"‚Cƒgƒb ‚qƒohLM. ‚K‚J, ‚sa‚h …Vƒm‚Vƒ`A M‚V‚aS ƒG‚}hLM.",
 5,"„a†yM. ‚^‚_‚h ‚Zn‚f. ƒW‚K„S …yM.");
talk(80,"‡mƒv ‚G‚P‚b ƒOufQ ƒbjhLM. G‚b †cƒNG n‚`LY?");
talk(76,"ƒ[†{ ‚K‚J„l…e ƒw` ‚G‚PƒP ‚yˆOƒm„S ‚Cƒ_‚f‚b ˆ|G[?");
talk(75,"ŒRm. ‚K‚J{ ‰HŠ_ ‚sa‚h D‚ZW‚VM.",
 80,"¡­¡­",
 5,"„l ˆ|X ƒu ‚aM. ‚B‚T Œa‚V ƒW‚K„S g_a‚f.");
talk(81,"¡­¡­ƒaU, ƒ[‚_ …X‚Mƒb n[. ‡mƒv ‚qƒoGL ‚S‹W q ‚am.");
talk(80,"‚qƒo‚f¡­¡­");
 NextEvent();
 end,
 [136]=function()
 SelectEnemy({
 69,2,20,4,0,18,8,0,0,-1,0,
 66,17,20,4,0,15,2,0,0,-1,0,
 71,4,19,4,0,14,1,0,0,-1,0,
 256,15,20,4,0,11,1,0,0,-1,0,
 257,6,21,4,0,11,1,0,0,-1,0,
 292,9,20,4,0,11,7,0,0,-1,0,
 293,4,21,4,0,11,7,0,0,-1,0,
 274,18,19,4,0,11,4,0,0,-1,0,
 275,16,19,4,0,10,4,0,0,-1,0,
 276,3,18,4,0,11,4,0,0,-1,0,
 328,1,21,4,0,11,13,0,0,-1,0,
 336,7,19,4,0,11,15,0,0,-1,0,
 
 75,11,1,1,1,18,5,0,0,-1,1,
 79,11,2,1,1,17,24,0,0,-1,1,
 72,11,3,1,1,14,14,0,0,-1,1,
 73,12,1,1,1,14,1,0,0,-1,1,
 74,10,2,1,1,14,4,0,0,-1,1,
 294,9,0,1,1,11,7,0,0,-1,1,
 295,11,0,1,1,10,7,0,0,-1,1,
 296,13,0,1,1,11,7,0,0,-1,1,
 337,13,2,1,1,11,15,0,0,-1,1,
 258,9,1,1,1,10,1,0,0,-1,1,
 310,14,1,1,1,11,10,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [137]=function()
 PlayBGM(11);
talk(70,"…M, ƒOu ‚K‚JŠ_ƒW ‚SŠS ‚G‚P ‚i‚n ƒN_ ‰OŠB Œi‡pGfQ †nƒNb[S ‡ia]. ƒ_ ‹MƒT‚h ƒsb ‚K…X.",
 2,"ƒQƒHƒb ˆjFa‚C ‚kƒb ‚Z†ohLM. I‡H ƒHq‚h ‚^„u‚C v†da‡I‚V[.");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [138]=function()
 if (not GetFlag(1011)) and War.Turn==6 then
 PlayBGM(11);
talk(65,"‚K‚J, „Nƒg ƒW‚KfƒW †Pƒs^ ŠXKLM. ƒW‚K^ G†w b†afQ ‡F‚Y‡iPM WLM.",
 3,"I‡JG? ‰ct „Gƒb ŒN. b†a G …G…I ŒNG ƒbƒp‚h ƒQq„S ‹yML. †@ŠH „oƒW„Q ‚k†yM. ƒnˆEŠi, d^ b†a‚h „Q†yKLM. …A…w‚V …fŒNS ƒq†yKLM.",
 2,"ˆEŠi, b†a‚TG ŠXKLM.");
 WarShowArmy(75);
 WarShowArmy(79);
 WarShowArmy(72);
 WarShowArmy(73);
 WarShowArmy(74);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(337);
 WarShowArmy(258);
 WarShowArmy(310);
 WarModifyAI(69,4,8,19);
 WarModifyAI(71,4,13,19);
 WarModifyAI(257,4,12,20);
 WarModifyAI(292,4,10,18);
 WarModifyAI(293,4,10,20);
 WarModifyAI(328,4,10,19);
 WarModifyAI(336,4,14,17);
 WarModifyAI(276,4,12,18);
 DrawStrBoxCenter("b†a‚TG ƒv…@ŠgM.");
talk(76,"G ‰jˆlG ‚K‚JƒP …I`S …pƒOoM. dƒaƒRƒb ‚G‚PfQ ‡T‚J‚pS ^a‚f.",
 80,"¡­¡­",
 70,"ŠoM, G ‰jˆlƒb …A…w‚V GŒIM.",
 2,"ƒnˆEŠi, ‚e{‚^ƒLG‚f ‰j…[ q ‚aKLM. ‚Cƒgƒb ƒA…eƒS q‹wfZ.",
 64,"ƒO…m ‡m†gƒm„S ^ vvfQ ˆuS ƒP…aa‚V‚CZ.",
 83,"‡m†gƒm„S ^‚b †r„S ƒE‚CA ƒLD ‹Kn[‚C ˆfWLM. ƒW‡k‹J ƒ{…^„S ^‚V‚CZ.");
 War.WarTarget="1. ƒL ‚B†U*2. ‚G‚P^ ƒW‡k ƒ{…^ DˆG";
 WarShowTarget(false);
 PlayBGM(10);
 SetFlag(1011,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P^ ƒG‚YG Gˆa‚b ƒQƒH‚TS I‹xŠjM.");
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £´£°£°S ƒYƒC.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if (not GetFlag(151)) and WarCheckArea(0,10,3,13,9) then
talk(1,"…y‡rG ˆ|o ƒ{…^^ GƒuGŠ@M. ‰b ‹f†y‚wƒv. „}ƒO ƒEˆkƒvŠXM.");
 WarModifyAI(69,3,0);
 WarModifyAI(66,3,0);
 WarModifyAI(71,3,0);
 WarModifyAI(256,3,0);
 WarModifyAI(257,3,0);
 WarModifyAI(292,3,0);
 WarModifyAI(293,3,0);
 WarModifyAI(274,3,0);
 WarModifyAI(275,3,0);
 WarModifyAI(276,3,0);
 WarModifyAI(328,3,0);
 WarModifyAI(336,3,0);
 WarModifyAI(75,3,0);
 WarModifyAI(79,3,0);
 WarModifyAI(72,3,0);
 WarModifyAI(73,3,0);
 WarModifyAI(74,3,0);
 WarModifyAI(294,3,0);
 WarModifyAI(295,3,0);
 WarModifyAI(296,3,0);
 WarModifyAI(337,3,0);
 WarModifyAI(258,3,0);
 WarModifyAI(310,3,0);
 SetFlag(151,1);
 end
 if WarCheckLocation(0,2,0) then
 PlayBGM(4);
 DrawMulitStrBox("¡¡‚G‚P‚TG ‚BƒaS Œz‚SŠgM.");
bonus_moneyexp_4()
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(22,2,68,70); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÃÍ»ğÊé ¸ÄÎª ²ÙÊŞÖ¸ÄÏÊé --SFC´Ë´¦»ñµÃ Íä¹­£¿
 if WarMeet(2,80) then
 WarAction(1,2,80);
talk(2,"ƒaU, b†a^ G‰S…l ‚P‚Ao ŒQS P‚b…hD ƒ[‚h ‚i‚j†yM‚b ƒuj^?",
 80,"b…e ˆ| „sZ ‚am. eƒO, ‹R‚P‚V[!",
 2,"a‚b q ‚a‚wƒv. ƒqƒGf‚b nY‡S …xGƒv¡­¡­");
talk(2,"…yM, ƒaU.",
 80,"…v!");
 WarAction(6,2,80);
 if fight(2,80)==1 then
talk(2,"{…B ƒaU„S‚T. ‡mƒv G q‚h ‰XX q „O†y‚b^?");
 WarAction(8,2,80);
talk(80,"[, {…B eƒOZ. [ƒXƒb ƒ_^ ƒFm.",
 2,"ƒaU, ˆGnƒvƒ`‚b^? Q ŒU†E‚f!");
talk(80,"ƒA…e‚qM. eƒO‡z‚b ‰jƒOƒd Š]‚C ‚km.");
 WarAction(16,80);
 WarLvUp(GetWarID(2));
 else
talk(2,"{…B ƒaU„S‚T. ‚SŠSab a„s ‚G‚P‚h ‚i‚j‚b^.");
 WarAction(16,2);
 WarLvUp(GetWarID(80));
talk(80,"ƒA…e‚qM. ‚G‚P‚T{‚b ‰jƒOƒd Š]‚C ‚km.");
 WarAction(16,80);
 end
 end
 end,
 [139]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(3,"b†a G ‰ct „Gƒb ŒN. ƒnˆEŠi, eƒO ˆEŠi. …f‚b ‚Cƒg ‡iƒa ƒW‚K„S ‰Bn^ b†a‚h ƒq†yKLM.",
 2,"‚o ˆYM. ‚Cƒg ƒW‚K„S ‰Bn^A ‰j…[ q‹wf ‚a‚b…h, ƒLƒb Fk‚f ƒOu„SƒW‚b ‡iB‰M q ‚aM. ˆEŠi, ‚Cƒgƒb ‡m†gƒm„S ^ vvfQ ƒP…aa‚V‚CZ.",
 1,"ƒ[Šl q‹wf ‚a†y‚wƒv. ‡m†gƒm„S ^…x.");
 NextEvent();
 end,
 [140]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(9,25,9,1);
 AddPerson(69,14,9,3);
 AddPerson(78,12,10,3);
 AddPerson(19,10,11,3);
 AddPerson(62,25,15,2);
 AddPerson(17,23,16,2);
 AddPerson(1,3,20,0);
 SetSceneID(85,5);
 DrawStrBoxCenter("‡m†g ƒP‚r‰R");
talk(9,"[, ‚G‚P. G‚W‰` ƒdƒ|‚h ^„k‚wƒ`.");
 MovePerson(1,7,0);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë²Ü²Ù¾Í½ñºóÎÊÌâ½øĞĞÑĞ¾¿£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [141]=function()
 if JY.Tid==69 then--Ü÷ª
talk(69,"G‚W‰` ƒdƒ|‚h ^„km.");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"ƒW‚K‚h ŒOƒb ƒ[ †dF, ƒ_ ŠU n[.");
 end
 if JY.Tid==78 then--³ÌêÅ
talk(78,"Œ[‚V ƒdˆY ‰jˆlG„k†y‚wƒ`.");
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"b†afQ †cƒN‡iP‚wƒ`. b†a‚b †~ƒm„S ƒNƒP‚fƒd‚b ‚a‚b …xZ.");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"b†aD ƒQƒHD ‡NŠW bƒGY‚C‚b ŠPƒR‚S[‚C ˆfa[.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"Š^…x aL b†afQ †cƒN‡iB ƒW‚KY‚C ŒO„kM„l‚T. ƒ[ ‹n‚C^ †~ƒm„S Œ@a[. eƒO‚b ‚SŠS „C„km?",
 1,"eƒO‡z ƒa‚P‚b ƒ{ ‹wfƒW ƒGMuƒd „OKLM. ‚Cƒgƒb ŠcƒA ‡Ev„y ‚a‚S ‚^ˆa…eˆlS I‹{ˆ`ƒd ƒP…aa…e ŠXƒmL ‚^ƒZ ƒs†ja ‚K‡I‚V[.",
 9,"…`ƒ` ˆ|ƒd ‡m†gf ŠcI‚V[. ‰q †rf MƒR ‚C‡RS ƒhGL ‚SƒW e…f„S ^ ‹]‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚ¹ÙÛ¡ĞİÏ¢£®>
 NextEvent();
 end
 end,
 [142]=function()
 if JY.Tid==69 then--Ü÷ª
talk(69,"G‚W‰` ƒdƒ|‚h ^„km.");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"ƒW‚K‚h ŒOƒb ƒ[ †dF, ƒ_ ŠU n[.");
 end
 if JY.Tid==78 then--³ÌêÅ
talk(78,"e…f‚b ƒ{‚of „OKLM.");
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"b†afQ †cƒN‡iP‚wƒ`. b†a‚b †~ƒm„S ƒNƒP‚fƒd‚b ‚a‚b …xZ.");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"b†aD ƒQƒHD ‡NŠW bƒGY‚C‚b ŠPƒR‚S[‚C ˆfa[.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚r†o …X‚Vƒd ‚SƒW e…ff ^ ‹]‚V[.",
 1,"ƒdŠOKLM.");
 MovePerson(1,12,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [143]=function()
 SetSceneID(85,11);
talk(78,"‚K‚J, ‚G‚P‚b †]s‚_‚vS ‚C†m ~†]hLM.",
 69,"G ƒG‚}f ‚G‚P‚h ‚aŒi‚b „KG Šo†yKLM.",
 19,"eƒO‡z ƒa‚PD b†af ‡D‚C‚C ‚kƒmL ‹`ƒS @†ZG Š} q „OKLM.",
 9,"¡­¡­",
 62,"nL ŒjLM. …f‚b ƒ[ `‚Ef …A‚_WLM. ‚Cƒg ‚G‚P‚h …GjMA ƒoCG ‚K‚JS ‚SŠS ˆ|a†yKLY?",
 17,"ŒRKLM. ˆuS ƒP…aa…e †[ …x‚h …GGA ‚K‚JƒP ‚nˆof ˆCG †hLM.",
 9,"Šoƒb ˆ|G[. †Jƒ@f ‹no ‚G‚PfQ ƒb‡VS ƒqƒr‚b „KG ‹o†ym.",
 69,"‡mƒv ‚K‚J, ‚G‚P^ ‚n…Uo jƒARƒb ŒG‚O‚aKLM. ƒG‚}^ [A ‚aŒi‚V‚b „KG ŠoKLM.",
 9,"„aƒd „OM. ‚G‚P^ ^ƒa ‚[ƒ`„Ea‚b …x‚b ƒU„S ƒvM.");
 NextEvent();
 end,
 --µÚÒ»ÕÂ¡¡ÌÖ·¥ÂÀ²¼Ö®Õ½
 [144]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d1ƒa¡¡b†a ‰S‰r‚B";
 DrawStrBoxCenter("d1ƒa¡¡b†a ‰S‰r‚B");
 LoadPic(8,1);
 DrawMulitStrBox("¡¡‚G‚P‚b vv n†G ˆuS ƒP…aa†B sƒG‚h D‚ZPM. ƒ[…eƒv G ‹n‚C‚b ‚G‚P‡z b†a^ ‡Y‹QS ƒuS ‚[ƒ`„Eo vv^ ƒVˆM „T‚vƒP †@{…I ŠFG„kM.");
 LoadPic(8,2);
 JY.Smap={};
 SetSceneID(0);
 DrawMulitStrBox("¡¡ƒLG b†a aƒv„V …g…x vv‚b „^Q ƒGŒ~a†B ‰bƒU„S b†a ‰S‰rf ƒvŒUM. vv‡z ‚G‚PƒP …BW‚Tƒb mO‚h ‰Hˆyaƒd, ƒ[‡EfƒW M‚M J‚BS bƒPaƒG ‚VJPM.");
 NextEvent();
 end,
 [145]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒW‚K";
 JY.Base["D‚wC"]=6;
 AddPerson(5,25,9,1);
 AddPerson(76,14,9,3);
 AddPerson(75,10,11,3);
 AddPerson(73,4,14,3);
 AddPerson(80,25,15,2);
 AddPerson(81,21,17,2);
 AddPerson(74,15,20,2);
 SetSceneID(86,11);
 DrawStrBoxCenter("ƒW‚K ƒP‚r‰R");
 DrawMulitStrBox("¡¡mO‚h ŒOƒb b†a‚b ƒW‚KfƒW ‹IƒSƒP ‚_‚uS bƒPPM.");
talk(5,"‡m, vvŠF nL‚f ‚G‚PY‚C ŠPƒR‚S[‚b‚wƒv. g†X, ‚SŠSaA Šo†ym?");
 MovePerson(76,1,0);
 MovePerson(76,2,3);
 MovePerson(76,0,0);
talk(76,"‚Cƒg ‚~…X‚h F‡]a‚Vƒd, ƒO…m ƒW‚K„S G‚S‚C‚b †rƒcf ‚~ƒ}S †c„Qa‡I‚V[.",
 5,"‚M, a‚w‡z Eƒ{f †c„Qa‚d ˆ|G[?",
 76,"ƒ[ŠQKLM. ƒ[‡Ef ‚~ƒ}S ‚[‚S ‚V…yS ‰r‚S…E WLM. ‡Oo ƒW‚K‚b q‚Pf ŠG‚C ‚kƒmL „vgS ƒW‚K …g‹J a‚P„S ‹ZƒGŒs…E WLM.",
 5,"a‚P‚f?",
 76,"ƒ[ŠQKLM. a‚P‚b ‡GƒO †Tƒdaƒd ‚r„Nf ‰Kƒb B…x^ „OKLM. ƒ[‡EfƒW vv‚Tf ŠGƒW…E WLM.",
 5,"„a†ym. a‚P„S ‹ZƒG†ym. ƒ[uƒd ƒaU! ƒd„A!",
 80,"k!",
 73,"k!");
 MovePerson( 80,3,1,
 73,2,0);
 MovePerson( 80,2,2,
 73,2,3);
 MovePerson( 80,2,0,
 73,2,0);
talk(5,"ƒaU, ƒ[‚_‚b a‚w„S ^ g†XƒP ‚C‚V‚_„S vv‚TƒP g‚pS ‡fn‚f.",
 80,"‚XS …HƒR†yKLM!",
 5,"ƒd„Aƒb Eƒ{ƒm„S ^‚f. ŠoM, ^‚f.",
 73,"‚XS …HƒR†yKLM!");
 MovePerson( 80,10,1,
 73,10,1);
 DecPerson(80);
 DecPerson(73);
talk(76,"‚K‚J, ‚SƒW a‚P„S ^‚V‚CZ.",
 5,"ƒ[w Šom„V …fƒRfQ ƒQ‚Tƒb ‚SŠS ƒsƒ_†ym?",
 76,"ƒQ‚TG‚fLZ. …fƒRfQ ƒQ‚Tƒb „sZ ‚aKLM.",
 5,"I‡JG? ƒ[w ‚o „C[. …fƒRƒP ‚~ƒ}„Vƒm„S‚b vv‚TS ‡fS q ‚am.",
 76,"ƒU„S ƒ[ŠQKLM. ab …fƒRƒb „qu‚b ˆ|hLM. …fƒRG ‰r‚S ‚K‚b ‚V…yf a‚P„S ‹Z„}…E WLM. ƒ[…e‚C ‚kƒdƒW‚b vv‚TƒP …c‚pS cS q ‚aKLM.",
 5,"a, a‚C„V¡­¡­",
 76,"‚K‚J, …gƒP ‚nf ƒWƒ`A ‚r‚r„S‡S Ff ‡GbƒW‚b ‚o ŒjLM. …fƒRƒP „vƒ] ‡Oo ‚K‚JS ‚nB „@ˆ`‚b ƒuG nL†yKLY?",
 5,"‡m? ƒ[ŠQ‚T!",
 81,"¡­¡­(‚SŠS ˆY …Ij^. ƒ_^ ‚SeM ‚CƒgŠy …f‹@ …x‚h ‚i„g†M ˆ|j^.)");
 NextEvent();
 end,
 [146]=function()
 JY.Smap={};
 SetSceneID(0,11);
talk(80,"ƒ[†{ ƒOu‚b a‚wfƒW vv‚TS ‡f†ym.",
 73,"ƒOu‚b Eƒ{fƒW ‚K‚JS ‚C‰J†ym. ‚o†da‚V[, …A…w‚V ƒQ‚TG ƒi ƒuG[.",
 5,"ƒ[†{ ƒOu‚b a‚P„S ^…x.");
 NextEvent();
 end,
 [147]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="mO";
 JY.Base["D‚wC"]=7;
 AddPerson(9,25,17,2);
 AddPerson(69,22,10,1);
 AddPerson(62,11,16,0);
 AddPerson(1,17,13,3);
 AddPerson(2,14,11,3);
 AddPerson(3,12,12,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("mO ƒP‚r‰R");
talk(9,"[, ‚G‚P. mO‚h „C‹qƒtƒmL ƒO…m caa[.",
 1,"ƒdŠOKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë²Ü²ÙµÈ¾ÍÏÂÒ»²½×÷Õ½ÑĞ¾¿£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [148]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"vvŠ_ ˆ|Š[a‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"G‡EG †~ƒm„S ƒ[ufKLM. …Xƒlƒ_ †Lf ‰Bn†[ ‡KWLM.");
 end
 if JY.Tid==69 then--Ü÷ª
talk(69,"†~ƒm„S ŠAg ‰jˆlG„km. …Xƒlƒ_ mO‚h „C‹qƒt‚wƒ`.");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"G†~f ƒGƒo‚h Œ{n b†a‚h ‚ag‚VM.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, G‚W ƒW‚K ‚J‚pƒb †rS ƒv†u‚S g‚Taƒd…x a[.",
 1,"a‚w‡z Eƒ{ ‚[ ‡y†G„S ˆ|hLM.",
 9,"ƒ[ŠQm. ƒLG a‚w‡z Eƒ{f gS „Qƒd ƒGMu‚b ‚Z†oG[. ‚G‚P, ƒ[‚_fQ ƒQ‚TS aƒv ŒEb ‚K†ym. a‚w‚h ˆjMA „A„mS, Eƒ{S ˆjMA ‡j^‚h …hƒ`^‚V[. ‚[ ‚r†vfQ‚b …I…e ‚[„km.");
 NextEvent();
 end
 end,
 [149]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚S†s †rS …nX‚C‚b ƒnˆEŠiG Fa‡I‚V[. M„V a‚w‚h ‚C‰J‚b …x‚b ƒaUhLM. ƒaU‚b k‚r„S‡S jƒAG n‚`LM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚S†s †rGˆe ŠoKLM. ƒnˆEŠi, ‚SƒW ƒW‚K‚h „C‹qƒm‚V‚CZ.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"a‚w„S g‚Ta‚VA „A„mS, Eƒ{ƒm„S ^‚VA ‡j^‚h …hƒ`^‚V‚CZ.");
 end
 if JY.Tid==69 then--Ü÷ª
 if talkYesNo( 69,"a‚w‚h „Q‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(69,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(11,"d1ƒa a‚wII ‚B„e","1. ƒaU ‚p…D",30,0,79);
 SelectTerm(1,{
 0,2,9,4,0,-1,0,
 -1,3,9,4,0,-1,0,
 -1,1,10,4,0,-1,0,
 -1,3,10,4,0,-1,0,
 -1,1,9,4,0,-1,0,
 -1,4,9,4,0,-1,0,
 -1,4,10,4,0,-1,0,
 68,25,17,3,0,-1,0,
 18,24,17,3,0,-1,0,
 19,25,16,3,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
talk(69,"…b‚~a†yKLM.",
 9,"ƒ[†{ ƒOu‚b Eƒ{ƒm„S g‚Ta†ym. ‚G‚P, a‚w ‹Jƒb ƒ[‚_fQ ŠEƒG[.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(150); --goto 150
 end
 end
 if JY.Tid==62 then--¹ù¼Î
 if talkYesNo( 62,"Eƒ{S „Q‚V†yKLY?") then
 RemindSave();
talk(62,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(12,"d1ƒa Eƒ{II ‚B„e","1. ƒd„A ‚p…D",30,0,72);
 SelectTerm(1,{
 0,1,3,4,0,-1,0,
 -1,1,1,4,0,-1,0,
 -1,2,0,4,0,-1,0,
 -1,2,2,4,0,-1,0,
 -1,0,2,4,0,-1,0,
 -1,0,3,4,0,-1,0,
 -1,0,4,4,0,-1,0,
 61,6,15,4,0,-1,0,
 16,6,14,4,0,-1,0,
 17,7,15,4,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
talk(62,"…b‚~a†yKLM.",
 9,"ƒ[†{ ƒOu‚b a‚w„S g‚Ta†ym. ‚G‚P, Eƒ{ ‹Jƒb ƒ[‚_fQ ŠEƒG[.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(154); --goto 154
 end
 end
 end,
 [150]=function()
 SelectEnemy({
 79,16,10,3,2,17,24,0,0,-1,0,
 256,16,12,4,4,14,1,24,16,-1,0,
 257,13,10,3,4,12,1,7,9,-1,0,
 258,15,10,3,2,10,1,0,0,-1,0,
 274,17,11,4,4,14,4,24,16,-1,0,
 275,13,9,3,4,12,4,7,9,-1,0,
 276,15,9,3,2,10,4,0,0,-1,0,
 292,15,12,4,4,10,7,24,16,-1,0,
 293,14,10,3,4,10,7,7,9,-1,0,
 328,15,11,3,2,12,13,0,0,-1,0,
 259,0,8,4,1,14,1,0,0,-1,1,
 277,0,9,4,1,10,4,0,0,-1,1,
 294,0,10,4,1,10,7,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [151]=function()
 PlayBGM(11);
talk(69,"ŠoM, †o‹JfƒW ƒLS ‰G‚JoM.",
 1,"Gd ‰jˆl„V ƒGM„u ŠFhLM.",
 2,"ƒLƒaƒb ƒaUj ‡KWLM. ƒaU‚b ‡tƒP‚h n‚b IƒaG‚CZ.",
 80,"b†a‚h ‚i‡M ƒuG ŠUˆfG„kŠB ‡Ka[.");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [152]=function()
 if (not GetFlag(1012)) and War.Turn==2 then
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 SetFlag(1012,1);
 end
 if (not GetFlag(1013)) and War.Turn==5 then
talk(2,"ƒnˆEŠi, ‡D‚h v†da‡I‚V[.");
 WarShowArmy(259);
 WarShowArmy(277);
 WarShowArmy(294);
 DrawStrBoxCenter("ƒLƒP ƒGK ‚^‚_^ ƒv…@ŠgM.");
talk(1,"ƒaU^ ƒGK ‚^‚_‚h ƒsƒ_ ƒOu ‡D‚h ƒYu‚b‚T.",
 2,"†~ƒm„S „o‚~ƒP ‡^‚h n‚b …x„SM.",
 80,"ŠoM, ‚B‚T ‡T‚J‚p.");
 WarModifyAI(328,1);
 WarModifyAI(276,1);
 WarModifyAI(258,1);
 WarModifyAI(79,1);
 SetFlag(1013,1);
 end
 if WarMeet(2,80) then
 WarAction(1,2,80);
talk(2,"ŠGƒb„Kƒb ƒaU„S‚T. b†a‚h ‚i‚j‚b ƒuG …C‚}ƒ~Šp‚C ‚kƒb^?",
 80,"‡m!",
 2,"b†a‚b †cƒNS ƒa‚q‹n†{ bƒG‚b …v‡iG‚C †@ŠH ~†]G nL[. ƒ[‚_^ ‚Z‚h u ‚aS ‹|…h.",
 80,"‡m!");
talk(80,"‚B‚T …C…D!");
 WarAction(16,80);
 WarGetExp();
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒaU^ ƒA…eƒvƒd ‚G‚P‡z vvƒP …BW‚TG b†a‚TS I‹xŠjM.");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°S ƒYƒC.");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒaU^ ƒA…eƒvƒd ‚G‚P‡z vvƒP …BW‚TG b†a‚TS I‹xŠjM.");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°S ƒYƒC.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if (not GetFlag(72)) and WarCheckLocation(-1,0,7) then
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £´£°£°S ƒYƒC.");
 SetFlag(72,1);
 end
 end,
 [153]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(69,"‚G‚PŠi, „Nƒg ‚K‚JŠ_ƒW ‚r…x‚h ƒsƒ_ŠVKLM. G†w ƒW‚K‚h ‡F‚YaŠVM aL ƒOuD ƒW‚K„S ^‚V‚CZ.");
 NextEvent(158); --goto 158
 end,
 [154]=function()
 SelectEnemy({
 72,17,15,3,0,17,14,0,0,-1,0,
 256,13,12,3,4,14,1,8,11,-1,0,
 257,16,13,3,4,13,1,15,9,-1,0,
 258,17,13,3,0,12,1,0,0,-1,0,
 274,16,8,3,4,14,4,14,4,-1,0,
 275,15,14,3,4,12,4,16,9,-1,0,
 292,15,9,3,4,10,7,14,4,-1,0,
 293,15,10,3,4,10,7,14,4,-1,0,
 294,14,13,3,4,9,7,8,11,-1,0,
 295,14,14,3,4,10,7,12,12,-1,0,
 296,16,14,3,0,9,7,0,0,-1,0,
 310,15,8,3,4,14,10,14,4,-1,0,
 311,13,13,3,4,12,10,8,11,-1,0,
 328,15,15,3,0,12,13,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [155]=function()
 PlayBGM(11);
talk(73,"‹U‹Va‚wƒv. G‚_„S‚b G†r q ‚aM. b†a ƒa‚Tƒb n„LD †CG ‚a†sŠm? ƒv„l…e …Gƒm‚f‚b ƒuG„S‚T.",
 2,"Eƒ{ƒb ƒd„AG ‚C‰mM WLM. vv‚Tf ‡D‹nˆkƒW‚b ‚o ŒjLM.");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [156]=function()
 if WarMeet(3,73) then
 WarAction(1,3,73);
talk(3,"ƒ{‚oƒP ‚_ƒaƒb ƒv[H‚f. ƒW‚KƒP „QŒTS ‰s†yM.",
 73,"ƒa‚P, ƒ_^ H‡z …I‚_…I„S „}ƒ^†yM.");
 WarAction(6,3,73);
talk(73,"ˆ|fƒW ƒ_ƒ` …G‚S‚f.",
 3,"b†a‡z o„w…{G ˆY …x‚fA †u‚wˆe ƒ_ †gf i‚S ‚K…X.");
 WarAction(5,3,73);
 if fight(3,73)==1 then
talk(73,"‚o „C†yM. D…fŠW ‡iB‰M q ‚aM.");
 WarLvUp(GetWarID(3));
talk(73,"dƒGŠJ! …C…Da‚f!");
 WarAction(16,73);
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒd„AG ƒA…eƒvƒd ‚G‚P‡z vvƒP …BW‚TG tuPM.");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°S ƒYƒC.");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
talk(3,"‚o „C†yM. D…fŠW ‡iB‰M q ‚aM.");
 WarAction(17,3);
 WarLvUp(GetWarID(73));
 end
 end
 if (not GetFlag(1014)) and War.Turn==2 then
 WarModifyAI(256,1);
 WarModifyAI(294,1);
 WarModifyAI(311,1);
 WarModifyAI(274,4,8,4);
 WarModifyAI(292,4,8,4);
 WarModifyAI(293,4,8,4);
 WarModifyAI(310,4,8,4);
 SetFlag(1014,1);
 end
 if (not GetFlag(1015)) and War.Turn==3 then
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(310,1);
 SetFlag(1015,1);
 end
 WarLocationItem(12,16,96,73); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÂíîø ¸ÄÎª³¤êª
 if JY.Status==GAME_WARWIN then
talk(73,"‹U‹Va‚wƒv! …C…Da‚f!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒd„AG ƒA…eƒvƒd ‚G‚P‡z vvƒP …BW‚TG tuPM.");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°S ƒYƒC.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [157]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(62,"‚G‚PŠi, ‚K‚JŠ_ƒW ‚r…x‚h ƒsƒ_ŠVKLM. G†w ƒW‚K‚h ‡F‚YaŠVM aL ƒW‚K„S ^‚V‚CZ.");
 NextEvent(158); --goto 158
 end,
 [158]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒW‚K";
 JY.Base["D‚wC"]=6;
 AddPerson(9,25,9,1);
 AddPerson(69,14,9,3);
 AddPerson(17,10,11,3);
 AddPerson(18,4,14,3);
 AddPerson(62,25,15,2);
 AddPerson(19,21,17,2);
 AddPerson(20,15,20,2);
 SetSceneID(86,11);
 DrawStrBoxCenter("ƒW‚K ƒP‚r‰R");
 AddPerson(1,5,19,0);
 AddPerson(2,3,18,0);
 AddPerson(3,7,20,0);
 MovePerson( 1,5,0,
 2,3,0,
 3,3,0);
talk(9,"‚G‚P, {…B ‚X…d‡m‚BG[. qƒdPm. b†a‚b a‚P„S ˆGn‚q ‚Z†oG[.",
 1,"a‚P‚f?",
 9,"ƒ[‚_D „a†y‚C„V ƒ[ ƒ{ƒb †Tƒdab ‚Cƒg …Xˆmo ‚Jƒ{‚uG ‚a‚S ŒA„QZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë²Ü²Ù¾ÍÏÂÒ»²½ÑĞ¾¿£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [159]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, ‰q…f vvŠ_ ƒsƒda‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, †J‚V ƒW‚K^ ŠoKLM. †Lf ‰Bn†[ ƒu „GKLM.");
 end
 if JY.Tid==69 then--Ü÷ª
talk(69,"a‚Pƒ{ƒb ‚G‚qŠW „QƒG ‚SŠqKLM. b†a^ ƒ[u„S ˆGnŠgMA ‚J‚vƒb „l„m ‚Sƒ`„E†LLM.");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"b†a^ a‚P„S ˆGnŠgKLM. a…XƒhA …f †_†q‚h ‹QS ŒPP‚b…hZ.");
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"Gd …gƒb ƒuƒb a‚PŠFGL b†aD ‹[ƒaG‚CZ.");
 end
 if JY.Tid==18 then--ÏÄºîÔ¨
talk(18,"b†aD ‰b ‹[ƒaƒS ƒuGL ƒoCD ‹D v„oB‚C†y‚CZ.");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"b†a^ a‚Pƒ{f „OƒmL ‚J‚vG ‹D ‚SŠq†yKLM.");
 end
 if JY.Tid==20 then--²Üºé
talk(20,"a‚P‚h Z„]ƒjM BD b†a aƒv„Vƒm„SD C‚_aƒG jkLM. …A…w‚V v†daŒs…E WLM.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, ‚SŠS ŠP…E a†ym? [, †[ …x‚b †u‚wZ?");
 AddPerson(66,5,19,0);
 MovePerson( 66,7,0)
talk(66,"‚G‚PŠi, …f‚b g…}G‚f a†B ƒW‚KƒP ‚X…Z^ ‚r†vhLM.",
 1,"‚Bf ƒW‚K ƒP‚r‰RfƒW m ƒLG „Om.",
 66,"b†a^ ƒW‚K‚h ‡F‚Yo ‡D„S‚b ƒ[fQ nŠWƒd „O„kKLM. Gd b†a‚TƒP ‚rFS n„bƒd…x WLM.",
 9,"ƒ[ŠQ‚C, g…}G ƒ[‚_fQ X ˆ|G „OM a[. ^ƒW ƒR‚S ƒs‚V[.");
 NextEvent();
 end
 end,
 [160]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, g…}ƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"n, ƒnˆEŠi. †J‚V ƒW‚K^ ŠoKLM. ƒd†Yf ‰Bn†[ ƒu „GKLM.");
 end
 if JY.Tid==69 then--Ü÷ª
talk(69,"‚G‚PŠi, g…}ƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"b†a^ a‚Pƒ{ƒm„S ˆGnŠgKLM. a…XƒhA …f †_†q‚h ‹QS ŒPP‚CZ.");
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"Gd a‚P„V …gƒtƒmL b†aD ‰b ‹[ƒahLM.");
 end
 if JY.Tid==18 then--ÏÄºîÔ¨
talk(18,"b†aD ‰b ‹[ƒaGL ƒoCG ‹D v„oB‚C†y‚CZ.");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"b†a^ a‚Pf „OƒmL ‚J‚vG ‹D ‚SŠq†yKLM.");
 end
 if JY.Tid==20 then--²Üºé
talk(20,"a‚P‚h Z„]ƒjM BD b†a aƒv„Vƒm„SD C‚_aƒG jkLM.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, g…}ƒP ˆ|S ƒR‚S ƒs‚V[.");
 end
 if JY.Tid==66 then--³ÂµÇ
talk(66,"Nƒb …fD „v†G b†aƒP ‚^aŠbKLM. EƒD„V ŠUˆYMA …Cƒ{, ‚n…{, ‡p‡q ƒo ‚r†vG ‰BnƒWƒW ƒ{S ƒU†R‚CD ‚Z‹{LM.");
talk(66,"ƒ[ ƒo ‚r†vƒb a‚Pƒ{ ‹wS ‚C‰Jƒd „OS ƒuhLM. ƒ[ƒRS ƒOu „Kƒm„S ‰BƒjMA a‚Pƒ{ƒb ‡@Q Z„]„u q „OKLM.");
 NextEvent();
 end
 end,
 [161]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, …A…w‚V ƒ[ ƒo ‚r†vS EƒDB…E WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"EƒDƒb d meG nLL ƒnˆEŠiŠ_ƒW ŠEn ‚K‡I‚V[.");
 end
 if JY.Tid==69 then--Ü÷ª
talk(69,"…Iu^ „OKLM. g…}ƒP ˆ|ƒb ‡GƒO ‚eZWLM.");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"b†a^ a‚P„S ˆGnŠgKLM. a…XƒhA …f †_†q‚h ‹QS ŒPP‚CZ.");
 end
 if JY.Tid==66 then--³ÂµÇ
talk(66,"‚G‚P, …A…w‚V …Cƒ{, ‚n…{, ‡p‡qS ‰BnƒWQ a‚V[. ƒ{‚JoMA G ‰jˆlƒb GŒI ƒuGƒv MŠK‚am.");
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"Gd a‚P„V …gƒtƒmL b†aD ‰b ‹[ƒahLM.");
 end
 if JY.Tid==18 then--ÏÄºîÔ¨
talk(18,"b†aD ‰b ‹[ƒaƒS ƒuGL G ƒoCD ‹D v„oB‚C†y‚CZ.");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"b†a^ a‚Pf „OƒmL ‚Jƒ{G ‹D ‚Sƒ`„E‚C†yKLM.");
 end
 if JY.Tid==20 then--²Üºé
talk(20,"a‚P‚h Z„]ƒjM BD b†a aƒv„Vƒm„SD C‚_aƒG jkLM.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, ƒ[ „T‚u‚_„S W‚VM. Gd a‚P‚h „Q„C ƒ[‚_‚b …Cƒ{, ‚n…{, ‡p‡q ƒo ‚r†vS EƒDa‚V[. ƒ{‚JoMA a‚P‚b ‰b ‰HˆyŠ} ƒuG[. ‚G‚P, ƒ[‚_„V ˆ[†ym.");
 NextEvent();
 -- ÏÔÊ¾ÈÎÎñÄ¿±ê:<³öÕ÷ÂÀ²¼×¤ÊØµÄÏÂÚü£®>
 end
 end,
 [162]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"EƒDƒb d meG nLL ƒnˆEŠiŠ_ƒW qƒdB ‚K‡I‚V[.");
 end
 if JY.Tid==69 then--Ü÷ª
talk(69,"g…}ƒP ˆ|ƒb ‡GƒO ‚eZWLM.");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"a‚Pƒ{ƒb ‚r„Nf B…x^ „O‚S ‚C‰JƒG ‡@ƒd „QƒG ‚SŠqKLM. ƒ{…ZƒP D†K„W„V ƒ_uA q‡cB†LLM.");
 end
 if JY.Tid==66 then--³ÂµÇ
talk(66,"‚G‚P, …A…w‚V …Cƒ{, ‚n…{, ‡p‡qS EƒDB ‚K‚V[. ƒ{‚JoMA G ‰jˆlƒb GŒI ƒuGƒv MŠK‚am.");
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"Gd a‚P„V …gƒtƒmL b†aD ‰b ‹[ƒahLM.");
 end
 if JY.Tid==18 then--ÏÄºîÔ¨
talk(18,"b†aD ‰b ‹[ƒaƒS ƒuGL G ƒoCD ‹D v„oB‚C†y‚CZ.");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"b†a^ a‚Pf „OƒmL ‚Jƒ{G ‹D ‚Sƒ`„E‚C†yKLM.");
 end
 if JY.Tid==20 then--²Üºé
talk(20,"a‚P‚h Z„]ƒjM BD b†a aƒv„Vƒm„SD C‚_aƒG jkLM.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, ƒ[‚_„V ˆ[†ym.");
 end
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"…b‚~a‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(2,"‚_‚AS ‹s‹t‚f!");
 WarIni();
 DefineWarMap(14,"d1ƒa a‚P ‚B„e","1. D†K„W ƒ_uƒG",45,0,4);
 SelectTerm(1,{
 0,30,22,3,0,-1,0,
 -1,29,23,3,0,-1,0,
 -1,31,21,3,0,-1,0,
 -1,28,22,3,0,-1,0,
 -1,29,21,3,0,-1,0,
 -1,30,20,3,0,-1,0,
 -1,31,19,3,0,-1,0,
 8,0,16,4,0,-1,1,
 61,5,14,4,0,-1,1,
 68,3,13,4,0,-1,1,
 18,3,16,4,0,-1,1,
 19,4,15,4,0,-1,1,
 16,1,15,4,0,-1,1,
 17,2,14,4,0,-1,1,
 });
 DrawSMap();
talk(2,"…b‚~a†yKLM!",
 9,"ŠoM, „U^ ŠXM. b†a‚h ‚aoM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [163]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(9,"‚G‚P, ƒ[‚_„V ˆ[†ym. ƒOu‚b ‚^‚_‚h ‡G‚D‚V‰a ‚[†ym. EƒDf ƒ{‚JaA ‰HŠ_ a‚P„S ŠPƒR‚S†h‚VM.");
 NextEvent();
 end,
 [164]=function()
 ModifyForce(5,5);
 SelectEnemy({
 4,11,0,1,2,21,8,0,0,-1,0,
 75,12,1,4,2,18,5,0,0,-1,0,
 80,9,14,4,2,18,8,0,0,-1,0,
 73,17,15,4,2,17,2,0,0,-1,0,
 74,15,20,4,2,17,5,0,0,-1,0,
 79,15,2,4,0,18,24,0,0,-1,0,
 72,14,0,3,0,18,14,0,0,-1,0,
 84,5,6,4,0,17,15,0,0,-1,0,
 85,10,1,4,2,16,19,0,0,-1,0,
 256,19,14,4,0,14,1,0,0,-1,0,
 257,6,5,4,0,14,1,0,0,-1,0,
 258,12,3,3,0,14,1,0,0,-1,0,
 259,15,3,3,0,13,1,0,0,-1,0,
 260,14,3,3,0,13,1,0,0,-1,0,
 292,17,14,4,0,14,7,0,0,-1,0,
 293,10,14,4,0,14,7,0,0,-1,0,
 294,18,5,3,0,14,7,0,0,-1,0,
 274,20,13,4,0,14,4,0,0,-1,0,
 275,18,16,4,0,14,4,0,0,-1,0,
 276,11,1,4,0,13,4,0,0,-1,0,
 277,19,6,3,0,13,4,0,0,-1,0,
 310,18,15,4,0,14,10,0,0,-1,0,
 311,18,20,4,0,14,10,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [165]=function()
 PlayBGM(11);
talk(5,"…M, vv‡z ‚G‚P^ nIu ŠPD G ƒ{ƒb b‚BŠW ˆK‡rƒ{GM.",
 2,"ƒnˆEŠi, GuaA ‚S‹c†yKLY? g…}ƒP ˆ|‚_„S …Cƒ{, ‚n…{, ‡p‡qS EƒDB b†a‚h …}‚CQ aƒd D†K„W‚h ƒ_uQ a‚b ƒuhLM.",
 81,"b†a‚b ƒOu‚h ƒ{ ‹wfƒW ‰jƒOQ aƒd …xƒG‚b ƒ{‚of ŒG‚Sˆ{‹u „OƒmL, ‚~‚rƒRD ˆ|S Š^‚C ‚k‚b‚wƒv. ‚SŠSB…E aƒv.",
 74,"bƒGƒW ‚CA b†afQ ƒcG ŠU„u ƒuGM. ƒ[ƒuD ƒ[ŠQ‚C„V¡­¡­",
 75,"b†a ƒa‚Tƒb d ‹n…xfQ‚b ŠUaAƒW ƒOu‚b ‚r†v l†PD a‚C ‚k‚bM. ‚i‚h „Vo …x^ nLM.");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [166]=function()
 if (not GetFlag(1016)) and War.Turn==30 then
 PlayBGM(9);
 SetWarMap(13,12,1,4);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=61;
 WarDelay(12);
 DrawStrBoxCenter("D†K„W^ ƒ_ƒ`ƒFM.");
talk(1,"I‡H …IGŠm? D†K„W^ ƒ_ƒ`g ƒuGŠm?");
 WarShowArmy(8);
 WarShowArmy(61);
 WarShowArmy(68);
 WarShowArmy(16);
 WarShowArmy(17);
 WarShowArmy(18);
 WarShowArmy(19);
 DrawStrBoxCenter("vv‚TƒP ƒQ‚~G ƒv…@ŠgM.");
talk(69,"‚K‚J, D†K„W^ ƒ_ƒ`g ‡KWLM.",
 9,"‡m, ‚G‚PD ƒn ƒ[qƒb ˆf „C‚b ‚Z†oG[. G FD G…y„TD „P „{ ‚Z‚jML. †wu g…}S ƒ{‚of ƒRbƒsˆZ ƒuG ŒRƒtm. ŠoM, …A…w‚V b†a‚h ‚r„S‹Q†yM.");
 WarModifyAI(84,1);
 WarModifyAI(257,1);
 WarModifyAI(294,1);
 WarModifyAI(277,1);
 WarModifyAI(79,4,19,4);
 WarModifyAI(258,4,9,5);
 WarModifyAI(259,4,18,4);
 WarModifyAI(260,4,8,4);
 War.WarTarget="1. b†a ‚p†V";
 WarShowTarget(false);
 PlayBGM(16);
 SetFlag(1016,1)
 NextEvent();
 end
 if WarMeet(1,81) then
 WarAction(1,1,81);
talk(81,"‚G‚PŠm? ŠoM, ƒ_^ C‚_a…X.",
 1,"…Cƒ{, ƒ_ ˆ|S ƒRƒm‚V[.");
talk(1,"…Cƒ{, ‚Cƒg b†a‚b ƒd„t„C„kƒd ‚T†dD ‹e‚SƒFm. ƒ[‚_ ‡Oo …X‡Z^‚C nL[.",
 81,"‰umu …X‚V[. ƒv‚b ‚[ …X‚MS ƒB‚C ‚km.",
 1,"…xƒNS …{G‚C …X‚V[. ‰u„CG ƒc…~S „qu‚b ƒuG ˆG†hm?",
 81,"‡m¡­¡­",
 1,"ƒ[ƒuS iŒC‚S ƒs‚C ˆfoMA bƒGƒW ƒ~ƒ~„S‚h r‚SD Šom.",
 81,"ƒv‚b n„L G ƒoCf GŠKS …gƒG‚C ˆfPM. bƒGƒW …GS q‚b ‚aM.",
 1,"ƒ[ŠQMA a‚PƒP D†K„W‚h ƒ_ƒ` ‚K‚C ‚k†ym?",
 81,"„a†ym. ƒ[‚_^ D†K„W ‹If G‚jA ƒ_ƒ` ‚K†ym. ‚Cƒg ‰Bn^ …^‚P‚h a†ym.");
 WarAction(16,81);
 WarLvUp(GetWarID(1));
 SetFlag(17,1)
 end
 if WarMeet(1,74) then
 WarAction(1,1,74);
talk(1,"‚n…{, b†aƒP ‡Sƒb MPm. ‚^‹T‚a‚b ‰jˆlƒb ƒ[„V‚[‚V[.",
 74,"ƒOu‚b [†G‚B‚^ƒh b†a ƒa‚TS ‚i„gm. ‡mƒv b†a‚b d ‹n…x„V `‚EX ŠF ƒOu ‚^aƒRfQ‚b ƒbƒp‚fƒd‚b ƒq‹E‚C ‚kƒtm. Gd ƒ[‚_fQ ƒP…aa†ym. ‰b D†K„W‚h ƒ_u…e ^†ym.");
 WarAction(16,74);
 WarLvUp(GetWarID(1));
 SetFlag(18,1)
 end
 if WarMeet(1,75) then
 WarAction(1,1,75);
talk(75,"¡­¡­‚G‚P, ƒOu^ ‚SŠS b‚| …f‹@ …x‚h ‚i„g†M ˆ|G[.",
 1,"‡p‡q, ‚Cƒg ZˆGnD ‹z‚C ‚km.",
 75,"ƒ[ŠQ‚T, Šom. ‚Cƒg ƒ[‚_ƒRfQ ƒP…aa†ym. ‚G‚P, ‰bƒU„S ƒ{ƒm„S ‰Bn^ D†K„W‚h ƒ_u†ym.");
 WarAction(16,75);
 WarLvUp(GetWarID(1));
 SetFlag(19,1)
 end
 if (not GetFlag(1017)) and War.Turn==3 then
talk(5,"ƒ{ ‹w ‚~‚rƒRG ‚SŠS …fu su ƒuGŠm. ‚Jƒo‚h „l ‚IaQ a‚f …I…e‚f.",
 81,"‚SƒZ^ s„]M‚b ˆ|j^?",
 74,"ƒ[ŠQKLM. ‚B„N ‚^‚_f ƒLS „Q‚f G‚j‡I‚V[.",
 75,"ƒLƒb ‚Iaƒd vv‚Tƒb „V…AƒP ‚|ƒo„S ‚_ƒG ‚eGM. b†a ƒa‚TD „a ‹|…h ‚SŠS …f‹@ ˆ|S a‚b^. ƒOu„l…e …Gƒm‚f‚b ƒuG n†m^.");
 WarModifyAI(256,1);
 WarModifyAI(292,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(310,1);
 SetFlag(1017,1)
 end
 if WarCheckLocation(0,12,12) then
 if GetFlag(17) and GetFlag(18) and GetFlag(19) then
 PlayBGM(9);
 SetWarMap(13,12,1,4);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=61;
 WarDelay(12);
 DrawStrBoxCenter("D†K„W^ ƒ_ƒ`ƒFM.");
talk(81,"‚G‚PŠi, ‚SƒW ƒ{ƒm„S …w‚V[.",
 1,"…Cƒ{ƒP ƒcmuM. ƒ[^ D†K„W‚h ƒ_ƒ` ‚K„k‚wƒv.",
 5,"I‡JG? …Cƒ{, ‚n…{, ‡p‡q ƒo ŒNG ƒv‚h †cƒNaƒd D†K„W‚h ƒ_„~Mƒd? ƒPu‚fƒd‚b ‚a‚b ƒuƒR, †@ŠH „oƒW„Q ‚k†yM.");
 WarShowArmy(8);
 WarShowArmy(61);
 WarShowArmy(68);
 WarShowArmy(16);
 WarShowArmy(17);
 WarShowArmy(18);
 WarShowArmy(19);
 DrawStrBoxCenter("vv‚TƒP ƒQ‚TG ƒv…@ŠgM.");
talk(69,"‚K‚J, D†K„W^ ƒ_ƒ`g ‡KWLM.",
 9,"‚G‚PƒP G…y„T^ „wo ‚Z†oG[. ŠoM, ‚B‚T ‰B‚p. …A…w‚V b†a‚h ‚r„S‹Qn‚f.");
 WarModifyAI(84,1);
 WarModifyAI(257,1);
 WarModifyAI(294,1);
 WarModifyAI(277,1);
 WarModifyAI(79,4,19,4);
 WarModifyAI(258,4,9,5);
 WarModifyAI(259,4,18,4);
 WarModifyAI(260,4,8,4);
 War.WarTarget="1. b†a ‚p†V";
 WarShowTarget(false);
 PlayBGM(16);
 NextEvent();
 else
 --talk( 81,"ÊÇÂğ£¿ÕæµÄ²»·ÅµõÇÅ¾ÍÃ»°ì·¨½ø³ÇÂğ£¿ÒªÏë°ì·¨·ÅÏÂµõÇÅ£®");
 end
 end
 if JY.Status==GAME_WARWIN then
 DrawMulitStrBox("¡¡G ‚B„eƒP tu‚b ƒZ„qƒ[„ohLM. ‰g„Sƒ[wf ‚e†M‡FG „O‚S, bƒGY‚C g‚]„C„kMA []hLM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(168);
 end
 end,
 [167]=function()
 if WarMeet(2,80) then
 WarAction(1,2,80);
talk(2,"ƒaU, ‚SƒW ‡g‚Da‚V[. b†aƒP ‡Sƒb MPƒd ƒ[‚_‚b G†w X „VA Pm.",
 80,"¡­¡­Gd b…e ˆ| „sZ ‚am. ‹FS …w‚V[.");
 WarAction(6,2,80);
talk(2,"ŠP‚f!",
 80,"ŠP‚f!");
 if fight(2,80)==1 then
talk(80,"‡m„F, {…B eƒO„SM. ‚_†Ma‚wƒv. …v!");
 WarAction(8,2,80);
talk(2,"ƒc…~S „hS C‹n‚b nLM. G ‚rƒ_‚h ƒqƒGf‚b n‡P‚wƒv.");
 WarAction(17,80);
 WarLvUp(GetWarID(2));
 else
talk(2,"‡m„F, {…B ƒaU„SM. ‚_†Ma‚wƒv. …v!");
 WarAction(17,2);
 WarLvUp(GetWarID(80));
 end
 end
 WarLocationItem(0,6,8,74); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º³àÍÃÂí
 WarLocationItem(0,20,15,164); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º·½Ìì»­êª
 if JY.Status==GAME_WARWIN then
talk(5,"‡m, ‹[G„S‚wƒv.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡b†a^ ‚r„S‹QŠWƒd ‚G‚P‡z vvƒP …BW‚TG b†a‚TS ‚p†VPM.");
 GetMoney(5000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°£°S ƒYƒC!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [168]=function()
 SetSceneID(0,3);
talk(2,"a‚P„S ƒR‚S†h‚VM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ÏÂÚüµÄÒéÊÂÌü£®>
 NextEvent();
 end,
 [169]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="a‚P";
 JY.Base["D‚wC"]=9;
 AddPerson(9,25,17,2);
 AddPerson(69,11,16,0);
 AddPerson(62,9,15,0);
 AddPerson(1,22,10,1);
 AddPerson(2,20,9,1);
 AddPerson(3,18,8,1);
 AddPerson(5,14,12,3);
 --AddPerson(1,4,7,3);
 --AddPerson(1,29,11,1);
 SetSceneID(54,5);
 DrawStrBoxCenter("a‚P ƒP‚r‰R");
talk(9,"‚G‚P, ‚Cƒg b†a‚h ‚SŠS ‹n‡LX‚C Faƒ`ŠB †~G[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<¾ö¶¨¶ÔÂÀ²¼µÄ´¦ÖÃ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [170]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚lFX b‚C^ ‚aKLM. Œa‚V ‹nˆEaŒs…E WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚SƒW ƒcS „Q‚V‚CZ. nLA d^ ˆES †L‚]a†yKLM.");
 end
 if JY.Tid==69 then--Ü÷ª
talk(69,"b†a‚h †jƒ` ‚[A …C†IG ŒjLM.");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"‡mƒv b†a‚b C‡io jƒAG[. ƒ[…x aƒv „U…Zf ƒOu^ G‰S…l Œi‚h K„km.");
 end
 if JY.Tid==5 then--ÂÀ²¼
talk(5,"‚G‚P, ‚BƒafƒW‚fA ƒv‚b ‚C‚C ‚km. Iƒaƒm„SƒW ‚K‚JS DƒOA ‚sa‚h ƒwFX q „Om.");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, `‚EB ƒs‚V[. ƒ[‚h ‚SŠS ‹n‡LaA Šo†ym?");
 NextEvent();
 end
 end,
 [171]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚lFX b‚C^ ‚aKLM. Œa‚V ‹nˆEaŒs…E WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚SƒW ƒ[ ƒcS „Q‡I‚V[.");
 end
 if JY.Tid==69 then--Ü÷ª
talk(69,"b†a‚h †jƒ` ‚[A …C†IG ŒjLM.");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"b†a^ „o†_o ƒuƒb ‚rNGƒv ‚K‚JS ‚nBƒW‚fA †J‚V¡­¡­");
 end
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, ‚SŠSaA Šo†ym?");
 end
 if JY.Tid==5 then--ÂÀ²¼
 JY.Status=GAME_SMAP_AUTO;
talk(5,"‚G‚P, ƒOu^ ƒW‚KfƒW ‰HŠ_ ‚CˆZ …IS Šk„km? ‚^ƒZ ‚S‹cQˆe ƒ_ ƒc…~S †jƒ` ‚K‚V[!",
 9,"‚G‚P, ‚SŠSaA Šo†ym? ƒ[‚_ƒP `‚ES ƒRƒ`‚K‚V[.");
 local menu={
 {" b†a‚h „oƒWoM",nil,1},
 {"b†a‚h „oƒWa‚C ‚k‚bM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
 NextEvent(); --goto 172
 elseif r==2 then
 NextEvent(173); --goto 173
 end
 end
 end,
 [172]=function()
talk(1,"b†a^ †cƒNS …I|ƒb ƒuƒb ‚rNGƒv ƒ[ ‹n‚Cf‚b Œ@o AD „OKLM. QM^ G‹@ jƒAS ƒqƒGf‚b n‡PKLM.",
 5,"n! ŒRm! ƒU„S ƒ[ŠQm! ‚G‚P! ƒdŠOm! vv, ƒ_ ƒc…~S †jƒ` ‚K‚V[!",
 9,"‡m, ‚G‚P‚b ƒ[u ƒs‚b^. ƒv‚b M‚j[. G…x‚b ‚wdX q ‚am. ‰q…f †on„q‚C‚h …GGƒd ‚l…afQ ŒE„kM^ M‚V ‚l…aS †cƒNaƒd ƒ[…X…f ƒq„km. ƒv‚b ƒ[ ‡D‚h yƒd Š]‚C ‚km. b†a, ƒ[‚_‚b …Gƒb ƒc…~G[.",
 5,"‡dŠu, ƒv‚b …Gƒd Š]‚C ‚km!",
 3,"ƒnˆEŠi, G‚W‰` …fD vvƒP ƒ]f ‡Zƒ{WLM. b†a, ƒ_^ ˆES †L‚]B ‚K…X.");
 NextEvent(174); --goto 174
 end,
 [173]=function()
talk(1,"b†a‚b †cƒNS ‡@Q a‚b …xhLM. ‚l…aD †cƒNPƒmL, ‚Cƒg vvŠ_ƒW †E‚[ƒNƒR Šc‚C‚kn †cƒNX ƒuhLM.",
 9,"ƒ[†{ FPM. b†a‚h ‚rˆEf ‹noM. ˆn‚Sƒ_ ƒcS ŠP‚f.",
 5,"‡dŠu, ƒv‚b …Gƒd Š]‚C ‚km.",
 3,"…G‚MG ŠH‹Ij…hD …f ŒBG‚fL. ƒ_^ ˆES †L‚]a†yM.");
 NextEvent(174); --goto 174
 end,
 [174]=function()
 MovePerson( 3,1,2);
 MovePerson( 3,3,1);
 MovePerson( 3,3,3);
 MovePerson( 3,0,2);
talk(3,"GƒsQ, ƒa‚P. ƒ[„V‚[Q!");
 MovePerson( 3,9,2,
 5,9,2);
 DecPerson(3);
 DecPerson(5);
talk(9,"ŠoM! M‚M …x‚h …hƒ`[‚f.");
 AddPerson(80,-4,3,3);
 MovePerson( 80,9,3);
talk(9,"ƒaU, b†a ‚i‚n‚h ‚i‚j‚C ‚k†yMA ƒc…~ƒb †jƒ` ‚K†ym. ‚S‹cm? ‹Iƒm„S ƒv‚h ‚i‚f ‚C‚q ‡mƒAS ‹yn ƒs‚C ‚k†ym?",
 80,"…M, ƒ_ ‚C‚q ‡mƒAG‚d ƒ[‚_‚h G ‡Yƒm„S ƒq‚C ˆfo ƒuG[. Gd ƒ[uX q ‚aƒmL †jnD ƒ]G ‚am. ‚SƒW ƒv‚h ƒq‚V[.",
 9,"†u^ ƒ[‹@ ‰umu‚h ƒR‚S ‚K†y†sŠm.");
 MovePerson( 2,2,2);
 MovePerson( 2,3,1);
 MovePerson( 2,3,3);
talk(2,"‹FS z…c‚V[!",
 80,"eƒO¡­¡­",
 2,"G ‚r†vƒb ‡tƒP„BKLM. ‚Su„Zƒb ‚w„ZG „Oƒmƒv †~ƒm„S …VƒG ‚Sƒ`‡S jsGL, G eƒO^ ƒc…~S ‚@ƒd ƒs‰da†yKLM.",
 9,"ˆNG„km. ƒ_^ ƒ[ƒuS ‚Z‚j†ym? ƒaU, ƒ[‚_‚b …x‚GZ. …X‚M‚_„S ‚SƒZˆe ^‚V[.",
 80,"I‚S‚f aŠVm? ƒv‚h „oƒWaƒNMƒd? †~ƒm„S ƒn ƒ[qG‚V‚wƒ`! b†a‡z‚b¡­¡­ ƒ_^ ‚C‚qƒS ŠUˆfPm. vv, nL v‚J. ƒ[ Hƒ[…eˆlf ‡N‹YX ‚iŠKG[. ‚^ƒZ ‚gafƒW …IaQ B ‚K‚V[.",
 9,"ƒv‚h ‚i‚j†yM‚b ˆ|G[? ƒaU, ƒ[‚_ „Gƒb ‚^a‚h …V‚b ƒu ‡Oo ƒ_ ‚DG[.",
 80,"‡N‚ra[!");
 ModifyForce(80,9);
talk(9,"ƒ[†{ ‚G‚P, ‚Bƒa FuD ‹[ŠgƒmL ‡m†gƒm„S ‰Bn†h‚VM.",
 1,"ƒ[…e‚CZ.");
 NextEvent();
 end,
 [175]=function()
 JY.Smap={};
 SetSceneID(0);
talk(2,"ƒnˆEŠi, ƒ[†{ ‡m†gƒm„S ‰Bn^‚V‚CZ.");
 NextEvent();
 end,
 --µÚÒ»ÕÂ¡¡ĞìÖİ¹¥·ÀÕ½
 [176]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d1ƒa¡¡ƒW‚K ‚J„N‚B";
 DrawStrBoxCenter("d1ƒa¡¡ƒW‚K ‚J„N‚B");
 LoadPic(10,1);
 DrawMulitStrBox("¡¡b†a^ …G…x vv^ ŒMuŠB ‚IƒLƒb ‚r‚fƒFƒd, vv‚b vFS …X‚M‚_„S ‚KI‚jƒG ‚VJPM. ‚S†s ƒS vv‚b ‡qdfQ ‚rˆ}S ‡bP‚b…h, ‚rˆ}ƒhfƒW †s{‚aG ‡qdƒP ˆdS Šf„hn ‚rˆ}‡NS ŠG…TM.");
 DrawMulitStrBox("¡¡†eeƒb ‡qd^ ŠG‰o „{ „aƒtƒmƒv, vv‚b d ‹MƒTRS …w…eƒ_ƒ` ‡qdƒP ‡YfƒW ‚rˆ}‡NS Šf„hƒtM. G …I„S ‚Ud‚b …rAS ŒO„kƒd, ‡qd‚h †nƒNbŒI vvƒP ‚]‚lƒb ‡tƒNƒRƒP …A‡NS }M.");
 LoadPic(10,2);
 NextEvent();
 end,
 [177]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(1,21,10,1);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
 DrawStrBoxCenter("‡m†g ‚G‚P e…f");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë¹ØÓğµÈÌÖÂÛ½ñºóÖ®ÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [178]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"b†a^ …GƒmA ƒ{CS B†R …x^ ‚a‚S‹T „{ „aƒt†EƒX. vv^ ƒ{CS …fu ‚_a‚b ƒuS ‚SŠS †~ƒm].");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"nGƒd ƒnˆEŠi, †~ …I~D …I‚SƒvŠVKLM. ‚M, ƒnˆEŠi, †u^ †[ ‚Z†ohLM.");
 AddPerson(365,3,20,0);
 MovePerson(365,7,0);
talk(365,"‚G‚PŠi, N‹~a†yKLM.");
 NextEvent();
 end
 end,
 [179]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"vvŠ_ƒW ƒsˆZ ‚r…xj^? I‡H …IG[?");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚o ŒjLM, …f‚b n„L ‡dD ‚o @KLM. ƒnˆEŠi, nIƒuD Š^‚C …X‡I‚V[.");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(365,"‚G‚PŠi, vvŠ_ƒW ƒP‚r‰Rf „T‡ILM. ‚SƒW ƒP‚r‰Rƒm„S [‚VŒeLM.");
 JY.Status=GAME_SMAP_AUTO;
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ÒéÊÂÌü¼û²Ü²Ù£®>
 NextEvent();
 end
 end,
 [180]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(9,25,9,1);
 AddPerson(69,14,9,3);
 AddPerson(17,12,10,3);
 AddPerson(18,10,11,3);
 AddPerson(62,25,15,2);
 AddPerson(19,23,16,2);
 AddPerson(20,21,17,2);
 AddPerson(1,3,20,0);
 SetSceneID(85);
 DrawStrBoxCenter("‡m†g ƒP‚r‰R");
talk(9,"[, ‚G‚P. „T…{ ƒGMuƒd „O„km.");
 MovePerson(1,7,0);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë²Ü²ÙÌ¸»°£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [181]=function()
 if JY.Tid==69 then--Ü÷ª
talk(69,"‚G‚P, G‡M nƒlG[. ŠU ‹]„km?");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"d^ ^ƒW ˆ|a†yKLM.");
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"d^ ^ƒW ˆ|a‚CZ.");
 end
 if JY.Tid==18 then--ÏÄºîÔ¨
talk(18,"d^ ^ƒW ˆ|a‚CZ.");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"d^ ^ƒW ˆ|a‚CZ.");
 end
 if JY.Tid==20 then--²Üºé
talk(20,"d^ ^ƒW ˆ|a‚CZ.");
 end
 --[[
 if JY.Tid==69 then--Ü÷ª
talk(69,"ÇëÔçµã»ØÀ´£®");
 end
 if JY.Tid==62 then--¹ù¼Î
talk(62,"ÔÚÊ¥ÉÏÃæÇ°Òª×¢ÒâÀñ½Ú£®");
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"½ú¼ûÊ¥ÉÏÊÇÍ·Ò»´Î°É£¬Òª×¢ÒâÀñ½Ú£®");
 end
 if JY.Tid==18 then--ÏÄºîÔ¨
talk(18,"¿ì½ø¹¬µî°É£®");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"¿ì½ø¹¬µî°É£®");
 end
 if JY.Tid==20 then--²Üºé
talk(20,"¿ì½ø¹¬µî°É£®");
 end
 ]]--
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, G‡M nƒl‚^ƒh …d…e †w‚oa[. Nƒb [ƒX ƒ{CS Œr…e ‡y †~G[. b†a‡zƒP ‰jˆlfƒW ƒ[‚_^ „o†_ŠW ‰jfƒmL ƒ{CŠ_ ‚s†Eaƒd…x a[. ‰HŠ_ ^†ym?",
 1,"‡i…BŠW ^†yKLM.",
 9,"ƒ[†{ ‰bƒU„S †h‚VM. ƒ{CŠ_ƒW „TƒN †X‚Bƒm„S ^„C ƒ_^ ‰q…f ƒR‚S^ n„b†ym.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥¹¬µî¼ûÏ×µÛ£®>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [182]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(383,7,8,3);
 AddPerson(9,14,9,3);
 AddPerson(384,19,8,1);
 AddPerson(353,9,14,0);
 AddPerson(1,37,23,2);
 SetSceneID(84,8);
 DrawStrBoxCenter("‡m†g †X‚B");
 MovePerson(1,10,2);
talk(9,"ŠDa, G…x^ ƒU„S ‚G‚PG…oLM.",
 383,"[, ‚G‚P. ˆuS …Iƒm‰J‚f.");
talk(384,"‚G‚P, ƒv‚b ‚UdƒP ƒ_ƒN ‚ltG[. ‹n‚M ‹p†ym. ŠU ‚^…aa[.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [183]=function()
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, ‚SƒW ŠDa‚h Œr‚V[.");
 end
 if JY.Tid==384 then--¶­³Ğ
talk(384,"‚G‚P, ƒ_ …X‚M…{ƒm„S ƒX ƒ[‚_‚h „VƒvƒG‚h ƒU„gm.");
 end
 if JY.Tid==353 then--¹ÙÀô
talk(353,"ŠDa ‹IGL ‚_‹~‚h ƒiu‚V[.");
 end
 if JY.Tid==383 then--Ï×µÛ
talk(383,"[, ƒ[‚_^ ‚G‚Pj^. vv‡z ‰HŠ_ b†a‚h ‡RM ƒR„kƒY‚f. ƒdŠO‚wƒv. ¡­¡­ƒ[…eƒd ƒsL ƒ[‚_D ƒ{G ‚GƒTj^?",
 1,"k.",
 383,"‰cƒP ƒ{ƒb ‚GZ GŠKƒb ‰GG‚f. ƒ[‚_‡z ‰cG I‡H …BG „O‚b^? ƒ[‚_ƒP …mv‚b †u‚wj^?",
 1,"ƒNƒb ‚SŠcLŠ_ Š^ƒG„S …mv^ ‚Ud‚f a…oLM.",
 383,"I‚S‚f aŠb‚b^? ƒ[ƒuG ‚rNj^? Q „O†sŠm, „Rƒs‚h ^ˆk‡z †jaƒs‚f.");
 MovePerson(353,11,3);
 DecPerson(353);
 NextEvent();
 end
 end,
 [184]=function()
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P^ oN Tˆj…I „{G…E.");
 end
 if JY.Tid==384 then--¶­³Ğ
talk(384,"‚G‚P^ oN TˆjG‚fA ‚UdŠ_D ƒ@‚rZ, ƒv ‡Oo ƒGŒ}[.");
 end
 if JY.Tid==383 then--Ï×µÛ
talk(383,"‚G‚P^ ‰c{ „Gƒb TˆjG‚fA †~ƒm„S Šoƒb …IG„SM.");
 AddPerson(353,37,23,2);
 MovePerson(353,6,2);
talk(353,"„Nƒg †jaƒsL ‚G‚P‚b ŠDaƒP †f‚^ ‡gƒfG…oLM.",
 383,"ƒ[…eo^. ƒ[ŠQMA ‚G‚P, ƒ[‚_‚b ‰cƒP †f‚^„SM. ƒ[…eL ‰cG ƒ[‚_‚h ‚U†fG‚f ‚^‚j†yƒY‚f. ƒJƒKƒb^? ‚U†f.",
 1,"ƒNfQ‚b „l‚a‚b ~‚HG…oLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚ¹ÙÛ¡ĞİÏ¢£®>
 NextEvent();
 end
 end,
 [185]=function()
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, caa[. ‹Iƒm„S ŠDa‚h ‹pƒG^ o†@ q‡ca†y‚wƒ`.");
 end
 if JY.Tid==384 then--¶­³Ğ
talk(384,"‚G‚P, nL ‚G‚U†f. ‹Iƒm„S ƒ[‚_„V ˆ[†ym.");
 end
 if JY.Tid==353 then--¹ÙÀô
talk(353,"‚G‚U†fG‚f, †~ƒm„S Š^ƒG ŠoKLM.");
 end
 if JY.Tid==383 then--Ï×µÛ
talk(383,"G„V ƒA…e^D ŠoM. ‡f ‰jˆlS …X‡RƒmL †LfƒW A ‹]D…l a‚f.");
 MovePerson(1,10,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [186]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
talk(2,"ƒnˆEŠi, ‰Bn[ŠVKLY.");
 MovePerson(1,6,0);
talk(1,"„Nƒg ƒ{CS ‹pƒd ŠXM.",
 3,"[, ƒnˆEŠi. ca…w„tLM. I‡H ˆ|Š[ƒRG [‰tKLY?",
 1,"¡­¡­",
 2,"‚M, ƒnˆEŠi. ‚VTj ‡KWLM.");
 MovePerson(1,0,1);
 AddPerson(353,3,20,1);
 MovePerson(353,4,0);
talk(353,"‚G‚U†f, …f‚b ‚U†XfƒW ŠXKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥»Ê¹¬¼ûÏ×µÛ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [187]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, ‚U†XƒP ‚r…x^ ‡O ŠXKLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‡O ŠX‚TZ. ƒnˆEŠi, …f‚b „i‚_aƒG ˆHƒKKLM.");
 end
 if JY.Tid==353 then--¹ÙÀô
talk(353,"‚U†f, ƒ{CƒP ‡L‚^G‡ILM. M‚V o‚W hBB ‚K‡I‚V[.");
 MovePerson(1,8,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [188]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(383,7,8,3);
 AddPerson(353,9,14,0);
 AddPerson(354,19,8,1);
 AddPerson(1,37,23,2);
 SetSceneID(84,8);
 MovePerson(1,2,2);
talk(383,"[, ‚U†f. ‰cG „T…{ ƒGM„~ƒY‚f.");
 MovePerson(1,8,2);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [189]=function()
 if JY.Tid==353 then--¹ÙÀô
talk(353,"‚U†f, b…e „y‹~ ‚@‚Ma‚VQ ab †~ƒm„S qƒd^ ‡Aƒm‚V[.");
 end
 if JY.Tid==354 then--¹ÙÀô
talk(354,"ZŠr ƒ{CŠ_ƒW Œ[‚V ‚CŠP ƒsG‡ILM. IˆA^ ˆACƒb …IG „OƒmƒN ‡KWLM.");
 end
 if JY.Tid==383 then--Ï×µÛ
talk(383,"[, ‚U†f. …x‚K …d…e †w‚oa‚wƒv.",
 1,"‡i„Q ‚kKLM. ŠDaŠ_ƒW ‚^‚j‚VA ˆAdˆe [†yƒvGM. I‡H …IG‚V…oLY?",
 383,"‚M, ƒ[ƒuG¡­¡­ ƒvŠc‚C‚b ‚Z‚[ ƒA…e^‚f.");
 MovePerson( 353,11,3,
 354,11,3);
 DecPerson(353);
 DecPerson(354);
talk(1,"I‡H …IG[?",
 383,"¡­¡­‚U†f, ‰cƒb ƒ[‚_‚h ‰KG ˆ[ƒY‚f. ab G …_‚_‚h ƒ_uL †Lf ‰Bn^ …xƒoŠW †jaƒs‚f. ƒ[ …IŠFGM.",
 1,"¡­¡­ƒ{ƒbG ˆoˆpa…oLM. ƒNG ŠU …yqa†yƒvGM. ƒ[†{ ƒA…e^†yKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚ¹ÙÛ¡ĞİÏ¢£®>
 MovePerson(1,10,3);
 DecPerson(1);
talk(383,"‚U†f, Gd ƒ[‚_^ ‰cƒP ^ƒa ƒn ƒP‚C„SM. ‚^…aaƒY‚f.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [190]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
talk(2,"ƒnˆEŠi, ‰Bn[ŠVKLY.");
 MovePerson(1,6,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [191]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, ƒ{CŠ_ƒW I‡H …IG‚VŒeLY?",
 1,"ŠZ…I nLM. ƒ[…f G …_‚_‚h ƒ_uŠVS ŠFGM.",
 2,"GCWLM. …_‚_ aƒv „U…Zf …I‚^…e ‚^‚j‚VMLZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚĞí²ı³ÇÄÚÉ¢²½£®>
 NextEvent();
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ƒ{CŠ_ƒW I‡H …IG‚VŒeLY?",
 1,"ŠZ…I nLM. ƒ[…f G …_‚_‚h ƒ_uŠVS ŠFGM.",
 3,"‚SŠS ˆY …IhLY. M‡M …IG ‚aMA …_‚_Gƒb nY ƒ[ ‚r…x „Kf ƒsƒ_A ƒ[„Vj…hZ.");
 end
 end,
 [192]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, HI ‰KG `‚E‚C …X‚Vƒd ‹wf ƒv^ ƒU†vGƒv D‚V‚CZ.",
 1,"ƒ[ƒuD Šo†y‚wƒv.");
 MovePerson(1,3,1);
 AddPerson(68,3,20,0);
 MovePerson(68,2,0);
talk(68,"‚G‚PŠi, bƒG „TŠV‚TZ. …f‚b vvŠiƒP ‚^a ‡m…fhLM. ‚K‚JŠ_ƒW ‹pƒd…x a‚VL ‚K‚JƒP e…f„S [‡I‚V[. ƒU„S Ff „OKLM.");
 MovePerson(68,5,1);
 DecPerson(68);
 MovePerson(1,6,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ƒ[ …_‚_‚h ‡Gƒd ^‚V‚CZ. ‚Z‹n†{ a‚r…Hƒb …_‚_G‚C ‚kKLY.");
 end
 end,
 [193]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(9,17,13,1);
 AddPerson(1,3,20,0);
 SetSceneID(43,5);
 MovePerson(9,6,1);
talk(9,"ƒ[‚_‚h ‚^‡M ƒuƒb m…ZS ‹D ƒR„kƒG „U…ZG[.",
 1,"m…ZG‚f a‚VA?",
 9,"ƒ{CŠ_ …_‚_‚h a‚r…HƒtM„l‚T. ‚Cƒg ‡Gƒd „O‚b ƒ[ƒuG[? Fˆ| ƒ[‹@ …IG „O„km?",
 1,"k, ƒ[‹@ …IG „O„kKLM.",
 9,"‡d‚V ƒsb „{ q „O†ym?",
 1,"ƒs‡I‚V[.",
 9,"‚M, ‚G‚P. ‚S‹cm? G …_‚_‚h ƒ_Q „{ q „O†ym?");
 local menu={
 {"¡¡¡¡ƒeM",nil,1},
 {"¡¡ ‚K‚C ‚k‚bM",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"ŠoKLM, …_‚_‚b …wu‚CZ.",
 9,"nL nL, ˆNG[. Gƒuƒb ƒ{CŠ_ƒW ƒ_uƒN ƒAw nL[. ‡mƒv ‹sƒd‚b Š]‚wƒ`. ‚G‚P, g†dG[? Fˆ| …_‚_‚h ƒ_Q „|ƒG†ym?");
 elseif r==2 then
talk(1,"n, ƒ[ƒuG. Gƒuƒb a‚r…Hƒb ƒAwG‚fƒW¡­¡­",
 9,"‚G‚P, ƒ[u ˆ|X ƒu ‚am. G …_‚_‚h ƒ_Q „|ƒG†ym, „|ƒG‚C ‚k†ym?");
 end
 r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"ƒ[‰S…l ƒQaƒNMA …wu†yKLM.",
 9,"Fˆ|G[? ƒ[†{ ‚r†o„Q ‚k†ym.");
 SetFlag(20,1);
 elseif r==2 then
talk(1,"‡p‚wa[ƒv ƒQaƒNM BD Gƒu„Vƒb¡­¡­",
 9,"‡m, …X‚Mf ‚[‚C …X‚V[. ˆNG„km. ƒ[‚_^ ‚q‹nBa‚b Œv†^G ƒsƒd Š]„kS ŠFG[.");
 end
talk(9,"ƒ[†{ ‚Z‹n†{ ‚@‚MPƒmL ‰HŠ_ ƒHGƒv o‰xW‚VM.");
 NextEvent();
 end,
 [194]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(9,11,20,0);
 AddPerson(1,13,21,0);
 SetSceneID(66,5);
 DrawStrBoxCenter("FƒQ");
talk(9,"‚G‚P, G‹Jƒm„S [‚V[.",
 1,"k, ƒdŠOKLM.");
 --
 MovePerson( 9,5,0,
 1,5,0)
 MovePerson( 9,0,3,
 1,0,2)
 DrawMulitStrBox("¡¡‚G‚P‚b vv‡z ˆ|S G‚b ƒuG ‚n…UaM †sŠYAƒWD ‰HŠ_ ƒHS …X‚VƒG„S PM. Œv…XG …XƒN ‡D¡­¡­");
talk(9,"‚G‚P, ‡iƒoƒP ~†]G‚fA †u‚w‚h H†ym?",
 1,"†hJƒ~…e‡S ƒA‚MG‡ILM.",
 9,"G ˆ_ƒb ‚saf ~†]G aƒvD ‚aS u ‚am. ƒ[‚_‚b †[‹s ‚r†vS ^‚S ƒsƒtS ‹|…h, ƒ[‚ef ~†]ƒP …x‹TS ‹sI …x^ ‚a„km? nLA¡­¡­",
 1,"¡­¡­",
 9,"‚_†CB ƒs‚V[, ‚G‚P. †u^ ~†]G‚f ƒs[?");
 local menu={
 {"¡¡ …xƒG …xƒN",nil,1},
 {"¡¡ vv",nil,1},
 {"¡¡ ƒQm",nil,1},
 {"¡¡ ƒQƒH",nil,1},
 {"¡¡‚J‡Y‡Z",nil,1},
 {"¡¡‚Z‚j†yM",nil,1}
 }
 while true do
 local r=ShowMenu(menu,6,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(9,"‚N‚N‚N! ƒ[ŠQ‚C, ‚G‚PfQ‚b ~†]ƒP …x‹TG „OM. ƒ[…eƒGf „N†dX q ‚a‚C. ƒ[…e‚C ‚kƒmA …C†IG ‹[‚aƒmu‚f.");
 SetFlag(21,1);
 break;
 elseif r==2 then
talk(9,"‚N‚N‚N! aaa! ƒ[‚_^ ƒ[u ƒs‚b^. ƒvD ƒ[u ƒs[. ƒ[ŠQ‚T, ƒ[‚_‚b ƒ[u `‚Ea‚b‚T. Nƒb ƒv‚b ƒ[‚_ ‚G‚P ‡Oo ~†]G‚f ƒs[. ƒ[ŠQm, ƒv‡z „Gƒb ~†]G[.",
 1,"I‡H ˆ|Š[G‡ILY. …f‚b ~†] „Gƒb ƒuG ˆf ŒjLM.",
 9,"ƒ~ƒ~„S‚h ‚m‚^‚f bŒIMA ƒ_^ ‚SŠS ƒ[‚_‡z ‚S…[u†ym? ‚G‚P, ƒv‚b ƒ[‚_^ ‚[Šqm.");
 SetFlag(21,1);
 break;
 elseif r==3 then
talk(9,"ƒQm‚f. {…B ‚X…Z …bƒNGƒd ‚^aƒRD ˆc‚Sƒv‚C. ‡mƒv FJ „vjG ƒO‚G‚^†Ma[. ƒ[‹@ …x‚b ‚nƒND ƒW‚C ‚kƒmL ~†]G‚f X q ‚am.");
 elseif r==4 then
talk(9,"ƒQƒHG‚f. d ‰{…{„V JƒG‚b K‚Cf ‚Cƒv‚C ‚km. Šc‚C‚kn ƒ_^ ‚aL ƒuG[. ƒQƒHG ~†]G‚fL, †EŒQˆ|ƒb …X‚V[.");
 elseif r==5 then
talk(9,"‚J‡Y‡ZG‚f. ƒ[‚_‡z „W‡LG ‚[ƒhfƒmL G‹@ ˆ|G †E…j„u‚C ‚Z‚jƒv, ƒ[…x‚b ˆEƒof HI ‚SLm. G ‚qƒo‚h Mƒ~„u ‚r†vG ˆf „C[.");
 elseif r==6 then
talk(9,"‡iƒof ~†]G ‚aM‚b ˆ|G[? ƒv‚b ƒ[u ƒs‚C ‚km. ‡iƒoƒP ~†]ƒb ƒ[‚_‡z ƒvZ. ƒL‚SD ƒv‚b ƒ[u bƒG[.",
 1,"ƒ[, ƒ[ƒuƒb¡­¡­ ˆNƒb †E‚[‡I‚V[.",
 9,"aa! ˆNG‚f ƒs[? ƒ[ŠQM „Q‚CZ.");
 break;
 end
 end
talk(1,"¡­¡­");
 if GetFlag(20) then
 if GetFlag(21) then
talk(9,"n, [ƒXƒb ˆB†Efm. G …_‚_‚b ƒ_^ †E‚[†ym.",
 1,"ƒ[†{ G„V ƒA…e^†yKLM.");
 else
talk(9,"[ƒXƒb ˆB†Efm. G …_‚_‚b ƒ_^ †E‚[†ym.",
 1,"ƒ[†{ G„V ƒA…e^†yKLM.");
 SetFlag(20,0);
 end
 else
talk(9,"[ƒXƒb ˆB†Efm. ˆAŒW^ ƒOu ŠeG B†D …XŒs ‹b‚VM.",
 1,"ƒ[†{ G„V ƒA…e^†yKLM.");
 end
 PlayBGM(5);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<»Øµ½×Ô¼ºµÄ¹ÙÛ¡£®>
 MovePerson(1,10,1);
 NextEvent();
 end,
 [195]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
talk(2,"ƒnˆEŠi, ‰Bn[ŠV‚TZ. vvfQ MˆQ[ŠVMŠB…h ŠZ…I ‚aƒmŠVKLY?");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë¹ØÓğµÈÌ¸¹ØÓÚ½ñºóµÄÊÂ£®>
 MovePerson(1,7,0);
 if GetFlag(20) then
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --Goto 196
 else
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent(197); --Goto 197
 end
 end,
 [196]=function()
 PlayBGM(11);
 AddPerson(68,3,20,0);
 AddPerson(17,1,19,0);
 AddPerson(19,5,21,0);
 MovePerson( 1,0,1,
 68,5,0,
 17,6,0,
 19,6,0);
 MovePerson( 17,0,3,
 19,0,2);
talk(17,"‚G‚P, ƒ[‚_‚b ƒ_ ‹Ff …Gƒmu‚f.",
 2,"ƒnˆEŠi, ‚n…UWLM!",
 3,"n! ƒnˆEŠi!");
talk(1,"ƒm…v!");
 DecPerson(1);
 PlayBGM(4);
talk(68,"…_‚_fƒW ‹hƒW^ ƒvŠXM. vv‚h …GG‚f ƒL‹u „O„kM.",
 17,"ab ƒOu^ …mq‚h ˆj ƒuG[.",
 19,"…x†n…xƒDG‚CZ. ‚K‚JŠ_ƒW‚b gJ ƒ[‚h ‚n…Uo jƒA„S ƒsŠV‚b…h, FJ „vjƒb ‚Z‚jƒd ƒnmu‚h „QM G‹@ ŒBS ‡iPKLM.");
 DrawMulitStrBox("¡¡‚G‚P‚b …GRS ‡iPƒd, oNƒP ‚n‡nS „C†juƒ`ŠB ƒ[ƒP ‹dD ‰HŠ_ ƒ~…eƒFM.");
 --ÓÎÏ·Ê§°Ü:
 NextEvent(999); --Goto 999
 end,
 [197]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, vvfQƒW I‡H ˆ|G [‰tKLY? vv^ I‡H ‚M‚Z‚h ƒV‹hY OFhLM.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, v†da‡I‚V[. vvfQ‚b ^‚C ‚kƒm‚V‚b Q ŠoKLM. †u^ †[ ‚Z†ohLM.");
 AddPerson(384,3,20,0);
 MovePerson(1,0,1);
 MovePerson(384,5,0);
talk(384,"‚G‚U†f, N‹~a†yKLM. ŠkƒmŠVKLY? nY ƒ{C Pf „OŠB ‚lthLM.");
 NextEvent();
 end
 end,
 [198]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚lt ‚_jGŠV‚TZ. I‡H …IG‡ILY?");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‡YŠiS ŠGƒm‚V‚CZ.");
 end
 if JY.Tid==384 then--¶­³Ğ
talk(384,"†hJƒ~…e‡S „N…Z ‡p‚wWLM. ‚U†fŠ_ƒW ŠDaŠ_ …_‚_‚h a‚r…HƒmŠVM‚CZ. ‡d‚V ƒsb ‚KN q „O†yKLY?");
 local menu={
 {"¡¡ƒsb ƒeM",nil,1},
 {" ƒsb ‚K‚C ‚k‚bM",nil,1},
 }
 while true do
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(384,"[, {…B …_‚_„S‚TZ. Nƒb …f ‡Oo „Gƒb …_‚_‚h …HƒtKLM. ƒ[uƒd G …_‚_‚b ‚rN¡­¡­");
 DrawMulitStrBox("¡¡‚ltG ‹F„S …_‚_‚h ^‚j…x ‚ofƒW TG o ƒaG „n‚SƒFM.");
talk(1,"nL! ‚of TG^ ƒR‚S „OML! Gƒuƒb I‡Jj^? ˆWƒW„SM. vv‚h …GG‚f ƒL‹u „Om.",
 384,"ƒ[ŠQKLM. ƒ{CŠ_ƒW ‰X„S ˆ`ƒN ƒuhLM. †~ƒm„S „w„dX …IG‚CZ!",
 1,"ƒ[ŠQMA ƒ{CŠ_ƒW †@†dS IŠWƒN ‚Z†oG‚TZ.",
 384,"ƒ[ŠQKLM. vv‚b ‹n‚M‰` ‡tƒNj „fa„lL ZŠrƒb ˆA‚]G …X„Q d^ ‚Udj †oWLM.",
 384,"ƒ[‚b ƒ{CS ƒX ‚o‚efD ‚[‚C ‚kKLM. ƒ{CŠ_ƒW‚b „IƒAS Uu†B dQ G …_‚_‚h ƒ_uŠV‚CZ. …f‚b ‚C‚qƒS ŠDaŠ_ hƒb ƒbƒp‚h ‹yƒd…x vv ‰S‰rS Qaƒd „OKLM.",
 384,"‚U†fŠ_ƒWD ‰HŠ_B ‚K‡I‚V[. ‚U†fG ‰HŠ_aƒNMA …fŠs‚b o†@ ˆeˆeB†LLM. ‚^ƒZ ‰RWLM.",
 1,"‚lt, ƒv ‡Oo ƒ{CƒP ƒNaZ. ‰HŠ_a†ym.",
 384,"[, ƒdŠOKLM. ƒ[†{ …f‚b M‡M ƒ]„O‚b GƒR{ …Bˆya†yKLM.");
 MovePerson(384,8,1);
 DecPerson(384);
 break;
 else
talk(384,"‚U†f, …~ƒG‚C …X‡I‚V[. …_‚_ …Iƒb G†w ƒR„kKLM. …x, dQ ƒsb ‚K‡I‚V[.");
 end
 end
 NextEvent();
 end
 end,
 [199]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, …f‡z ƒa‚P ‚Z‚[ ƒGŒgLM. ‚S†s „Uˆe ‡tƒNƒb „O‚b ˆFG‚TZ! ‡mƒv G‡Ef „O‚b o vvƒP „IS Œz‚SƒS q ‚a‚S †E‚r‚h D‚ZaƒG ‚SŠqKLM. ‚Cƒgƒb G‡ES ‹Xƒv ƒW‚K„S ^ƒW †E‚~ „TƒCS bƒPa‚b „KG ‹o†yKLM.",
 1,"ŠoM. ‰b ƒW‚K„S ^…E†y‚wƒv. ‡mƒv vvƒP ‡mˆyG „O‚S…E aL, ƒ_^ ^ƒW „Vƒv ƒs†yM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÇëÇó²Ü²Ù×¼ĞíÀë¿ª£®>
 MovePerson(1,12,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ŠoKLM! „Nƒg aƒN ˆ|Š[ M ƒR„kKLM. †J‚V ƒOu ƒnˆEŠiG‡ILM. †|†}WLM!");
 end
 --[[
 if JY.Tid==2 then--¹ØÓğ
talk(2,"×¢ÒâÇ§Íò±ğ±»ËûÃÇ·¢ÏÖ£¬²Ü²Ù¿ÉÊÇ¸ö½Æ»¬µÄ¼Ò»ï£®",
 1,"ºÃ°¡£¬ÄÇÎÒÂíÉÏÈ¥ĞìÖİ£¬¿ÉÊÇµÃÓĞ²Ü²ÙµÄ×¼Ğí£¬ºÃ£¬ÎÒÈ¥¼û²Ü²Ù£®");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÇëÇó²Ü²Ù×¼ĞíÀë¿ª£®>
 NextEvent();
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"Èç¹ûÄÇÑù¾ö¶¨ÁËµÄ»°£¬ÎÒÃÇ¾ÍÂíÉÏ·µ»ØĞìÖİ°É£®");
 end
 ]]--
 end,
 [200]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(9,25,9,1);
 AddPerson(17,14,9,3);
 AddPerson(18,12,10,3);
 AddPerson(19,25,15,2);
 AddPerson(20,23,16,2);
 AddPerson(84,21,17,2);
 AddPerson(1,3,20,0);
 SetSceneID(85);
 MovePerson(1,7,0);
talk(9,"‚G‚P, …Xƒl ŠU ŠXm. ƒ[‚_fQ X ˆ|G „Om.",
 1,"dQ ˆ|Š[G‡ILY?",
 1,"(I‡H …I…IY. E…X ƒ[ „TƒCƒb nL†y‚C. ƒ[Šl u^.)",
 9,"„V‡TƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [201]=function()
 if JY.Tid==9 then--²Ü²Ù
talk(9,"‚G‚P, …xƒoo ƒuƒb „V‡TfQ ƒA‚Sƒs‚V[.");
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"„V‡TƒP ˆ|S ƒR‚S ƒs‚V[.");
 end
 if JY.Tid==18 then--ÏÄºîÔ¨
talk(18,"„V‡TƒP ˆ|S ƒR‚S ƒs‚V[.");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"„V‡TƒP ˆ|S ƒR‚S ƒs‚V[.");
 end
 if JY.Tid==20 then--²Üºé
talk(20,"„V‡TƒP ˆ|S ƒR‚S ƒs‚V[.");
 end
 if JY.Tid==84 then--Âú³è
talk(1,"„V‡T, I‡H ˆ|S aƒ` a[?",
 84,"ƒ[‚_fQ‚b …jR m‚y…I‚C ‚Z‹{LM.",
 1,"¡­¡­(E…X ƒ[ „TƒCƒb nL†y‚C?)",
 84,"‚J‡Y‡ZG ƒQmfQ †Uˆo‡iPKLM.",
 1,"I‡JG? ‚J‡Y‡ZG?",
 84,"ƒ[ŠQKLM. ƒQm^ ‚J‡Y‡ZS †Uaƒd ‚I‚_o ~‚C‚h ƒofKLM.",
 1,"ƒ[ŠQm?",
 84,"‡Oo ƒQƒHG G m‚yS Š^ƒd d ˆuS ‚C‰Jƒd…x ƒQm^ „O‚b †nƒ{ƒm„S †Yaƒd „OM WLM. ƒQm‡z ƒQƒHG ‡YS ‹QƒmA nID ƒ[ƒRS G†r q ‚aKLM.",
 1,"¡­¡­(ŒR‚C, G ˆ|S G„oaA vvfQƒW Œz‚SƒS q „O†y‚wƒv.)");
talk(1,"vvŠi, o ^‚C ‰RG „OKLM¡­¡­",
 9,"I‡H ‰RG[?");
 local menu={
 {" ƒQm ‰S‰rf ƒv…mM",nil,1},
 {" ƒQƒH ‰S‰rf ƒv…mM",nil,1},
 {" ‚J‡Y‡ZƒP ‡^f †~†coM",nil,1},
 }
 while true do
 local r=ShowMenu(menu,3,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
talk(1,"ƒQm^ …fu „W„VaQ ƒSˆcD…l Še q ‚aKLM. ƒQm ‰S‰rf ƒvƒWƒd…x aL ‚^ƒZ ‡mˆyB ‚K‡I‚V[.",
 9,"ƒ[ŠQŒI a[¡­¡­¡­¡­ ‡mƒv ‚Cƒg ƒQmƒP ƒoƒ}G „^Q …d„kƒmL ƒ[‚_ƒP ‚~ƒ}ƒm„S‚b G†r q ‚am. ƒ[…eL …bFƒb ‡mˆyX q ‚am. Šc‚C‚kn ƒ_^ ƒQm‡z †@‚FS ‰M ƒuGL, ‚G‚P, ƒ[„U „@S ƒs‚| ‚K‚V[.",
 1,"¡­¡­");
 elseif r==2 then
talk(1,"„Nƒg „V‡TG ƒQƒHG G†w ˆl„LŠbM PKLM. ƒQƒH ‰S‰rS ‡mˆyB ‚K‡I‚V[.",
 9,"‚G‚P, …bFa†yM‚b ˆ|G[?",
 1,"ƒ[uaA ƒQm‡z ƒQƒHƒP W]‚h ‡fƒd ‚J‡Y‡ZƒP ƒQqD ‹yS q „OKLM.",
 9,"Šom. ¡­¡­‚M, …b‚BS ‡ma[.",
 1,"ƒ[†{ ‰bƒU„S …bFS ƒe‚Pa†yKLM.");
talk(84,"‚G‚P, ƒQƒHG ‚HSf ‚K‰QB „OM a[.",
 1,"‚HSG‚f aŠVKLY. „a†yKLM. ƒ[†{ ƒA…e^†yKLM.",
 9,"†K…mS ‚P[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÎªÌÖ·¥Ô¬Êõ½ø¾ü¹ãÁê£®>
 break;
 elseif r==3 then
talk(1,"‚C‚qƒS ‚J‡Y‡ZŠ_ ‡Aƒb ƒNƒo‚h ƒFKLM. Gd ƒ[ ƒbƒp‚h ‹yS †rG ‚aƒmL †~ƒm„S n‡@KLM. ƒL‚SD ‡kƒwf ^ ƒ[ I‹Rf †~†caƒd…x WLM.",
 9,"g†dfƒW ƒv†[ ˆ|G†y‚C. ‡mƒv ‡kƒwƒb Gd ƒQmƒP ~‚CZ. ƒ[‡Ef ^‚b ƒuƒb HI ‚n…UaL ƒ[ ƒ]ƒb ‰nƒm‚V[.",
 1,"¡­¡­");
 end
 end
 NextEvent();
 end
 end,
 [202]=function()
 if JY.Tid==9 then--²Ü²Ù
talk(9,"ƒQƒHS ˆK…fŠW IH„]u†yM!",
 1,"ƒ[†{ ‰bƒU„S …bFS ƒe‚Pa†yKLM.");
 MovePerson(1,9,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==17 then--ÏÄºîª
talk(17,"‚G‚P, ƒ[‚_‚b I‡J „U…Zf G‡Ef ƒP…aa…e ŠXm?");
 end
 if JY.Tid==18 then--ÏÄºîÔ¨
talk(18,"ƒQƒH ‚i‚n Œi‡pGfQ ƒ_^ ƒvE ƒuY‚CD ‚a‚CZ.");
 end
 if JY.Tid==19 then--²ÜÈÊ
talk(19,"„N†dƒb ƒgƒAhLM. I‡H …IG ‰r‚S‹T‚C ‚Z‚jLYZ.");
 end
 if JY.Tid==20 then--²Üºé
talk(20,"ƒQƒHƒb ƒ~ƒ~„S ‚Ud‚h Wo ^Ša ‚UdZ. ‚G‚P, ƒ[ ^Ša ‚Ud‚h ƒq‚S…E a[.");
 end
 if JY.Tid==84 then--Âú³è
talk(84,"ƒQƒHG ‚HSf „OM a[. tu‚h ‚P[.");
 end
 end,
 [203]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
 MovePerson(1,6,0);
talk(1,"eƒO, ƒa‚P. …bFoM!",
 3,"Gu †hJƒ~‚R I‡H …IhLY?",
 1,"vvfQƒW Œz‚SƒS ‚wNS ‹qƒtM. ƒQƒHG ‚Cƒg ‚HSf „OM aL ƒ[‚h „Q…e …yM.",
 2,"ŒR†EL. ƒQƒHS ˆj ‡Df‚b ‡m†gƒm„S ‰Bn^‚C ‚kƒd ƒW‚K„S ^‚b ƒuG‚CZ? vv^ ƒP†da‚C‚b ‚kŠB^Z?",
 1,"ƒP†da‚C ‚kƒtM.",
 3,"ŠoKLM! G‚_„S ‡m†gf S…eŒ_‚b Q n†m^ OFP‚b…h ŠU‹kKLM. ‰jˆlG‚fL ‡YG †Z‹T†Eu‚b‚TZ. ƒ[†{ …f‚b …y‡r …I‚]fQ „au†yKLM.");
 MovePerson(3,8,1);
 DecPerson(3);
talk(2,"ˆEŠi, ‚HSƒm„S …b‚~aƒG ‚Bf ƒ{CS ‹p‚b „KG Šo‚C ‚k†yKLY.",
 1,"ƒ[ŠQ‚wƒv. ƒ[†{ ‚U†Xf MˆQ[…X.",
 2,"ƒ[‚l‚o …fŠs‚b …bF ƒe‚P‚h a†yKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥»Ê¹¬¼ûÏ×µÛ£®>
 MovePerson(1,8,1);
 DecPerson(1);
 NextEvent();
 end,
 [204]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(383,7,8,3);
 AddPerson(384,19,8,1);
 AddPerson(1,37,23,2);
 SetSceneID(84,8);
 MovePerson(1,8,2);
talk(383,"[, ‚U†f. „Nƒg ‚ltG ‰cfQ n„b„kƒY‚f. ‰cƒb †~ƒm„S ƒGŒ}DM.",
 384,"ŠDa, ƒcmu^ HI TLM. v†da‡I‚V[. ‚U†fŠ_ƒW‚b ‚Sj …I„S [ŠVKLY?",
 1,"Nƒb G‚Wf ƒQƒHS ‰S‰ra…e ‡m†gS ‹XƒvQ „C„kKLM.",
 383,"I‡JG‚f? ƒ[u„CA [†GD…l ‚U†fS ƒs‚C ˆfa‚b ƒuG n†m^? Gƒuƒb¡­¡­");
talk(384,"‚G‚P, ƒ[‚_^ ‹XƒvA ƒOuƒP †_‡Cƒb ‚SŠS „C‚b^?",
 1,"ƒU„S ƒ[ †_‡CS ‚nB ŠXKLM.",
 384,"‚M.",
 1,"†_‡Cƒb Šk‚C ‚kƒtKLM. ‡mƒv ‡m†gf „O‚b o ƒX vvƒP ‡N‚V‚h …HKLM. ƒ[Šl ƒUf‚b G‚W …bFS ƒG‚}„S ‡m†gS ‹Xƒv vvfQƒW Œz‚Sƒv‚b „KG ‹oKLM.",
 384,"{…B ƒ[ŠQKLM. QM^ ƒOu^ …x‚K „VƒvA vvƒP ƒP†d„V U‚C‚CZ. ŠoKLM, d^ ƒ{CŠ_ n„b†yƒmL ‚o†da‡I‚V[.");
talk(384,"[, ‚U†f. „Nƒg ‚ltG ‰cfQ n„b„kƒY‚f. ‰cƒb †~ƒm„S ƒGŒ}DM.",
 383,"I‡JG? ‚M, {…B ƒ[ŠQDM. ƒ[ŠQ‚C, †J‚V ‚U†fG„SM. „a†yƒY‚f. ƒ[†{ ‚U†fƒb ‚s‚sŠW „@S †r…e „^Q ƒSn[‚j‚f.",
 1,"„a†yƒvGM. ƒNƒb G„V ƒA…e^†yKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÎªÌÖ·¥Ô¬Êõ³ö±ø¹ãÁê£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [205]=function()
 if JY.Tid==384 then--¶­³Ğ
talk(384,"‚G‚P, ƒOu‚b ƒ[‚_fQ ƒG‚_‚h ‚@ƒd „Om.");
 end
 if JY.Tid==383 then--Ï×µÛ
talk(383,"‚U†f, ‚s‚sŠW „@S ƒG‚j‚V[.",
 1,"„a†yƒvGM. ƒNƒb G„V ƒA…e^†yKLM.");
 MovePerson(1,9,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [206]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 SetSceneID(77,5);
 MovePerson(1,6,0);
talk(2,"ˆEŠi, ƒGMuƒd „O„kKLM. ƒe‚P‚h …X‡RƒmL ‚SƒW …b_a‚V‚CZ.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [207]=function()
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"…b_a‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
 WarIni();
 DefineWarMap(15,"d1ƒa ‚HS ‚B„e","1. ƒQƒH ‚p…D",30,0,11);
 -- id,x,y,d,ai --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,4,2,4,0,-1,0,
 -1,6,2,4,0,-1,0,
 -1,5,3,4,0,-1,0,
 -1,5,5,4,0,-1,0,
 -1,4,4,4,0,-1,0,
 -1,3,1,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 });
 DrawSMap();
talk(2,"ƒ[†{ …b_a…x. vv^ ƒOuƒP †~ƒ]S „an…^A ƒn…IGM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [208]=function()
 JY.Smap={};
 SetSceneID(0,11);
 DrawMulitStrBox("¡¡o„K ƒQƒHƒb ƒ~ƒ~„S ‚Ud‚h Wo ‡D ˆpD„S ‚r„Qƒ~…e‡S `ˆdS †uuM …Xƒlƒ_ †eƒ{fQ „q‚O…HƒtM.");
 DrawMulitStrBox("¡¡„l‚b „q‹} q ‚aQ ˆY ƒQƒHƒb ˆE ƒQmfQ ˆuS ƒP…aaƒd…x ƒG‚K„S †YPM.");
 DrawMulitStrBox("¡¡ƒQƒHƒP ‚]ƒfƒb ‚C‚qƒS ƒ[^ V‚S‚Zƒb ƒuƒRƒP †L‚_ƒ{G‚f X „VPM. ƒgƒbƒs@^ ƒa‚rgS Gƒ^„kƒd †eƒ{ƒRƒP ‰Vmu^ ƒ[„Q‚C ‚kƒtM.");
talk(12,"GŒNƒR! ƒWŠe…e‚f! ‚G‚PfQ ‹QŠWƒG‚fD a‚d ˆ|GŠm? ‚SƒW!",
 355,"nGƒd, †jƒ` ‚K‡I‚V[.",
 12,"‡O s„]‚b …x‚b ƒq‚S‚f. ƒ_ ‹I†rS ‡f‚b …xD ƒq‚S‚f.");
 SetSceneID(0,3);
talk(2,"ˆEŠi, ‚SƒW ‚HSƒm„S g‚Ta‚V‚CZ.",
 83,"‚HSƒb ‡m†gƒP ‚l‹JhLM. ‚K‚J, g‚Ta‚V‚CZ.");
 NextEvent();
 end,
 [209]=function()
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 11,17,15,2,1,20,2,0,0,-1,0,
 42,16,14,2,1,16,5,0,0,-1,0,
 69,17,11,2,1,17,8,0,0,-1,0,
 66,18,12,2,1,17,2,0,0,-1,0,
 71,18,14,2,1,16,2,0,0,-1,0,
 31,15,15,2,1,16,5,0,0,-1,0,
 256,18,13,2,1,14,1,0,0,-1,0,
 257,18,10,2,1,13,1,0,0,-1,0,
 274,16,12,2,1,14,4,0,0,-1,0,
 275,15,12,2,1,13,4,0,0,-1,0,
 328,17,13,2,1,13,13,0,0,-1,0,
 329,19,12,2,1,13,13,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [210]=function()
 PlayBGM(11);
talk(12,"I‡JG‚f? ‚G‚P^ ŠXMƒd? ‚M, Š`…xuƒv ‰OŠB ‹U‹Vo Œi‡pG „GƒmL. ‚B‚T ‚G‚P‚h ŠP‚f.",
 1,"ŠoM, …f …v‡iS ƒq†yM. ƒQƒHS ŠP‚f.");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [211]=function()
 if WarMeet(3,70) then
 WarAction(1,3,70);
talk(3,"G }ƒLƒRn, ‡NŠW dŠA‚_„S ‚Ud‚h Waƒd „N…xaQ ‚w‚b‚wƒv. ƒ_^ H‚h ƒq†yM!",
 70,"†u^ ƒ[‹@ ‰umu‚h ƒR‚S ‚K]! ƒa‚P! ƒ_^ H‚h ƒq†yM!");
 if fight(3,70)==1 then
talk(70,"ƒ_ ‹FS …Hn‚f!");
 WarAction(9,70,3);
talk(3,"‚SG…P, n…jn…jPM! G‚W‰` ƒ_^ †gS Kb ‚K…X!");
 WarAction(8,3,70);
talk(70,"nGƒd!",
 3,"†gf ‹x„~M!");
 WarAction(18,70);
 WarLvUp(GetWarID(3));
talk(3,"G†G…E ‚VƒQWLM. [, ƒG‚Y G…xƒP IƒG^ dˆFG‚TZ. ‚BuƒBƒm„S ^ˆk^†yKLM.");
 WarGetItem(3,14);
 else
talk(70,"ƒ_ ‹FS …Hn‚f!");
 WarAction(8,70,3);
talk(3,"nGƒd! †gf ‹x„~M!");
 WarAction(17,3);
 WarLvUp(GetWarID(70));
 end
 
 end
 if JY.Status==GAME_WARWIN then
talk(12,"‡m, ƒ_^ ‚SŠS ‚G‚P ‚i‚n Œi‡pGfQ g†M ˆ|j^?");
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒQƒHS ƒqƒd ‚G‚P‚TG ƒQƒH‚TS „^Q I‹xŠjM.");
 GetMoney(600);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¶£°£°S ƒYƒC.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(7,18,12,189); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÆßĞÇ½£
 --[[ --¸ÄÎª»ñÈ¡µÀ¾ß
 if (not GetFlag(190)) and WarCheckLocation(-1,3,13) then
 --33 ¼ì²éÊÂ¼ş:03 00 01 BE
 GetMoney(400);
 DrawStrBoxCenter("½É»ñ»Æ½ğ£´£°£°£¡")
 SetFlag(190,1);
 end 
 ]]--
 WarLocationItem(3,13,106,190);
 end,
 [212]=function()
 SetSceneID(0,3);
talk(3,"ƒQƒHG G‰S…l ‚VƒQƒKS „{ƒb Œ{„g‚TZ.",
 2,"a‚P„S ƒR‚S†h‚VM. a‚Pf ƒR‚S^A vv^ †[M BD ‚C‡Q q „OKLM.",
 64,"ƒ[ŠQKLM. vvƒP †d‚D †E‚K^ ƒW‚Kf „OM aL ƒW‚K^ @†ZhLM.",
 1,"„a†yM. ƒ[†{ a‚Pf …xu ‹Q…x. ƒ[‡EfƒW vvf ŠGE „N‚uS bƒPa…x.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚÏÂÚüÑĞ¾¿½ñºóµÄ¶Ô²ß£®>
 NextEvent();
 end,
 [213]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="a‚P";
 JY.Base["D‚wC"]=9;
 AddPerson(1,25,17,2);
 AddPerson(2,11,16,0);
 AddPerson(3,9,15,0);
 AddPerson(64,7,14,0);
 AddPerson(83,22,10,1);
 AddPerson(65,20,9,1);
 SetSceneID(54,5);
 DrawStrBoxCenter("a‚P ƒP‚r‰R");
 PlayBGM(11);
 AddPerson(82,1,5,3);
 MovePerson(82,7,3);
talk(82,"‚K‚J, ƒn…IhLM!");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÑĞ¾¿½ñºó¶Ô²ß£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [214]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"†w„NG …w„u ˆ|Š[G „OM WLM. ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"„Nƒg G‹H‚b…h I‡H …IG ‡O „O†y†sŠm.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"†w„NƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"d nƒOƒP ˆ|S ƒR‚S ƒs‡I‚V[.");
 end
 if JY.Tid==82 then--ÃÓ·¼
 JY.Status=GAME_SMAP_AUTO;
talk(82,"‚K‚J, „Nƒg m‚yS ƒR„kKLM. ‚lt …I‚]G vvfQ †jB„C„kM WLM.",
 1,"I‡JG? …G„kMƒd? ‚SŠSab …G„k†M ˆ|GŠm?");
 NextEvent();
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"ƒO…m †w„NƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 end,
 [215]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(383,7,8,3);
 AddPerson(9,13,11,2);
 AddPerson(69,19,8,2);--1
 AddPerson(17,21,9,2);
 AddPerson(18,23,10,2);
 AddPerson(62,9,14,2);--0
 AddPerson(19,11,15,2);
 AddPerson(20,13,16,2);
 SetSceneID(84,8);
 LoadPic(11,1);
 DrawMulitStrBox("¡¡‚lt …I‚]G ƒVˆM vv ŠN†j „TƒCƒb N‚] „L‚Bf †D‚S ƒv‰tM. G‚h ‚o vv‚b „^Q ƒYB ‚lt …} ‚K‚Z…x‚h †~†jaƒd ‚w„RS †UaL, …Gƒb …x^ £·£°£°b ‚Xf G‚jŠjM.");
 LoadPic(11,2);
 DrawStrBoxCenter("‡m†g †X‚B");
talk(9,"ƒ{CŠ_ƒW G ŠN†j „TƒCS nŠVS u‚b ‚a†y‚CZ.",
 383,"ƒ[, ƒ[ƒuƒb ‰cG „a‚C ˆfaƒY‚f.",
 9,"ƒ[…e‚VMA „C„kKLM. n, ƒNƒP I‹~‚h „oƒWamƒW.",
 383,"¡­¡­(‚lt, ‰cG ƒ[‚_fQ †w‚oa‚wƒv.)");
 MovePerson(9,0,3);
talk(9,"‡mƒv ‚G‚P„Vƒb †@ŠH „oƒWX q ‚aM. ‚C‚qƒS ‚}…gfƒW @‚h hƒd ˆGnŠgS „U ƒ_^ †E‚[‚S ‚K„k†EƒX ƒbƒp‚h …f„q„~M. ‚B‚T …bFS ƒe‚Pa‚f. ƒ_^ „L‰n ƒv…mM.",
 17,"‚XS …HƒR†yKLM!",
 9,"ƒ[uƒd ƒW‚KƒP †E‚KfQ ‚Ba‚f. a‚PƒP ‚G‚P‚h „Q‚fƒd.");
 
 NextEvent();
 end,
 [216]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="a‚P";
 JY.Base["D‚wC"]=9;
 AddPerson(1,25,17,2);
 AddPerson(2,11,16,0);
 AddPerson(3,9,15,0);
 AddPerson(64,7,14,0);
 AddPerson(83,22,10,1);
 AddPerson(65,20,9,1);
 AddPerson(82,15,12,3);
 SetSceneID(54);
talk(82,"G„S‰l ‚K‚JŠ_ƒW vv ŠN†jf ^†io …ID …w…eŠgKLM. vv^ ƒW‚KƒP †E‚KfQ ƒOu‚h „Q‚f ‚XPM WLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [217]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚SŠS G‹@ …IG. G‰S…l Wu …w…eƒvML.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‡mƒv ƒnˆEŠi, G‡E„V IQ ‚C‰JA …Zd‚aKLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ‚SŠSXYZ?");
 end
 if JY.Tid==65 then--ÃÓóÃ
 JY.Status=GAME_SMAP_AUTO;
talk(65,"ƒOu ‚TƒP „@ƒm„S‚b D…fŠW vv‚TS ‡iB‰M q ‚aKLM.",
 1,"‚M.");
 AddPerson(369,1,5,3);
 MovePerson(369,3,3);
talk(369,"ƒsƒd…w„tLM. ƒW‚KƒP †E‚K^ G‡ES †R …^‚P‚h aƒd „OKLM.",
 2,"I‡JG? †E‚KY‚C G‡ES ˆjMƒd.",
 64,"‚K‚J, bƒGƒW Œ_n …GƒG‚h ƒGMu†sL ƒW‚K‚h ŠPƒW Šf„hƒd mO¡¤ƒW‚K¡¤a‚P ƒo ƒ{fƒW vv‚TS ŠG‚b „KG ‹oKLM. ƒ[uaA vv‚TƒP ‚~ƒ}D ‡L„[ŒjLM.",
 1,"Šoƒb `‚EG[. mO‚b ƒ_^ ‚C‰J†ym. ‚Cƒg ^†ym.");
 MovePerson(3,2,2);
 MovePerson(3,2,0);
 MovePerson(3,8,2);
 DecPerson(3);
talk(2,"ƒa‚P, …f ƒ{†Po ƒu. CƒPD ‚aG ^ „qu‚b‚T.");
 MovePerson(2,2,3);
 MovePerson(2,2,0);
 MovePerson(2,0,3);
talk(2,"ˆEŠi, …gƒb ‚[ ƒ{ƒb †u^ ‚CXLY?");
talk(1,"‚M, ƒ[ŠQ‚T. eƒO, ƒ[‚_^ G ƒ{S ‚C‰a‚f.",
 2,"k.",
 1,"ƒvŠc‚C‚b ƒW‚KƒP †E‚K‚h ƒGKoM. ‚SƒW ƒe‚Pa‚f.");
 MovePerson( 64,10,2,
 65,10,2,
 82,10,2,
 83,10,2,
 369,10,2);
 DecPerson(64);
 DecPerson(65);
 DecPerson(82);
 DecPerson(83);
 DecPerson(369);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"vv^ G†w ‚_‚TS Gˆnƒd ƒW‚K„S †YPM WLM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"ƒn…IG‚T. vv^ „L‰n ‚_‚TS Gˆnƒd †[MA ƒOu„SƒW‚b ‡iB‰M q ‚aM.");
 end
 end,
 [218]=function()
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"…bFa‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(2,"‚^‚_‚h „Kƒ{a‡I‚V[.");
 ModifyForce(2,0);
 ModifyForce(3,0);
 WarIni();
 DefineWarMap(8,"d1ƒa ƒW‚KII ‚B„e","1. †E‚K ‚p†U",50,0,8);
 -- id,x,y,d,ai --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,4,1,4,0,-1,0,
 -1,4,2,4,0,-1,0,
 -1,5,0,4,0,-1,0,
 -1,5,3,4,0,-1,0,
 -1,7,0,4,0,-1,0,
 -1,3,1,4,0,-1,0,
 -1,3,2,4,0,-1,0,
 -1,6,1,4,0,-1,0,
 -1,6,2,4,0,-1,0,
 });
 DrawSMap();
talk(2,"ˆEŠi, ‚^ƒZ ˆuv†da‡I‚V[.",
 1,"ƒ[‚_D G ƒ{S IQ ‚C‰JQ.",
 2,"G ƒ{S …G‚Mƒm„S ‚C‰J†yKLM.");
 JY.Smap={};
 SetSceneID(0,3)
talk(64,"ƒW‚K„S g‚Ta†yKLM.");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 89,29,12,3,2,21,2,0,0,-1,0,
 256,17,2,3,6,17,2,19,5,-1,0,
 257,24,6,3,0,17,2,0,0,-1,0,
 258,13,14,3,6,16,1,24,13,-1,0,
 274,17,0,3,6,17,5,19,4,-1,0,
 275,26,6,3,0,17,4,0,0,-1,0,
 276,18,13,3,6,16,4,26,11,-1,0,
 292,18,6,3,0,17,8,0,0,-1,0,
 293,25,2,3,6,16,7,26,13,-1,0,
 8,3,1,4,1,30,9,0,0,-1,1,
 61,12,1,4,1,21,16,0,0,-1,1,
 16,5,3,4,1,21,8,0,0,-1,1,
 17,8,0,4,1,21,22,0,0,-1,1,
 18,5,0,4,1,21,2,0,0,-1,1,
 ---
 19,15,1,4,1,21,24,0,0,-1,1,
 62,26,3,4,1,20,2,0,0,-1,1,
 115,27,0,4,1,20,2,0,0,-1,1,
 67,2,2,4,1,21,8,0,0,-1,1,
 76,13,0,4,1,21,13,0,0,-1,1,
 77,26,1,4,1,21,5,0,0,-1,1,
 68,9,1,4,1,21,13,0,0,-1,1,
 310,18,3,4,1,17,11,0,0,-1,1,
 311,7,2,4,1,17,11,0,0,-1,1,
 348,11,2,4,1,17,19,0,0,-1,1,
 277,23,0,4,1,16,5,0,0,-1,1,
 278,10,1,4,1,17,4,0,0,-1,1,
 279,17,2,4,1,16,4,0,0,-1,1,
 332,22,1,4,1,17,14,0,0,-1,1,
 ---
 386,4,1,4,3,24,15,8,0,-1,1,--µäÎ¤S
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [219]=function()
 PlayBGM(11);
talk(90,"d‚TƒR, ƒOu q‚b ƒL‚C„V vvŠ_ƒW …A…w‚V ƒQ‚~S ƒsƒ_N ƒuGM. ƒQ‚~G ƒi „UY‚C „qŒw…E oM.",
 64,"‚K‚J, bƒGƒW ‚C…raA vv^ ‹fKLM. ‚SƒW †E‚K‚h ‚ag‚VM.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [220]=function()
 if JY.Death==90 then
 PlayBGM(7);
talk(90,"GƒsQ ‚G‚P, ƒ[‚_‚b ‚K‚JƒP ƒbƒp‚h Šk„k‚wƒv. ‚B‚T …C…D.");
 WarAction(16,90);
 WarAction(16,257);
 WarAction(16,258);
 WarAction(16,259);
 WarAction(16,275);
 WarAction(16,276);
 WarAction(16,277);
 WarAction(16,293);
 WarAction(16,294);
 DrawStrBoxCenter("†E‚K‚TG ‚B‚T …C…DPM.");
talk(82,"ƒLƒb „l ‚a‚b ‡KWLM. ‚K‚J, ƒ{ƒm„S …w‚V‚CZ.");
 PlayBGM(9);
 War.WarTarget="1. ‚G‚P^ ƒW‚K hƒ{";
 WarShowTarget(false);
 NextEvent();
 end
 end,
 [221]=function()
 if WarCheckArea(0,10,29,14,29) then
talk(1,"„i? I‡H …IGŠm? G ˆ|_n mu‚b? ‚SŠS G‹@ …IG.");
 PlayBGM(11);
 WarShowArmy(8);
 WarShowArmy(386);
 WarShowArmy(61);
 WarShowArmy(16);
 WarShowArmy(17);
 WarShowArmy(18);
 WarShowArmy(19);
 WarShowArmy(62);
 WarShowArmy(115);
 WarShowArmy(67);
 WarShowArmy(76);
 WarShowArmy(77);
 WarShowArmy(68);
 WarShowArmy(310);
 WarShowArmy(311);
 WarShowArmy(348);
 WarShowArmy(277);
 WarShowArmy(278);
 WarShowArmy(279);
 WarShowArmy(332);
 DrawStrBoxCenter("vv^ ƒv…@ŠgM.");
talk(9,"…M! ‚G‚P! ˆGnƒvƒ` BD Gd‚b ˆf …yM! ƒv‚h …GGƒ` o …x^ ‚S†A ŒBS ‡ia‚b‚C ‹N‹NŠW „an ‚[‚S‚f!",
 64,"‚K‚J, †l‚BŠW †a‚n„C„kKLM.",
 83,"‚K‚J, mO^ ‰Hˆy„C„kKLM.",
 65,"‚K‚J, a‚P^ vvƒP ‚J‚pS …Hn ƒOu‚b †a‚n„C„kKLM.",
 1,"‚M, vv‚b {…B ‚_†Ma‚wƒv. †~ƒm„S ‚~ƒb ƒN…{‰HS ˆHŠW bƒG‚b ˆFGM.",
 64,"‚K‚J, Gd „ND^ ‚aKLM. †nƒ{ƒm„S ^ ƒQmfQ ƒP…aaƒd ƒ[‡EfƒW sƒG‚h D‚Za‚V‚CZ. ƒO…m ƒW…g‹J …XS„S ‰XaƒN ‡D „ND‚h ‹qƒm‚V‚CZ. ‚SŒJˆe ‚Cƒgƒb G‡ES ‹Xƒv…E WLM.");
 PlayBGM(10);
 War.WarTarget="1. vv ‚p…D*2. ‚G‚P^ ƒW…g …XS DˆG";
 WarShowTarget(false);
 NextEvent();
 end
 end,
 [222]=function()
 if JY.Status==GAME_WARWIN then
talk(9,"[, ‚G‚P G…x^ dˆFG‚T. ‡d‚V ƒA…eƒv ‚B‚TS M‚V „Kƒ{oM.",
 1,"‡d‚V ƒA…e‚q ‡Kaƒv ‰b M‚V †R ƒGŒYhLM. ˆuS Šfƒ`A †nƒ{ƒm„S ^‚V‚CZ.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡vv^ ‚TS ƒAuƒd ‚G‚P‚b vv‚TƒP †a‚n‚h ŒC„kM.");
 GetMoney(600);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¶£°£°S ƒYƒC.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarCheckLocation(0,16,1) then
bonus_moneyexp_4()
 WarGetExp(50);
 PlayBGM(4);
talk(1,"M‡M GƒRƒb ‚SŠS „C„k†sŠm?");
 DrawMulitStrBox("¡¡‚G‚P^ ‚BƒaS Œz‚SŠgM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end 
 end,
 [223]=function()
 SetSceneID(0,5);
talk(64,"‚K‚J!",
 1,"[! ‡Yw, I‚ro^. M‡M GƒRƒb ‚SŠS „C„km?",
 64,"‚Z‚j†yKLM. …fD ‚w‚r…I`G„kKLM. …y‡r …I‚]ƒP m‚yƒb ‚aKLM.",
 1,"ƒ[‹@^. eƒO‡z ƒa‚P‚b ‚SŠS „C„kS‹v. `‚rv„y „a q ‚a‚wƒv.",
 64,"‚[ ‡LƒP „o†_G‚fA I‚raN ƒuhLM. ƒO…m †nƒ{ƒm„S ^‚V‚CZ.");
 SetSceneID(0);
talk(1,"eƒO, ƒa‚P. `‚rv„y „a q ‚a‚wƒv. …fƒG [‚b …x‚b †u‚wŠm?",
 65,"nGƒd!");
 SetSceneID(0);
talk(1,"[, †wc. I‚ro^? †wc, M‡M GƒRS ƒsƒt‚b^?",
 65,"ƒs‚C ˆfPKLM. …f o ˆu J„} ˆGnƒvƒGf †P†PPKLM.",
 1,"ƒ[‹@^. ŠoM, ƒQmfQ ƒP…aa…e ^…x. ‚Cƒgƒb ƒ[ †rŠFGM.",
 65,"k.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥Úş³Ç¼ûÔ¬ÉÜ£®>
 NextEvent();
 end,
 [224]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=10;
 AddPerson(10,10,17,0);
 AddPerson(50,10,9,3);
 AddPerson(93,12,8,3);
 AddPerson(51,24,17,2);
 AddPerson(92,26,16,2);
 AddPerson(1,33,5,1);
 SetSceneID(83);
 DrawStrBoxCenter("†nƒ{ ƒP‚r‰R");
 MovePerson(1,8,1)
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [225]=function()
 if JY.Tid==50 then--Ìï·á
talk(50,"‰q…f …fŠs ‚K‚JŠ_ ˆ|Š[a‚V‚CZ.");
 end
 if JY.Tid==51 then--¾ÚÊÚ
talk(51,"vvfQ ‹K„} ŠXM‚C. G‚W‰` ‹jƒv ƒ|‚fo ƒNƒo†y‚wƒ`.");
 end
 if JY.Tid==92 then--ÉóÅä
talk(92,"‰jˆlf ƒFM BD vv^ bƒGY‚C ‹Kn[‚C‚b ˆfWLM. G ~‚CƒP ƒoƒ}ƒb n„L ‚I‚_aLYZ.");
 end
 if JY.Tid==93 then--¹ùÍ¼
talk(93,"…M, …f CY†L †K „Gƒb …x. ‚K‚JƒP nƒO‚h …GGƒdD ‡NŠW bƒGY‚C ƒG‚SƒR‚S ŠX‚T.");
 end
 if JY.Tid==10 then--Ô¬ÉÜ
 JY.Status=GAME_SMAP_AUTO;
talk(10,"‚G‚P, ŠU [ŠVm. vvfQ „^Q ‡iPM ƒR„km. ƒ_Q ŠXƒmL Gd ‚o†da‚V[. ƒv ‡Oo ZŠr vvƒP ‚|D^ …X‚Mf ‚@u[. bƒGƒW „@S ƒG‚j†B ‰HŠ_ vv‚h Š~‚VM.");
 NextEvent();
 end
 end,
 --µÚ¶şÕÂ¿ªÊ¼
 --µÚ¶şÕÂ¡¡¹Ù¶ÉÖ®Õ½
 [226]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d2ƒa¡¡eD ‚_‚B";
 DrawStrBoxCenter("d2ƒa¡¡eD ‚_‚B");
 LoadPic(12,1);
 DrawMulitStrBox("¡¡‚G‚P‚b vvfQƒW Œz‚Sƒv ƒG‚KƒP †nƒ{ƒm„S ˆGnŠgM.*¡¡ƒG‚K‚h Mƒ~u‚b ƒQm‚b vvƒsM ‚I‚_o ‚~ƒ}S ‚C‰Cƒd, ƒ[ „@S ˆ[ƒd vv‡zƒP †@‚BS †@†dPM. vv‚b ƒoƒ}G †w„Q‚C ˆfPƒmƒv †^a‚C ‚kƒtƒd, ‚[ ‚r†vƒb eDfƒW ƒn ‰jˆlS ‰rŠbM.")
 LoadPic(12,2);
 
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=10;
 AddPerson(1,3,20,0);
 AddPerson(64,16,10,3);
 AddPerson(65,14,11,3);
 SetSceneID(77,5);
 DrawStrBoxCenter("†nƒ{ ‚G‚P ‚Je");
 DrawMulitStrBox("¡¡‚G‚P‚b ‡Yw, †wc{ ‰HŠ_ †nƒ{fƒW ƒQmfQ e…f‚h Œfƒ` ‚C„jM. aƒ^aƒ^ ‚V…yG UŠjƒmƒv eƒO‡z ƒa‚PƒP ‚]„Nƒb b‚BŠW „a †rG ‚a‚S ƒvƒSG …X‚MG I†EfM.");
talk(64,"‚K‚J, „T…{ ƒGMuƒd „O„kKLM.");
 MovePerson(1,6,0);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÓëËïÇ¬Ì¸ÂÛ½ñºóÖ®ÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [227]=function()
 if JY.Tid==64 then--ËïÇ¬
 JY.Status=GAME_SMAP_AUTO;
talk(64,"‚K‚J, ƒQm^ †P‚r‚h ƒsƒ_ ‰bƒU„S †e…Xƒ{ƒm„S [‚V‚f WLM.",
 1,"‡mƒv n„L eƒO‡z ƒa‚P‚h ‹q‚C ˆfB OFG ‚|„[j…h, †e…Xƒ{f ‡y …X‚MG ‚SƒZ „O†y†sŠm.",
 64,"ƒ[ †dFƒb ŠIn„tLM. a[ƒv¡­¡­");
talk(65,"‚K‚J, ƒ[‰S…l OF„CƒNMA d^ eƒOŠi{ ƒa‚PŠiS ‹qn ƒvƒW†yKLM.",
 1,"[, ƒ[†{ ‚SƒW MˆQ[Q.",
 65,"‰bƒU„S MˆQ[†yKLM.");
 MovePerson(65,8,1);
 JY.Status=GAME_SMAP_MANUAL;
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥°×Âí³Ç¼ûÔ¬ÉÜ£®>
 NextEvent();
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, HI OF …X‡I‚V[. eƒOŠi{ ƒa‚PŠiƒb …A…w‚V ‚SZ^f †jn „TN ƒuhLM.");
 end
 end,
 [228]=function()
 if JY.Tid==64 then--ËïÇ¬
 JY.Status=GAME_SMAP_AUTO;
talk(64,"ƒQmŠ_ƒWD ‰bƒU„S [‚f a‚VL I‡H …I…IYZ? ‚K‚J, ‚SƒW †e…Xƒ{ƒm„S ^‚V‚CZ.",
 1,"ƒ[…e‚CZ.");
 MovePerson(1,9,1);
 NextEvent();
 end
 end,
 [229]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†e…X";
 JY.Base["D‚wC"]=11;
 AddPerson(10,25,17,2);
 AddPerson(51,22,10,1);
 AddPerson(53,20,9,1);
 AddPerson(55,18,8,1);
 AddPerson(93,11,16,0);
 AddPerson(103,9,15,0);
 AddPerson(92,7,14,0);
 AddPerson(1,1,5,3);
 SetSceneID(54,11);
 DrawStrBoxCenter("†e…X ƒP‚r‰R");
talk(10,"‚G‚Pj^. …M, …Xƒl ŠU ŠXm.");
 MovePerson(1,7,3);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [230]=function()
 if JY.Tid==51 then--¾ÚÊÚ
talk(51,"‚o„XG eƒOfQ …G„km. ‚o„Xƒb ƒOu ‚TfƒW ‡YHŠW‚b ‚_ƒaG„km. G ‡YNS ‚[ƒd ƒ[‚_‚b I‚S‚f a†ym?");
 end
 if JY.Tid==93 then--¹ùÍ¼
talk(93,"G †cƒbˆo‡Vo …x. ƒOu ‚K‚JŠ_ƒW ƒbƒp‚h ƒqƒrŠV†EƒX vv‡z ƒ_„waML.");
 end
 if JY.Tid==53 then--ÎÄ³ó
talk(53,"dƒGŠJ, ‡NŠW ƒ_ ˆEŠiS …GGML!");
 end
 if JY.Tid==55 then--·ê¼Í
talk(55,"G ƒNƒP‚h …f„qƒj …x!");
 end
 if JY.Tid==103 then--ÕÅàA
talk(103,"G ƒNƒP‚h …f„qƒj …x!");
 end
 if JY.Tid==92 then--ÉóÅä
talk(92,"G ƒNƒP‚h …f„qƒj …x!");
 end
 if JY.Tid==10 then--Ô¬ÉÜ
 JY.Status=GAME_SMAP_AUTO;
talk(10,"…M! I‡H Hƒm„S ŠX‚b^?",
 1,"‚_…r ‚SŠS ˆY …IG[?",
 10,"‚V„Q†w Œl‚C …X‚V[. ‚o„XS ‹G …x^ ƒ[‚_ƒP ‚^a eƒO^ n†m^?",
 1,"ƒ[ƒuG Fˆ| eƒOŠbKLY?",
 10,"ƒ_ ‚^aƒRG ƒLƒaƒb q…`G ŒI …xŠbM a[. ƒ[ƒuG eƒO^ nLƒd I‡JG[? ƒ[‚_‚b vv‡z ƒ_„waƒd „Om! ‚SƒW jFa‚V[! ‚o„XS ‹G …x^ eƒOŠ@M?");
 local menu={
 {" k, ƒ[…x‚b eƒOhLM",nil,1},
 {" nL[, eƒO^ n‚`LM",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==2 then
talk(10,"I‡JG, eƒO^ nL‚fƒd?",
 1,"ƒ[ŠQKLM. ‰p[, …f‚b eƒO^ ‚Cƒg †jn „O‚b‚Cv„y ‚Z‹{LM. Še[, q…`G †rM‚b ƒu„Vƒm„S eƒO‚f †MFX q‚b ‚a‚CZ!",
 10,"ƒ[ ˆ|D ŒRm. eƒO‚h ]ƒb Iƒa…I qD „O†y‚C. n, ‚G‚P. ƒ[‚_fQ @‚h ‰M …IG nL„km. †w‚oa[.",
 1,"‡i„Q ‚kKLM. †KƒP„Q ‚kKLM.",
 10,"‰q †rS [Q B †w‚oa[. †nƒ{ƒm„S ‰Bn^ „KŠW ‹]‚V[.");
 PlayBGM(5);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<»Øµ½Úş³Ç¹ÙÛ¡£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 else
talk(10,"…M! „A„AŠWD jFa‚b‚T. ‡mƒv ƒ[‚_‚b ‚Su„Zm. Q „O†sŠm, G ƒNƒP ‚a‚b mjS ˆn‚Sƒ_ ƒcS ŠP‚f.");
 PlayBGM(4);
 DrawMulitStrBox("¡¡‚G‚P‚b …GRS ‡iPƒd,*¡¡oNƒP ‚n‡nS „C†juƒ`ŠB ƒ[ƒP ‹dD ‰HŠ_ ƒ~…eƒFM.");
 --ÓÎÏ·Ê§°Ü:
 NextEvent(999); --Goto 999
 end
 end
 end,
 [231]=function()
 if JY.Tid==51 then--¾ÚÊÚ
talk(51,"‚K‚J¡­¡­");
 end
 if JY.Tid==93 then--¹ùÍ¼
talk(93,"ƒv‚h …{…I q‚b ‚am. ‚o„XG ‚SŠS I‚XƒP IƒafQ ƒ[u ‡@Q ƒq…I …x†ym?");
 end
 if JY.Tid==53 then--ÎÄ³ó
talk(53,"n, ‚G‚P. nY ƒ[‚_‚h ƒP†do …I †w‚oa[.");
 end
 if JY.Tid==55 then--·ê¼Í
talk(55,"‚K‚J¡­¡­");
 end
 if JY.Tid==103 then--ÕÅàA
talk(103,"‚SZ^ ‚^…x…Bƒ~Šp‚wƒ`. †dƒG ˆ~G†y‚CZ? †KƒP„Q …X‡I‚V[.");
 end
 if JY.Tid==92 then--ÉóÅä
talk(92,"‚K‚J¡­¡­");
 end
 if JY.Tid==10 then--Ô¬ÉÜ
 JY.Status=GAME_SMAP_AUTO;
talk(10,"†nƒ{ƒm„S ‰Bn^ „KŠW ‹]‚V[.");
 MovePerson(1,9,2);
 NextEvent();
 end
 end,
 [232]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=10;
 AddPerson(1,3,20,0);
 AddPerson(64,16,10,3);
 AddPerson(83,14,11,3);
 AddPerson(82,12,12,3);
 SetSceneID(77);
talk(64,"‚K‚J, ƒ@‚rhLM. „Nƒg m‚yG c‹HŠB †wc{ †w„NG ŠXKLM.");
 MovePerson(1,6,0);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÓëËïÇ¬µÈÌ¸ÂÛ½ñºóÖ®ÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [233]=function()
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ƒ@‚rhLM. „Nƒg m‚yG c‹HŠB †wc{ †w„NG ŠXKLM.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"…fŠsD ƒ[ ‰jˆlfƒW Z‚]ŠW †jn…gƒtKLM. ‚K‚JŠ_ƒW G‡Ef „T‚VM‚b ˆ|S Š^ƒd ‹qnŠXKLM.");
 end
 if JY.Tid==83 then--¼òÓº
 JY.Status=GAME_SMAP_AUTO;
talk(83,"‚K‚J, …Xƒlƒ_ ‹pKLM. ‡q…h eƒOŠiƒb ‚o „T‡ILY?",
 1,"‚aM„p. ƒ[ ‡D„S m‚yG c‹H„p.",
 83,"ƒ[ŠQKLY¡­¡­ Nƒb [‚b †rf vvƒP g~fƒW eƒOŠiS ]ƒb …x‚h ƒsƒtKLM. ƒ[„U‚b E…X PKLM„V, ƒ[ŠQMA ƒ[…x^ eƒOŠi…I ^ƒMƒ{G TLM.",
 1,"ƒ[ŠQMA nY ƒQm^ o ˆ|G ‚rN…I‚CD ‚Z‚j†y‚wƒv.",
 83,"I‡H …IG[?",
 1,"Nƒb nY ƒQm^ ƒv‚h …GGƒ` PM. ‚o„XG eƒO‚h ]ƒb IƒafQ ƒqŠbM‚b ƒuGM.",
 83,"ƒ[ŠQ‚TZ. ‡q…h ƒQm^ „l ^r‚C‚b ‚kƒtKLY?",
 1,"ƒ[`…f` Še…e‚_ „|‹HM„V, ‚_…r ‚SŠS ˆY …I…IY.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [234]=function()
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚o„XG ƒqj …I ˆ|hLM„V, …f‚b eƒOŠiG ‹G ƒuG‚f ‹bLM.");
 end
 if JY.Tid==82 then--ÃÓ·¼
 JY.Status=GAME_SMAP_AUTO;
talk(82,"„i? ‚K‚J, ‚r…xj ‡KWLM.");
 AddPerson(365,3,20,0);
 MovePerson(1,0,1);
 MovePerson(365,5,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"d^ ‹N‹NŠW ƒs‚C‚b ˆfPƒmL eƒOŠiG aMƒd †MˆAa‚C‚b ˆfa†yKLM.");
 end
 end,
 [235]=function()
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‡O ƒQm^ ƒsˆZ …x†y‚C. G‚W‰` I‡H …I…IY.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"‚K‚J, ‚r…xƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚K‚J, ƒO…m ‚r…xƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==365 then--Ê¹Õß
 JY.Status=GAME_SMAP_AUTO;
talk(365,"…f‚b ‚K‚J ƒQmŠ_ƒW ƒsˆZ ‚r…xhLM. †e…X ‰jˆlfƒW …Z…c^ ƒLfQ …G„kKLM. ‚K‚JŠ_ƒW‚b ‚Cƒg †nƒ{ƒm„S ‰Bn[ŠVƒm†B ‚G‚PŠiŠ_ …R…IG „Oƒm‚VL ‚SƒW †nƒ{ ƒP‚r‰Rƒm„S [‡I‚V[. ƒ[†{ ƒA…e^†yKLM.");
 MovePerson(365,8,1);
 DecPerson(365);
talk(64,"‚o„Xf G‚S G‚W‰` …Z…cY‚C …G„k‚TZ. …Z…c‚b ‚o„XƒsM ‚IPM WLM. ƒ[‹@ IƒaS ‚{ q „O‚b …x‚fA n…XD¡­¡­",
 1,"eƒOŠiŠFG†y‚CZ.",
 64,"‚K‚J, ƒQm^ ‚^‡M YVƒb ‚C‚q‚W{ „GS ƒuhLM. ‡O ƒ[ IƒaG eƒOŠiS ]ƒtM‚b G…EƒG†y‚CZ. QM^ ƒ[ Iƒaƒb nI†GD eƒOŠi…I ƒuhLM.",
 1,"ƒvD ƒ[u `‚EoM.",
 64,"‡mƒv eƒOŠiG‚f jFaA ƒ[ b‚h ‚K‚JŠ_ƒW ‚CŒs…E WLM. ‚Cƒgƒb vvƒP ‚M‚Z‚f a‚V‚b „KG ‹oKLM. eƒOŠiD I‡H ‚rFG „O‚S vv‚h ‰I‚b ƒu…I q „OKLM.",
 1,"„a†yM. ƒ[†{ ƒQmfQ o ‚W „l MˆQ[…X.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ÒéÊÂÌü¼ûÔ¬ÉÜ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [236]=function()
 if JY.Tid==64 then--ËïÇ¬
 JY.Status=GAME_SMAP_AUTO;
talk(64,"‚K‚J, ‚^ƒZ ‚EŠZŠW v†da‡I‚V[.");
 MovePerson(1,9,1);
 NextEvent();
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"…fŠs‚b bƒGƒW ‚K‚JS ƒGMu†yKLM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‡q…h eƒO‚b ‚SŠSab vv‚h ‰I‚b ƒu…IY.");
 end
 end,
 [237]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=10;
 AddPerson(10,10,17,0);
 AddPerson(93,10,9,3);
 AddPerson(103,12,8,3);
 AddPerson(106,14,7,3);
 AddPerson(51,24,17,2);
 AddPerson(55,26,16,2);
 AddPerson(92,28,15,2);
 AddPerson(1,33,5,1);
 SetSceneID(83,11);
 DrawStrBoxCenter("†nƒ{ ƒP‚r‰R");
talk(10,"ŠX‚T, G ‚rƒG‰[! G‚W‰` ‚[ ‚W M‚V …{‚C ‚k†ym.");
 MovePerson(1,8,1)
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [238]=function()
 if JY.Tid==51 then--¾ÚÊÚ
talk(51,"G‚W‰` _ca‚C …X‚V[. ƒvD ‚[ „Iƒm„S ƒsƒtm.");
 end
 if JY.Tid==93 then--¹ùÍ¼
talk(93,"G‚W‰` …Z…c^ …G„km. G ‡YNS ‚SŠS ‹y†ym? …R„Vo ‚wƒ@†Eu„S‚T.");
 end
 if JY.Tid==55 then--·ê¼Í
talk(55,"G ‚rƒG‰[! ‚V„Q†w aƒv‚b ŠU Œl‚b‚wƒv!");
 end
 if JY.Tid==92 then--ÉóÅä
talk(92,"G ‚rƒG‰[! ‚V„Q†w aƒv‚b ŠU Œl‚b‚wƒv!");
 end
 if JY.Tid==103 then--ÕÅàA
talk(103,"G ‚rƒG‰[! ‚V„Q†w aƒv‚b ŠU Œl‚b‚wƒv!");
 end
 if JY.Tid==106 then--´¾ÓÚÇí
talk(106,"G ‚rƒG‰[! ‚V„Q†w aƒv‚b ŠU Œl‚b‚wƒv!");
 end
 if JY.Tid==10 then--Ô¬ÉÜ
 JY.Status=GAME_SMAP_AUTO;
talk(10,"‚G‚P, †@} vv‡z ƒ_„wP‚wƒ`! …Z…cY‚C …GŠbƒmL jFa‚V[. ƒ[ IƒaG eƒOj‚C n†m‚C.");
 local menu={
 {" ‚n…UaM, ˆGnƒv…x",nil,1},
 {" vvƒP „T‚vhLM",nil,1},
 {" ¡¡eƒO^ n‚`LM",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
 MovePerson(1,2,0)
talk(10,"‚G‚P, ˆGnƒvƒ`†sŠm! †u^ …f †cƒN…x‚h ‚_ƒN ƒq‚S [†y†sŠm!",
 103,"d^ ^†yKLM!");
 MovePerson(103,2,0);
 MovePerson(103,4,3);
 MovePerson(103,0,1);
talk(103,"†cƒN…x! H‚b …Gƒb ƒc…~GM.",
 1,"…v¡­¡­!");
 DecPerson(1);
 PlayBGM(4);
 DrawMulitStrBox("‚G‚P‚b …GRS ‡iPƒd, oNƒP ‚n‡nS „C†juƒ`ŠB ƒ[ƒP ‹dD bƒGƒW ƒ~…eƒFM.");
 --ÓÎÏ·Ê§°Ü:
 NextEvent(999);
 elseif r==2 then
talk(10,"I‡JG? vvƒP „T‚vG‚fƒd?",
 1,"ƒ[ŠQKLM. vv‚b d^ G g~f „O‚MS „aƒd …I‚^…e eƒO„S abƒg ‚o„X{ …Z…c‚h ƒqQ o ƒuhLM. ‡iƒNƒP ‡YS Œfƒ` …f‚h …GGƒ`‚b qJG‚CZ. ‚^ƒZ …f‚h †Yo ƒP†dS †E‚[‚S ‚K‡I‚V[.",
 10,"‡m¡­¡­ vv‚b {…B „Wˆda‚wƒ`. ‚G‚P, †w‚oa[. a…XƒhA vvƒP „T‚vf ‚@„u ŒPPm.",
 51,"‚K‚J! ‚G‚PƒP ‡NˆAGES ˆ[‚C …X‡I‚V[.",
 93,"ŒRKLM. …f‹@ …xƒP ˆ|S ˆ[‚SƒW‚b ‚o ŒjLM.",
 10,"‰xmu ˆ|‚f! ƒ[‚_ƒRƒb ƒ_Q ‚G‚P‚h …GG‚f‚b ƒuGŠm! ƒd‡Co ƒuƒR! Še M ƒA…e^‚f!",
 51,"‚K‚J¡­¡­");
 MovePerson( 51,9,0,
 93,9,0);
 DecPerson(51);
 DecPerson(93);
 PlayBGM(5);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚ¹ÙÛ¡ÓëËïÇ¬µÈÌ¸ÂÛ½ñºóÖ®ÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 else
talk(10,"‰umu! G‚W‰` …fq^ ^YGƒW „L‰n ƒsƒtm. G ƒn ‚rƒG‰[S ˆn‚Sƒ_ ƒcS ŠP‚f.");
 PlayBGM(4);
 DrawMulitStrBox("ƒ[uab ‚G‚P‚b …GRS ‡iPƒd, oNƒP ‚n‡nS „C†juƒ`ŠB ƒ[ƒP ‹dD ƒ~…eƒFM.");
 --ÓÎÏ·Ê§°Ü:
 NextEvent(999); --Goto 999
 end
 end
 end,
 [239]=function()
 if JY.Tid==10 then--Ô¬ÉÜ
 JY.Status=GAME_SMAP_AUTO;
talk(10,"‚G‚P, …BG‚S ‚[ ‚WGƒv ƒP†dB †~ƒm„S †w‚oa[. ‚SƒW e…f„S ‰Bn^ ‹]‚V[.");
 MovePerson(1,10,0);
 NextEvent();
 end
 if JY.Tid==55 then--·ê¼Í
talk(55,"‚SZ^ ‹I‡D^ ŠG‚C ‚kƒmƒv ƒ[ˆ} „|‚S^‚C.");
 end
 if JY.Tid==92 then--ÉóÅä
talk(92,"‡m, vvƒP „T‚vG‚f. ƒ[ƒuG ‚rNj^?");
 end
 if JY.Tid==103 then--ÕÅàA
talk(103,"‚SZ^ ˆ|G „C‚C ‚kƒmƒv, ‡m, ƒ[ˆ} „|‚S^‚C.");
 end
 if JY.Tid==106 then--´¾ÓÚÇí
talk(106,"‚SZ^ ˆ|G „C‚C ‚kƒmƒv, ‡m, ƒ[ˆ} „|‚S^‚C.");
 end
 end,
 [240]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=10;
 AddPerson(1,3,20,0);
 AddPerson(64,16,10,3);
 AddPerson(65,14,11,3);
 AddPerson(83,12,12,3);
 AddPerson(82,10,13,3);
 SetSceneID(77);
talk(64,"[, ‚K‚J. I‚ra‡ILY. n, †wcG ‰BnŠXKLM.");
 MovePerson(1,6,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [241]=function()
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, †wcG ‰BnŠXKLM. ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==65 then--ÃÓóÃ
 JY.Status=GAME_SMAP_AUTO;
talk(65,"‚K‚J, ‰BnŠXKLM. eƒOŠiƒb vvƒP g~f „TŠVKLM. ‚SŠq‚ru …BˆyG ‹fƒtƒd, ‚Cƒg ‡m†gS ‹Xƒv Gu„S [ƒd „T‡ILM.",
 1,"[, ƒ[‹@^.",
 65,"‡Oo ƒa‚PŠiƒb bƒGƒW ƒ[u d‚C ‚kƒb …g‹J ƒdƒ{f „TƒNM WLM. „[ƒL Iu‡z ‰HŠ_ „TƒNM‚b…h …Bˆyƒb ‹f‚C ˆfPKLM.",
 1,"ƒ[‹@^. ƒa‚PD I‚ra‚wƒv.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"‚K‚J, d ˆEG ‰BnŠXKLM. ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚K‚J, †wcG ‰BnŠXKLM. ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 end,
 [242]=function()
 if JY.Tid==64 then--ËïÇ¬
 JY.Status=GAME_SMAP_AUTO;
talk(64,"‚K‚J, eƒOŠi{ ƒa‚PŠiƒP m‚yS „aƒtƒmL „l‚b G‡Ef ŠcƒA YVG ‚aKLM. ƒQmfQ‚b ƒ[ƒP ˆmj b…gƒm„S …yM Še…e‚_ƒd, ƒa‚PŠiG „TƒN ƒdƒ{ƒm„S ^‚V‚CZ. ‚SƒW ƒQmfQ ‰Ra‡I‚V[.",
 1,"ƒ[…e‚CZ.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"eƒOŠiG Gu„S [ƒd „T‚Vƒv vv^ …A…w‚V „NBX ƒuhLM. ƒvn^ ŠGGa‚b „KG Šo†yKLM.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"G‹@ ‡Ef [†G ŠcƒA q‚b ‚a‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"eƒOŠiD ƒa‚PŠiD †jn „T‚VML. †~ƒm„S ŠU‹kKLM!");
 end
 end,
 [243]=function()
 if JY.Tid==64 then--ËïÇ¬
 JY.Status=GAME_SMAP_AUTO;
talk(64,"…fŠs‚b bƒGƒW ƒGMu†yKLM.");
 MovePerson(1,9,1);
 NextEvent();
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"…fŠs‚b ‚Cƒg …b_ ƒe‚P‚h a†yKLM.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"G‹@ ‡Ef [†G ŠcƒA q‚b ‚a‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"eƒOŠiD ƒa‚PŠiD †jn „T‚VML. †~ƒm„S ŠU‹kKLM!");
 end
 end,
 [244]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=10;
 AddPerson(10,10,17,0);
 AddPerson(93,10,9,3);
 AddPerson(92,12,8,3);
 AddPerson(106,14,7,3);
 AddPerson(51,24,17,2);
 AddPerson(55,26,16,2);
 AddPerson(103,28,15,2);
 AddPerson(1,33,5,1);
 SetSceneID(83);
talk(10,"n, ‚G‚P. I‡H …IG[?");
 MovePerson(1,8,1)
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [245]=function()
 if JY.Tid==51 then--¾ÚÊÚ
talk(51,"‚G‚P, G‚W‰` I‡H …IG[?");
 end
 if JY.Tid==93 then--¹ùÍ¼
talk(93,"‚G‚P, G‚W‰` I‡H …IG[?");
 end
 if JY.Tid==55 then--·ê¼Í
talk(55,"‚G‚P, I‡H …IG[?");
 end
 if JY.Tid==92 then--ÉóÅä
talk(92,"‚G‚P, I‡H …IG[?");
 end
 if JY.Tid==103 then--ÕÅàA
talk(103,"‚G‚P, I‡H …IG[?");
 end
 if JY.Tid==106 then--´¾ÓÚÇí
talk(106,"‚G‚P, I‡H …IG[?");
 end
 if JY.Tid==10 then--Ô¬ÉÜ
 JY.Status=GAME_SMAP_AUTO;
talk(10,"‚G‚P, I‡H …IG[?",
 1,"vv‡zƒP ‰jˆlf G„S‡S „N‚uS aƒv `‚EB „jKLM.",
 10,"I‡JG[? ‚S†A „N‚uG[?",
 1,"FAƒm„S„V ŠGŒEƒmA ƒOu ‹J ‡YND TLM. ab …I‚^ ‚~ƒ}S b…gƒm„S ƒsƒ_ vv‚TƒP †c…C‚h „Q‚b ƒuG Šo†yKLM.",
 10,"Šom! ƒ[uaA vv‚h †o‹JfƒW ‰G‚Ja‚b ˆEƒo^ „C‚C ‚k†ym?",
 1,"ƒ[ŠQKLM. ƒ[ RI‚h dQ ŠE„} ‚K‡I‚V[.",
 10,"‚G‚P, ‚SŠSab ƒ[‹@ ƒdˆY …IS …x‰Ra‚b ƒuG[?",
 1,"vvƒP g~f eƒO‚h ]ƒb IƒaG „OM aL, G ƒG‚}f gCS eŠWƒd…x ‰HhLM.",
 10,"Šom. ƒv‚b ƒ[‚_‚h ˆ[ƒmƒv n„L ƒ[‚_‚h ˆ[‚C ˆfa‚b ‚^aƒRD „Om. „a†ym, ƒ[uW‚VM.",
 1,"ƒdŠOKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×¼±¸È¥¹Å³Ç£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [246]=function()
 if JY.Tid==51 then--¾ÚÊÚ
talk(51,"qCa‚T¡­¡­");
 end
 if JY.Tid==93 then--¹ùÍ¼
talk(93,"qCa‚T¡­¡­");
 end
 if JY.Tid==55 then--·ê¼Í
talk(55,"‚G‚P, „@ƒ_‚V[!");
 end
 if JY.Tid==92 then--ÉóÅä
talk(92,"‚G‚P, ŠUB ƒs‚V[!");
 end
 if JY.Tid==103 then--ÕÅàA
talk(103,"‚G‚P, ŠUB ƒs‚V[!");
 end
 if JY.Tid==106 then--´¾ÓÚÇí
talk(106,"‚G‚P, ŠUB ƒs‚V[!");
 end
 if JY.Tid==10 then--Ô¬ÉÜ
 JY.Status=GAME_SMAP_AUTO;
talk(10,"ƒ[†{ ‚^…aa[.");
 MovePerson(1,10,0)
 NextEvent();
 end
 end,
 [247]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=10;
 AddPerson(1,3,20,0);
 AddPerson(64,16,10,3);
 AddPerson(65,14,11,3);
 AddPerson(83,12,12,3);
 AddPerson(82,10,13,3);
 SetSceneID(77);
talk(64,"‚K‚J, ‰Bn[ŠV‚TZ.");
 MovePerson(1,6,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [248]=function()
 if JY.Tid==64 then--ËïÇ¬
 if talkYesNo( 64,"…b_a‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(64,"ƒLƒP K‚pS …HS‚C ‚Z‡MM. ‚_‚AS ‹s‹t‚f.");
 ModifyBZ(54,({[1]=2,[4]=5,[7]=8,[10]=11,[23]=24})[JY.Person[54]["\177\248\214\214"]] or JY.Person[54]["\177\248\214\214"])--ko 4.0: tier-1 class goes up one step (original ê²½ê¸°ë³‘ -> ì¤‘ê¸°ë³‘); a class changed while he was a guest is kept;
 LvUp(54,7);
 WarIni();
 DefineWarMap(16,"d2ƒa …B‚K ‚B„e","1. ‡jD ‚p…D*2. ‚G‚P^ ƒW…g ƒ{…^ DˆG",45,0,92);
 -- id,x,y,d,ai --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,10,5,4,0,-1,0,
 -1,11,5,4,0,-1,0,
 -1,10,4,4,0,-1,0,
 -1,10,6,4,0,-1,0,
 -1,9,3,4,0,-1,0,
 -1,9,5,4,0,-1,0,
 -1,9,6,4,0,-1,0,
 -1,12,3,4,0,-1,0,
 -1,12,4,4,0,-1,0,
 53,29,7,3,0,-1,1,
 });
 ModifyForce(54,1);
 DrawSMap();
talk(64,"…b_a‚V‚CZ.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚SƒW eƒOŠi, ƒa‚PŠi{ W]a‚V‚CZ.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"ƒ[†{ ƒdƒ{ƒm„S †Ya‚V‚CZ. ‡q…h ‚K‚J, ‚~ƒG …}ƒb M …XƒxaŠVKLY?");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"ˆAdˆe …b_X q „OKLM. ‚K‚JŠ_ƒWD ƒe‚PB ‚K‡I‚V[.");
 end
 end,
 [249]=function()
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=10;
 AddPerson(93,10,9,3);
 AddPerson(92,12,8,3);
 AddPerson(51,24,17,2);
 AddPerson(55,26,16,2);
 SetSceneID(83,11);
talk(93,"‚G‚P‚h ‡N‚VD ‚aG …X‚M‚_„S b…gf ƒsƒ_ƒN†M ˆ|hLY?",
 55,"ƒ[ŠQKLM! ‚K‚JŠ_ƒW‚b ‚SŠS …f‹@ …x‚h ˆ[ƒm‡ILY?",
 51,"‡mƒv vv^ „O‚b …X‡if ‚G‚P^ ‚K‚JS †cƒNoƒR vvf ‚PaA ‚_q„B‚C ‚km. OFX ƒu ‚am. ˆGnƒv†yMA ˆGnƒv‚f‚C, [ŠWƒ` ƒ{^†dG fa[.",
 92,"‰q…f vv‚h „_ƒd, ƒ[ ‡Df ‚G‚P^ †cƒNa†Eˆe ƒ[„U ƒq‚SD ‹z‚C ‚km.",
 93,"¡­¡­ƒ[ŠQMA ƒv ‚c…xƒW‚fD ‚G‚P‚h ‹Kn ƒq†ym. ƒv‚b ‚G‚P‚h ˆ[‚C ‚km.",
 55,"‡m, …X‚M‚_„S a‚V[.",
 93,"…M!");
 --ÈËÎïĞĞ¶¯:[¹ùÍ¼]ÒÆ¶¯µ½×ø±ê<3,17>³¯Ïò<ÏÂ>
 NextEvent();
 end,
 [250]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(65,"ƒa‚PŠiG „TƒN ƒdƒ{ƒm„S ^‚V‚CZ. ƒdƒ{ƒb bƒGƒW …g‹JhLM.",
 1,"‡m, ƒa‚P^ †~ƒm„S ƒsƒd Š]‚wƒv.");
 SetSceneID(0,11);
talk(93,"‚G‚P‚h ‹Kn‚f. †@ŠH ‹^ŠPƒW‚b ‚o ˆYM.");
 PlayWavE(11);
 DrawStrBoxCenter("‡jD^ Gˆa‚b ‚Tf ‚i‚f‹Q…TM!");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 92,0,7,4,3,26,2,0,0,-1,0,
 256,7,19,4,4,19,2,11,13,-1,0,
 257,2,4,4,3,19,2,0,0,-1,0,
 258,1,6,4,3,19,2,0,0,-1,0,
 292,1,9,4,1,19,8,0,0,-1,0,
 293,3,5,4,3,19,8,0,0,-1,0,
 328,0,8,4,1,19,13,0,0,-1,0,
 274,3,6,4,3,19,5,0,0,-1,0,
 275,2,5,4,3,18,7,0,0,-1,0,
 310,2,8,4,3,19,11,0,0,-1,0,
 336,8,19,4,4,19,15,11,14,-1,0,
 337,2,7,4,3,18,15,0,0,-1,0,
 102,1,7,4,3,23,22,0,0,-1,1,
 50,7,19,4,3,23,5,0,0,-1,1,
 ---
 294,7,18,4,1,19,8,0,0,-1,1,
 295,8,0,4,3,18,8,0,0,-1,1,
 296,2,6,4,3,19,7,0,0,-1,1,
 259,6,19,4,1,19,2,0,0,-1,1,
 260,9,0,4,3,18,2,0,0,-1,1,
 276,7,1,4,3,19,5,0,0,-1,1,
 277,6,2,4,3,18,4,0,0,-1,1,
 278,2,5,4,1,19,5,0,0,-1,1,
 311,8,19,4,3,19,11,0,0,-1,1,
 312,0,7,4,1,18,10,0,0,-1,1,
 329,0,8,4,1,19,13,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [251]=function()
 PlayBGM(11);
talk(93,"…M, ‚G‚PƒP …{gƒb G†w iŒC„kM. ‚G‚P, ˆGnƒS `‚Eƒb …X‚f.",
 64,"‚K‚J, …fƒuƒb ‡jDƒP ‚^‚_hLM. _‚EˆY ‡KWLM.",
 65,"bƒGY‚C ‡zƒW ‹Qh q‚b ‚aKLM. ‚K‚JŠ_ƒW‚b ‰q…f ƒW…g‹J ƒ{…^„S ‰Xa‡I‚V[. ƒ[‡Ef G‚jA ‡jDD ‡Y„P q ‚aKLM.");
 WarShowArmy(54-1);
talk(54,"…f‡Lƒb ‚G‚U†fG n†m^? aƒXG †j‰XŠV‚wƒv. G‹@ ‡EfƒW i „{G…E¡­¡­ ‹KƒGƒd „TƒN ‡KaM. ŠoM, ‚Cƒg ^ƒW D‡z …wu†yM.");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [252]=function()
 if WarMeet(54,103) then
 WarAction(1,54,103);
talk(54,"ƒaWG n†m^?",
 103,"ƒ[‚_‚b v‡SG„S‚T. ‚J‡Y‡Zƒb G†w …G„kƒmL ƒ[‚_D ƒQmfQ ‡g‚Da‚b „KG ‹o†ym.",
 54,"ƒ_^ G†w …}g …x‚h †u^ M‚V ‚i‚j†ym? ƒQm^ ‚S†A jƒAj‚C ƒ[‚_D ˆAŒW^ „aQ Š} ƒuG[¡­¡­",
 103,"I‡JG? G CY†L †K „Gƒb …x, ‰umu‚h ƒX‚S‹^‚b‚T. ‚J‡Y‡ZfQ ƒsƒ_ ‚K…X!");
 if fight(54,103)==1 then
talk(103,"{…B ‚Xƒ{ ƒ[‚_„S‚wƒv!",
 54,"ƒ[‚_ ‡Oo „V„V„Q ‚km.",
 103,"¡­¡­G‚W‰` ƒA…eƒv ‚K†ym. M‚V „VƒvQ Š} ƒuG[, v‡S!");
 WarAction(16,103);
talk(54,"…f‹@ jƒAG ƒQm‚h ‚i‚jML †~ƒm„S n‡P‚wƒv!");
 WarLvUp(GetWarID(54));
 else
talk(103,"…Hn‚f!");
 WarAction(8,103,54);
 WarAction(17,54);
 WarLvUp(GetWarID(103));
 end
 
 end
 if (not GetFlag(1018)) and War.Turn==5 then
talk(1,"„h? …fw ƒLƒP ƒQ‚Tj^!? ‡O ŠX‚wƒv.");
 WarShowArmy(102);
 WarShowArmy(50);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(259);
 WarShowArmy(260);
 WarShowArmy(276);
 WarShowArmy(277);
 WarShowArmy(278);
 WarShowArmy(311);
 WarShowArmy(312);
 WarShowArmy(329);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM.");
talk(103,"‡jD, ƒGMuQ P‚wƒ`.",
 93,"[, ƒaW. ŠU ‡z ‚K„km. I‡H …IG „O‚SD ‚G‚P‚h ‹Qn…E a[.");
 SetFlag(1018,1)
 end
 if WarCheckLocation(0,19,3) then
talk(93,"‡m, ‚G‚P‚h bƒGƒW ‹^‡R‚wƒv. ‚K‚JŠ_ƒW ‚G‚PƒP Qf „|‚S^ŠVM. ‚_O„SM!");
 WarGetExp(50);
bonus_moneyexp_4()
 PlayBGM(7);
 DrawMulitStrBox("‚G‚P‚TG ‡jD‚TƒP …c‚pS ‚i‰B„~M.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end 
 if JY.Status==GAME_WARWIN then
talk(93,"‡m, ‚G‚P‚h bƒGƒW ‹^‡R‚wƒv. ‚K‚JŠ_ƒW ‚G‚PƒP Qf „|‚S^ŠVM.");
 PlayBGM(7);
 DrawMulitStrBox("‚G‚P‚TG G‹HM.");
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £·£°£°S ƒYƒC.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(11,18,55,191); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º²è
 WarLocationItem(7,20,65,192); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÕ¨µ¯(34) ¸ÄÎª Ôô±øÊÄÑÔ
 end,
 [253]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="…B‚K";
 JY.Base["D‚wC"]=0;
 AddPerson(1,8,18,0);
 AddPerson(64,11,11,3);
 AddPerson(83,13,10,3);
 AddPerson(65,21,17,2);
 AddPerson(82,23,16,2);
 AddPerson(54,31,6,1);
 SetSceneID(97,5);
 DrawStrBoxCenter("…B‚K ‡f‚r");
 MovePerson(54,6,1);
talk(54,"‚G‚U†f, [ˆs„VhLM.",
 1,"ƒv ‡Oo ƒ[‚_‚h „Vƒv ƒGŒ}[. ‡q…h ‚SŠS bƒGY‚C ŠXm?",
 54,"‚J‡Y‡ZŠ_ƒW OaƒN ‡D„S „{‰b ‹XD‚b ƒNƒoŠbKLM. †Z†G ƒdƒ{f ƒa‚PŠiG „T‚VM‚b m‚yS Š^ƒd, ƒ[u ^A ‚U†fS i q „Oƒmu‚f b‹HKLM.",
 1,"ƒ[ŠQm?",
 54,"‡q…h eƒO Šiƒb ‰HŠ_ „T‚V‚C ‚kƒtKLY?",
 1,"ƒ[ƒuG¡­¡­",
 54,"ƒ[ŠQKLY¡­¡­",
 1,"‡iƒaƒb nL‚SD ˆAŒW^‚b …A…w‚V eƒO‚h „VƒvQ Š} ƒuG[. ƒ[†{ ƒO…m ƒa‚PfQ ^ ‹b‚VM.",
 54,"Gd‚^ƒh …fD ‡iƒNƒP ‚^ahLM. ‚G‚U†f, ŠU ‚^…a…w„tLM.");
 PlayWavE(11);
 DrawStrBoxCenter("v‡SG ‚G‚PƒP ‚^a^ „C„kM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥¹Å³Ç£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [254]=function()
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚G‚U†f, ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
 if talkYesNo( 64,"‚SƒW ƒdƒ{ƒm„S ^‚V‚CZ.") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==65 then--ÃÓóÃ
 if talkYesNo( 65,"v‡SY‚C …V„kƒmL ‚SƒW ƒdƒ{ƒm„S ^‚V‚CZ.") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==82 then--ÃÓ·¼
 if talkYesNo( 82,"‚K‚J, ƒdƒ{ƒm„S ^‚V‚CZ.") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==83 then--¼òÓº
 if talkYesNo( 83,"‚K‚J, ‡O …c‚p‚~G ƒi‚C ‚Z‹{LM. ‚SƒW ^‚V‚CZ!") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [255]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(1,"ƒ[†{ ƒa‚P‚h „Vƒv…e ^…x.",
 65,"k, ƒdƒ{ƒb bƒGƒW …g‹Jƒm„S Œv…X ^‚C ‚kn „OKLM. ‚SƒW ^‚V‚CZ.");
 SetSceneID(0);
talk(1,"I, I‡JGŠm?",
 83,"I‡JG! DƒL ŒlM!",
 64,"a„s G‹@ „Uf DƒLG‚fL. ‚K‚J, ŠGƒW ‰jƒO‚V‚CZ.",
 1,"‚_‚AS ‹s‹t‚f.");
 WarIni();
 DefineWarMap(17,"d2ƒa ƒdƒ{ ‚B„e","1. £¿£¿£¿‡z „W‚B",40,0,373);
 -- id,x,y,d,ai --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,12,11,4,0,-1,0,
 -1,11,12,4,0,-1,0,
 -1,13,12,4,0,-1,0,
 -1,12,13,4,0,-1,0,
 -1,13,13,4,0,-1,0,
 -1,11,10,4,0,-1,0,
 -1,12,10,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 373,10,23,2,2,23,8,0,0,-1,0,
 310,9,21,2,0,19,11,0,0,-1,0,
 311,17,9,3,1,18,11,0,0,-1,0,
 312,18,10,3,1,18,11,0,0,-1,0,
 313,16,16,3,1,16,11,0,0,-1,0,
 314,15,17,3,1,15,10,0,0,-1,0,
 315,3,8,4,1,15,10,0,0,-1,0,
 316,3,15,4,1,16,11,0,0,-1,0,
 332,13,3,1,1,20,14,0,0,-1,0,
 333,3,14,4,1,19,14,0,0,-1,0,
 336,9,22,2,0,18,15,0,0,-1,0,
 337,14,3,1,1,18,15,0,0,-1,0,
 338,4,7,4,1,17,15,0,0,-1,0,
 });
 ModifyForce(374,0);
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [256]=function()

JY.Person[374]["±øÖÖ"]=JY.Person[3]["±øÖÖ"]
local bzid=JY.Person[3]["±øÖÖ"]
for id=1,War.PersonNum do
if War.Person[id].id==374 then
 War.Person[id].bz=bzid;
 War.Person[id].movewav=JY.Bingzhong[bzid]["ÒôĞ§"]; --ÒÆ¶¯ÒôĞ§
 War.Person[id].atkwav=JY.Bingzhong[bzid]["¹¥»÷ÒôĞ§"]; --¹¥»÷ÒôĞ§
 War.Person[id].movestep=JY.Bingzhong[bzid]["ÒÆ¶¯"]; --ÒÆ¶¯·¶Î§
 War.Person[id].movespeed=JY.Bingzhong[bzid]["ÒÆ¶¯ËÙ¶È"]; --ÒÆ¶¯ËÙ¶È
 War.Person[id].atkfw=JY.Bingzhong[bzid]["¹¥»÷·¶Î§"]; --¹¥»÷·¶Î§
 War.Person[id].pic=WarGetPic(id);
end
end
JY.Person[374]["±øÁ¦"]=JY.Person[3]["×î´ó±øÁ¦"]
JY.Person[374]["²ßÂÔ"]=JY.Person[3]["×î´ó²ßÂÔ"]
for i=1,8 do
JY.Person[374]["µÀ¾ß"..i]=JY.Person[3]["µÀ¾ß"..i]
end

 PlayBGM(11);
talk(83,"‚K‚J, †a‚nˆY ‡KWLM.",
 1,"„i?!",
 374,"G …I‚_f vv‚TG ‡O ƒv…@ŠgM. vv‚TS o ŒND …gƒG‚C ˆ|ƒd ŠP‚f!",
 64,"…fƒuƒb¡­¡­! ‡q…h ‚SŠS ƒOu‚h …fu ŠG‚b†M ˆ|GŠm?",
 1,"†W‚Ej ‡KWLM. ƒOu‚h ƒLƒm„S bŒI Q ‡L‚XWLM. „Vƒv ƒsA „aQ „C†y‚CZ.",
 83,"„VƒvƒGD ‚Bf ƒc…~S ŒO†yKLM.",
 1,"¡­¡­ƒ[Šl qD „O†y‚wƒv. ‡mƒv ‚S‹cQˆe ƒa‚P‚h „Vƒv…E oM.");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [257]=function()
 if WarMeet(-1,374) then
 PlayBGM(15);
talk(374,"‚Sj‚C …f ‚r†vƒRG H…S‚wƒv. ¡­¡­n!",
 3,"G‰}‚f, Šz†KƒRn. …f ‚^‚_‚b ƒOu „KGM.");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(15);
talk(374,"G‹@, ‚_†Mo …x„S‚T! …f ‚_ƒaƒb †u‚wŠm? „i? ‚Sj‚C H…Sƒb…h? ¡­¡­n!!",
 1,"ƒa‚P, †~ƒm„S ƒsƒd Š]„kM. ‡q…h [ˆs„Vf „Vƒv ‚SŠS G‹@ ‚yƒm„S ƒOu‚h ŠG‚b QŠm?",
 3,"b, b‡pWLM. ˆEŠiƒRj „{ „aƒtMA gJ ƒv^ ŠGƒtS ‹|…hZ. G‰}‚f, Šz†KƒRn. …f ‚^‚_‚b ƒOu „KGM. ‚SƒW z‹t‚f.");
 PlayBGM(7);
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £·£°£°S ƒYƒC.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(22,15,156,193); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¹í¹È×Ó
 WarLocationItem(19,4,67,194); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÉ½±ÀÊé(36) ¸ÄÎªÒìÎÄ»¯Ó¡
 WarLocationItem(23,8,29,195); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÌØ¼¶¾Æ
 end,
 [258]=function()
 JY.Smap={};
 SetSceneID(0,5);
talk(3,"b‡pWLM. ‡O Œv„n†@f ‚Su„Zƒb ŒQS PKLM.",
 1,"‚C‚q …IGL „C„kM. ƒ[‚l‚o ‚SŠS ‚C„j†sŠm?",
 3,"G ƒ{S Šf„hn DƒLƒRS Gˆnƒd vv‚Tf ŠGƒWƒ` PKLM. ƒnˆEŠiG [N „{ƒb Œ{„g‚CZ. ƒnˆEŠi, b‡pWLM.",
 1,"ƒ[u „Y†da‚C …X‚f, ƒa‚P. H†C‚C ‚k‚wƒv.",
 3,"ŠoKLM. ‚SŒJˆe M‚V ‰HŠ_aQ „C„kƒmL, ‹Iƒm„SD ƒnˆEŠiS ‚i‚f ‹F„[Gˆe …dƒUMˆe …XMa‚C ‚k†yKLM.");
 LvUp(3,3);
 ModifyForce(3,1);
 PlayWavE(11);
 DrawStrBoxCenter("ƒa‚P^ M‚V ‚G‚P Pƒm„S ‰BnŠXM.");
talk(3,"ƒnˆEŠi, G ƒsŠUƒu‚a‚b ƒ{Gƒv…X ƒR‚S‡z ƒs‚V‚CZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚ¹Å³ÇÌ¸ÂÛ½ñºóÖ®ÊÂ£®>
 NextEvent();
 end,
 [259]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒdƒ{";
 JY.Base["D‚wC"]=0;
 AddPerson(1,25,17,2);
 AddPerson(3,22,10,1);
 AddPerson(54,20,9,1);
 AddPerson(83,18,8,1);
 AddPerson(64,11,16,0);
 AddPerson(82,9,15,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒdƒ{ ƒP‚r‰R");
 DrawMulitStrBox("bƒGƒW eƒOƒP ‚]ƒLS ˆ|B ‰QM. eƒO‚b †wcƒP ˆ|‚_„S vvƒP g~f „O„kM. ‚G‚P …I‚]G vvfQ OX IŠq eƒO‚b a‚PfƒW vv‚Tf †a‚n„C‚S „O„kƒd, ƒaUƒP …y‰Vo ‡b‚G„S vwS ‚@‚S vvfQ ‡g‚DPM.");
 DrawMulitStrBox("ƒ[ vwG‚d ‚G‚PƒP ‚]„NS „aQ „CA ‰bƒU„S ‚G‚PfQ ‰Bn…yM‚b ƒuG„kM. vv‚b G‚h …HnƒRŠbM.");
 DrawMulitStrBox("ƒ[ ‡D †wcG eƒOfQ ‚G‚PƒP ‚]„NS ‚BPM. eƒO‚b ‚G‚P‚h „Vƒvƒd…x ‰bƒU„S vvƒP g~S ‹XŠgƒd, D‚ef eƒw{ ‚K†gS „VŠgM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [260]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, eƒO ˆEŠiƒb ‚SŠS „C„kKLY? [, ¡­¡­ƒ[ŠQ‚TZ. ƒ[†{ ‚SƒW …b_a‚V‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‡iƒaG‚fD eƒO‚h „Vƒvƒd Š]‚wƒv.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"eƒO‚b ‚Cƒg ‚SŠS „C„kSY?");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"bƒGY‚C ŠXƒmL ƒQmƒP …c‚p‚~ƒb OFa‚C ‚knD ŒjLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
 JY.Status=GAME_SMAP_AUTO;
talk(64,"ƒO…m bƒGƒW ‚_[‚h F‚Po ‡D eƒO‚h ŠGƒm…e ^…x¡­¡­ ‚S? †wcG‚wƒv. I‡H …IGŠm?");
 AddPerson(65,1,5,3);
 MovePerson(65,7,3);
talk(65,"‚K‚J, ƒn…IhLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [261]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"†wc …f ‚r†vG ‚SŠS …fu ‡mŠ{‚_‚b^?");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"†h…xƒG I‡H …IG `‹H†sŠm?");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"†wcƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"†wcƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"‚K‚J, d ˆEƒP ˆ|S ƒR‚S ƒs‡I‚V[.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, ƒn…IhLM! vv‚TG Gu„S ‰bƒa [ƒd „OKLM. ‚Cƒg G†w ~‚sf G‚jŠjKLM.",
 1,"¡­¡­‚Cƒg ~‚sƒm„S ƒvn^ ŠG…mM. ‚B ƒa‚~ƒb …b_S ƒe‚Pa‚f.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×¼±¸Ó­»÷²Ü²Ù¾ü£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [262]=function()
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"…Xƒlƒ_ M‚V ‚K‚JS ‚nB ‰jƒOQ „C„kKLM. GƒsM ƒGk …IG ‚aKLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"vv‚TG bƒGY‚C [ML ƒ]‹wG‚TZ. ƒvn^ ŠG†b‚VM.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"eƒO^ n„L [‚C ‚kƒtƒmƒv ‚S‹W q ‚a‚wƒv.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚K‚J, ŠGƒW ‰jƒO‚V‚CZ!");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"‚K‚J, ŠGƒW ‰jƒO‚V‚CZ!");
 end
 if JY.Tid==3 then--ÕÅ·É
 if talkYesNo( 3,"ƒnˆEŠi, …b_a‚V‚CZ!") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [263]=function()
 PlayBGM(12);
talk(3,"ƒnˆEŠi, ‚SƒW ‚_‚AS ‹s…c‚V‚CZ.");
 LvUp(2,3);
 WarIni();
 DefineWarMap(18,"d2ƒa ~‚s ‚B„e","1. …^†o ˆL†U",30,0,152);
 -- id,x,y,d,ai --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,30,2,3,0,-1,0,
 -1,30,1,3,0,-1,0,
 -1,30,3,3,0,-1,0,
 -1,29,2,3,0,-1,0,
 -1,29,3,3,0,-1,0,
 -1,31,0,3,0,-1,0,
 -1,31,2,3,0,-1,0,
 -1,31,1,3,0,-1,0,
 
 1,1,1,1,0,-1,1,
 127,0,2,1,0,-1,1,
 154,2,0,1,0,-1,1,
 });
 DrawSMap();
 ShowScreen();
talk(3,"ƒ[†{ ŠGƒW ‰jƒO‚V‚CZ. ƒnˆEŠiS M‚V Œr„kƒmL †@ŠH ‚C‚C ‚kKLM.");
 ModifyForce(2,1);
 ModifyForce(128,1);
 ModifyForce(155,1);
 JY.Smap={};
 SetSceneID(0,3);
talk(65,"~‚sƒb G ƒdƒ{ƒP …g‹JhLM. ƒ[†{ ~‚sƒm„S ^‚V‚CZ.");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 152,2,13,4,0,25,2,0,0,-1,0,
 95,14,7,4,4,22,2,16,6,-1,0,
 96,3,13,4,0,21,2,0,0,-1,0,
 256,13,9,4,4,20,2,16,7,-1,0,
 274,3,12,4,0,20,5,0,0,-1,0,
 275,15,8,4,4,19,5,17,7,-1,0,
 276,9,10,4,0,18,5,0,0,-1,0,
 292,11,10,4,4,18,8,15,6,-1,0,
 293,7,11,4,0,17,8,0,0,-1,0,
 294,8,11,4,0,17,8,0,0,-1,0,
 310,12,8,4,4,20,11,18,7,-1,0,
 311,6,10,4,0,19,11,0,0,-1,0,
 328,9,12,4,0,19,13,0,0,-1,0,
 336,13,6,4,4,20,15,16,5,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [264]=function()
 PlayBGM(11);
talk(153,"…fƒuG ‚G‚P‚TG„S‚T. G …^†oG v tCS ƒLƒm„S |‚b ƒuG Œv…Xƒv ‚Su„Zƒb‚C „aQ B ‚K…X.",
 3,"ƒnˆEŠi, vv‚b [‚C ‚kƒb ‡KWLM.",
 1,"‡mƒv ƒa‚P, „N†dƒb ƒgƒAGM.",
 3,"k, „a†yKLM.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [265]=function()
 if WarMeet(2,153) then
 WarAction(1,2,153);
talk(153,"eƒO„S‚T. eƒO, v tCƒP ƒbƒp‚h Škƒd ‚G‚PfQ ‰Bn^ML. ƒ[…eƒdD ƒP‚h ‚eŠW bƒG‚b …x‚f a†y‚b^.",
 2,"ƒv‚b vv‡z †wu ‡CvPM. ˆEŠiG †jn „T†dS „aA ˆAdˆe ‹XƒS q „OMƒd. ƒ[‚_‚b vv^ ƒNƒP‚h …f„q„~M‚b ˆ|j^?",
 153,"I‡JG! ‡NŠW v tCS ‚ZŒTa†sŠm? ŠP‚f! eƒO, …A…w‚V „p ƒcS †E‚[†yM.");
 WarAction(5,153,2);
 if fight(2,153)==1 then
talk(153,"…Hn‚f!",
 2,"ƒc…~S ƒ_‹^n‚f!");
 WarAction(8,2,153);
talk(153,"…v!");
 WarAction(18,153);
talk(2,"¡­¡­‡Cv^ „O„kMƒd‚b aƒv ƒ[ƒP ‚^a‚h ƒqƒd ˆ|ƒt‚wƒv. G‚W‰` ƒ_^ vvfQ lS ƒFM.");
 WarLvUp(GetWarID(2));
 PlayBGM(7);
 DrawMulitStrBox("eƒO^ …^†oS ƒqƒd ‚G‚P‚TG tuPM.");
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £·£°£°S ƒYƒC.");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
talk(153,"…Hn‚f!");
 WarAction(8,153,2);
 WarAction(17,2);
 WarLvUp(GetWarID(153));
 end
 end
 if (not GetFlag(1019)) and War.Turn==8 then
 PlayBGM(12);
talk(153,"ƒ[‚_ƒRƒb †u‚wŠm?");
 WarShowArmy(2-1);
 WarShowArmy(128-1);
 WarShowArmy(155-1);
talk(128,"n„qŠi, …fƒGƒW ‰jˆlG ‰r‚S‚C‚b ‡KWLM.",
 155,"‚SƒZƒP ‚^‚_Šm?",
 2,"„i? …fƒuƒb¡­¡­ n, ˆEŠiG‚VM! ƒa‚PD „O‚wƒv. ƒm‚M¡­¡­ ‚Cƒgƒb ‡N‚}f mS „U^ nLM. G eƒO^ ‰jˆlf ƒv…mM. eƒw, ‚K†gƒb ƒv‚h ‚i‚j‚f.",
 128,"‚XS …HƒR†yKLM!",
 155,"k!");
 DrawStrBoxCenter("eƒO^ ƒv…@ŠgM.");
 PlayBGM(9);
 SetFlag(1019,1)
 end
 if JY.Status==GAME_WARWIN then
talk(153,"H, HŠsƒR¡­¡­ ƒ_ ƒQq‚b v tCŠ_ƒW …A…w‚V ‹yn ‚K‚Vu‚f. ƒmŒF.");
 PlayBGM(7);
 DrawMulitStrBox("‚G‚P‚TG tuPM.");
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £·£°£°S ƒYƒC.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 --WarLocationItem(13,7,37,78); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÉ½ºéÊé/¸ÄÎªÃÏµÂĞÂÊé
 WarLocationItem(13,7,5,78);
 end,
 [266]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="~‚s";
 JY.Base["D‚wC"]=0;
 AddPerson(1,8,18,0);
 AddPerson(2,16,14,1);
 AddPerson(128,30,6,1);
 AddPerson(155,32,7,1);
 AddPerson(3,11,11,3);
 AddPerson(64,13,10,3);
 AddPerson(83,15,9,3);
 AddPerson(54,21,17,2);
 AddPerson(65,23,16,2);
 AddPerson(82,25,15,2);
 SetSceneID(97,5);
 DrawStrBoxCenter("~‚s g~");
talk(2,"¡­¡­ˆEŠi, …Xƒlƒ_ ‹qƒtKLM. G eƒO, ˆuƒb vvƒP g~f „O„kƒmƒv …X‚Mƒb ƒX G‡Ef „O„kKLM. M‚V ‹pQ „CML ‹d„V „GKLM.",
 1,"¡­¡­eƒO, I‚raL M‚]GM. †~ƒm„S ŠU‹k‚wƒv. I‚rŠW ‰BnŠXƒmL. ‚N‚NˆU!",
 3,"¡­¡­eƒO ˆEŠi, …f ‚[ ‡Lƒb †u‚w‡ILY?",
 2,"[, †Po …X‚Mf ˆ|Š[…wu‚C ˆfPKLM. ˆEŠi, ‚[ ‚r†vS m†Ka†yKLM. G ŠLƒbG‚b eƒwG‚f a†B, G‚Wf j…BG ‹fn d †onƒRG „C„kKLM.");
 MovePerson(128,6,1);
talk(128,"…f‚b eƒwG‚f a†B eƒO ƒa‚TƒP †onƒRhLM. ŠU ‚^…a…w„tLM.",
 2,"G‹Jƒb ‚K†gG‚f a†B †J‚V j…BG ‹fn d ‚^a^ „C„kKLM. „v†G „[f †]†EaŠB DƒLG„kƒmƒv [‚b †rf †E‚[„kKLM.");
 MovePerson(155,6,1);
talk(155,"‚U†f, ‹pQ „C‚S ~‚HhLM. …f‚b ‚K†gG‚f WLM. o„U „[ƒL ƒYqS Pƒmƒv …X‚M„Vƒb nnWLM.");
 PlayWavE(11);
 DrawStrBoxCenter("eƒO^ ‚G‚P Pƒm„S ‰BnŠXM!");
 PlayWavE(11);
 DrawStrBoxCenter("eƒw{ ‚K†gG ‚G‚PƒP ‚^a^ „C„kM.");
talk(54,"‚Z‚[ ‰BnŠXƒmL †~ƒm„S ƒ@‚rhLM. ‡q…h ƒOu‚b ‚SƒZ„S ‡yYZ?",
 64,"bƒGƒW …g‹Jƒm„S ^A ˆE‚K‚f‚b ‡EG „OKLM. ‚G…qƒP ~‚ChLM.",
 1,"‚G…q‚f. ƒvD n‚b ‚r†vGM. ƒv‡z‚b „Gƒb TˆjG‚f X q „O‚C.",
 64,"‚G…qfQ ‰RB ˆE‚Kf ˆuS ŒEG‚b ƒuG ‚S‹c†yKLY?",
 1,"¡­¡­",
 64,"ˆE‚KƒP q‚^‚b †o†ohLM. ‚K‚J, †o†oƒm„S ^ ‚G…qfQ ƒP…aa‚V‚CZ.",
 3,"ƒ[w …Xˆm„Q ‚kKLM. ƒnˆEŠi, vvfQ ƒQq‚h ‹yƒm‚V‚CZ! b…gƒP ‚G…WG vv‡z ŠGƒWƒd „OM aL b…gƒm„S ^ ‰jƒO‚V‚CZ.",
 1,"¡­¡­‚SƒZ„S ^…E aƒv.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<¾ö¶¨½ñºó°²ÉíÖ®µØ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [267]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, vvfQ ƒQq‚h ‹yƒm‚V‚CZ! b…gƒP ‚G…WG vv‡z ŠGƒWƒd „OM aL b…gƒm„S ^ ‰jƒO‚V‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ‚SƒZ„S ‡yYZ?");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚K‚J, ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==155 then--ÖÜ²Ö
talk(155,"ƒGŒMG ‚K‚JS ‚i‚j†yKLM. …X‚MŠy ‚^ƒ` ‚K‡I‚V[.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ‚SƒZ„S ‡yYZ?");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚K‚J, ‚SƒZ„S ‡yYZ?");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, ‚SƒZ„S ‡yYZ?");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"‚K‚J, ‚SƒZ„S ‡yYZ?");
 end
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"FaŠVKLY?") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 DrawSMap();
 local menu={
 {"¡¡¡¡†o†oƒm„S …yM",nil,1},
 {"¡¡b…gfƒW vv‡z ‰j‡SM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
talk(64,"†o†oƒm„S ^‚V†yKLY? ƒ[†{ d^ ‚r…x„S ‰q…f ^†yƒmL ‚K‚JŠ_ƒW‚b ‡D‚i‚f [‡I‚V[.");
 JY.Smap={};
 SetSceneID(0);
talk(64,"‚K‚J, ‚G…q^ ƒOu‚h „^Q …AƒG†B ‚T…X‚h F‚Pa‚b …h ˆ`‚fƒd G „Q‚e{ ‚T„XY‚C ƒ_‚K„kKLM.");
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £²£°£°£°S …V„kM.");
talk(2,"†~ƒm„S ƒo†daQ †cƒ`B ‚K‚b‚TZ. ‚G…q‚h „Vƒv…e ^‚V‚CZ.");
 NextEvent(278); --goto 278
 elseif r==2 then
talk(3,"b…gƒm„S ^‚V‚CZ. ƒnˆEŠi, d^ ‚oƒ_a†yKLM.");
 JY.Smap={};
 SetSceneID(0);
 NextEvent(268); --goto 268
 end
 end
 end
 end,
 [268]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="b…g";
 JY.Base["D‚wC"]=12;
 AddPerson(248,27,8,1);
 AddPerson(1,21,11,0);
 SetSceneID(48);
 DrawStrBoxCenter("b…g ƒP‚r‰R");
talk(248,"[, ‚G‚U†f. †u…co ‡EY‚C ŠU [ŠVKLM. …f‚b ‚G…WG‚f WLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÓëÈêÄÏÁõ±ÙÉÌÁ¿½ñºóÖ®ÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [269]=function()
 if JY.Tid==248 then--Áõ±Ù
talk(1,"…do ‹qn‡z ‡p‚wa[.",
 248,"‡i„Q ‚kKLM. †KƒP„Q …X‡I‚V[. ‚G‚P‚TG ŠXM‚b ˆ|f ƒOu ‚TƒP ‚rƒGD ƒi„gKLM. G‡EfƒW‚b …X‚M „KŠW ‚Cƒ_‡I‚V[.");
 AddPerson(64,-1,22,0);
 MovePerson(64,8,0);
 MovePerson(1,0,1);
talk(64,"‡p‚wWLM, ‚K‚J. …w„u ˆ|Š[G „OKLM.");
 NextEvent();
 end
 end,
 [270]=function()
 if JY.Tid==248 then--Áõ±Ù
talk(248,"†KƒP„Q …X‚Vƒd ˆ|Š[ ƒv†u‡I‚V[.");
 end
 if JY.Tid==64 then--ËïÇ¬
 JY.Status=GAME_SMAP_AUTO;
talk(64,"‚K‚J, †o†oƒP ‚G…qfQ ^ƒW ƒOu^ ‚n†PX „U ƒP…aBD „C‚b‚C CƒPB ƒsƒd…x WLM.",
 1,"ŠoM, ‚SƒW MˆQ[Q. ‚G…q‚h „Vƒv†Eˆe ŠU G…EƒGB ƒsQ.",
 64,"k.");
 MovePerson(64,8,1);
 DecPerson(64);
 ModifyForce(64,0);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<³ÇÄÚÉ¢²½£®>
talk(248,"ƒO…m ƒ{‚oS Še…eƒs‚V‚CZ.");
 NextEvent();
 end
 end,
 [271]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="b…g";
 JY.Base["D‚wC"]=12;
 AddPerson(1,27,8,1);
 AddPerson(54,21,11,0);
 AddPerson(2,25,15,2);
 AddPerson(128,23,16,2);
 AddPerson(83,21,17,2);
 AddPerson(3,15,8,3);
 AddPerson(65,13,9,3);
 AddPerson(82,11,10,3);
 SetSceneID(48);
 DrawStrBoxCenter("†B†R ‡D");
 DrawStrBoxCenter("b…g ƒP‚r‰R");
talk(54,"‚K‚J, „Nƒg p…x^ vv^ ƒQm‚h „_„kMƒd „aƒ` ŠXKLM.",
 1,"I‡JG? ƒQm^ OPMƒd? ‚~ƒ} „y^ ƒ[‰S…l q‚b…hD ‚CML. ‡m, {…B vv„S‚wƒv!",
 54,"ƒQm‚b Z‚]ŠW ˆGnƒv ƒc…~ƒb wƒFƒmƒv, G„S‰l vvƒP ƒoƒ}ƒb o‰F ‚I‚_BƒFKLM.");
 PlayBGM(11);
 AddPerson(248,-1,22,0);
 MovePerson(248,8,0);
talk(248,"[, ‚U†f. ƒn…IhLM.");
 JY.Status=GAME_SMAP_MANUAL;
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ÒéÊÂÌü£¬ÉÌÁ¿½ñºóÖ®ÊÂ£®>
 NextEvent();
 end,
 [272]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"[, ƒnˆEŠi. ƒn…IhLM. ‚G…WƒP ˆ|S …xƒoŠW ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"[, ƒnˆEŠi. ƒn…IhLM. ‚G…WƒP ˆ|S …xƒoŠW ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ƒn…IhLM. …xƒoo ƒuƒb ‚G…WƒP ˆ|S ƒR‚S ƒs‡I‚V[.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚K‚J, ƒn…IhLM. …xƒoo ƒuƒb ‚G…WƒP ˆ|S ƒR‚S ƒs‡I‚V[.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚K‚J, ƒn…IhLM. …xƒoo ƒuƒb ‚G…WƒP ˆ|S ƒR‚S ƒs‡I‚V[.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, ƒn…IhLM. …xƒoo ƒuƒb ‚G…WƒP ˆ|S ƒR‚S ƒs‡I‚V[.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"‚K‚J, ƒn…IhLM. …xƒoo ƒuƒb ‚G…WƒP ˆ|S ƒR‚S ƒs‡I‚V[.");
 end
 if JY.Tid==248 then--Áõ±Ù
talk(248,"‚U†f, vv^ ƒQm‚h „_ƒd ƒ[ ƒGƒo‚h Œ{n Gu„S ŠPƒR‚S[ƒd „OKLM.",
 1,"I‡JG? vv^ Gu„S †[Mƒd?",
 248,"p…xƒP ƒsƒd„S‚b vv „vjƒb [‚C ‚kƒd ‚Kƒaƒb vjG‚f WLM.",
 1,"‚SƒW …bFS ƒe‚Pa‚f.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×öÓ­Õ½²Ü²Ù¾üµÄ×¼±¸£®>
 NextEvent();
 end
 end,
 [273]=function()
 if JY.Tid==248 then--Áõ±Ù
talk(248,"…fD …bFS ƒe‚Pa†yKLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚SŠS G‹@ …IG. ƒQm^ G‰S…l ‡@Q OaML.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚SƒW …bFS ƒe‚Pa‚f.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"vv‚TƒP ƒoƒ}ƒb ŠInuƒG ‚SŠqKLM. ƒOu „@„Vƒm„S ‡fn‰M q „O†yKLY?");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, ŠGE ƒe‚P‚h a‚V‚CZ.");
 end
 if JY.Tid==82 then--ÃÓ·¼
talk(82,"‚K‚J, ŠGE ƒe‚P‚h a‚V‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"vv‚TG †~ƒm„S Wu [‚b‚wƒv.");
 end
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"…bFa‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(2,"‚_‚AS ‹s…c‡I‚V[!");
 WarIni();
 DefineWarMap(19,"d2ƒa b…g ‚B„e","1. vj ‚p…D",40,0,18);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,20,1,1,0,-1,0,
 -1,19,2,1,0,-1,0,
 -1,21,2,1,0,-1,0,
 -1,18,0,1,0,-1,0,
 -1,20,0,1,0,-1,0,
 -1,21,0,1,0,-1,0,
 -1,22,1,1,0,-1,0,
 -1,21,3,1,0,-1,0,
 -1,19,1,1,0,-1,0,
 247,20,3,1,0,-1,0,
 230,18,1,1,0,-1,0,
 231,18,2,1,0,-1,0,
 63,17,0,1,0,-1,1,
 });
 ModifyForce(64,1);
 DrawSMap();
talk(2,"…bF!");
 JY.Smap={};
 SetSceneID(0,11);
talk(19,"‚G‚P, ˆGnƒvD m„o‚aM! ƒOu ‚K‚JƒP ‹IƒSS ‚nB …A…w‚V ‚G‚P‚h ƒq‚S…E oM! ‚B ƒa‚~! b…gƒm„S g‚ToM! ‚i‚j‚f!");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 18,2,16,4,4,28,2,7,2,-1,0,
 93,3,17,4,4,25,19,7,2,-1,0,
 78,33,16,2,1,25,8,0,0,-1,0,
 67,32,17,2,1,25,8,0,0,-1,0,
 77,4,16,4,4,25,5,20,11,-1,0,
 103,6,10,4,4,24,5,7,2,-1,0,
 17,4,12,4,4,25,22,7,2,-1,0,
 62,33,11,2,1,24,2,0,0,-1,0,
 172,4,15,4,4,24,5,20,11,-1,0,
 170,3,15,4,4,24,8,7,2,-1,0,
 274,33,15,2,1,21,5,0,0,-1,0,
 275,32,12,2,1,21,5,0,0,-1,0,
 276,3,10,4,4,21,5,7,2,-1,0,
 292,4,13,4,4,21,8,7,2,-1,0,
 293,4,11,4,4,20,8,7,2,-1,0,
 294,34,13,2,1,20,8,0,0,-1,0,
 295,33,12,2,1,21,8,0,0,-1,0,
 310,33,14,2,1,20,10,0,0,-1,0,
 311,5,16,4,4,21,11,20,11,-1,0,
 328,4,14,4,4,20,13,7,2,-1,0,
 336,5,15,4,4,21,15,20,11,-1,0,
 337,5,11,4,4,20,15,7,2,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [274]=function()
 PlayBGM(11);
talk(19,"‚G‚P, ‡O ˆGnƒvƒ`†sŠm? ƒ_^ ‚SŠS ‹^n‚K†y†sŠm? G vjG …A…w‚V H‚h ƒq†yM.",
 1,"…pƒO^ ‚Z‚[ ƒLj^?",
 248,"‚U†f, ƒLƒb vvƒP FkhLM. ‚B‚UG ‚n†PaL ‚SƒW ˆuS ‰Xa‡I‚V[.",
 1,"ƒ[ I‡H ˆ|G[. ƒvD ‹[Y‚C ‰jƒO†ym.",
 248,"ƒ[…eN ƒu ‚aKLM. ‚G‚U†fŠ_ƒW‚b bƒGƒW ‰Bn^‚VA ‚o ŒjLM. d^ ‹[Y‚C …gS ƒhGL ‚SƒW G‡ES ‹Xƒv‡I‚V[.");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [275]=function()
 if (not GetFlag(76)) and WarMeet(54,68) then
 WarAction(1,54,68);
talk(54,"…f…x‚b k‚r„B‚C ‚k‚wƒv. …f ‚_ƒa, G v‡SG …I‚_…I„S „}ƒ^†yM.",
 68,"v‡SG‚f? [, ƒ[ GŠKƒb ƒR„kM. ƒU‚fŠB ƒUM. ŠP‚f!");
 WarAction(6,54,68);
 if fight(54,68)==1 then
 WarAction(19,68);
talk(54,"dˆF ŠU ‰jƒO‚b‚T!",
 68,"v‡S, [ƒXƒb t‚^^ ƒv‚C ‚k†y‚T. „l‚b ‰jƒO‚C ‚k†yM. ‹`ƒS M‚V „}ƒ^…x.");
 WarLvUp(GetWarID(54));
 else
 WarAction(19,54);
talk(54,"dˆF ŠU ‰jƒO‚b‚T!",
 68,"v‡S, [ƒXƒb t‚^^ ƒv‚C ‚k†y‚T. „l‚b ‰jƒO‚C ‚k†yM. ‹`ƒS M‚V „}ƒ^…x.");
 WarLvUp(GetWarID(68));
 end
 SetFlag(76,1)
 end
 if (not GetFlag(1020)) and War.Turn==3 then
 PlayBGM(12);
 WarShowArmy(64-1);
 DrawStrBoxCenter("‡YwG ƒv…@ŠgM!");
talk(64,"‚K‚J, ‹z‚SƒW ‡p‚wWLM. ‚G…q‡z G…EƒG^ „C„kKLM. ‚n†PX „U ‡zD ŠoM aŠbKLM. ‚Cƒgƒb ƒW…g‹J …f ƒ{…^„S ‰Xa‡I‚V[. ƒ[ ƒ{…^‚b vv‡z ‚G…qƒP ƒ@„TGL ƒ[‡EY‚C ^A ƒL‚TD „l‚b ‹Kn[‚C ˆfWLM.");
 War.WarTarget="1. vj ‚p…D*2. ‚G‚P^ ƒW…g ƒ{…^ DˆG";
 WarShowTarget(false);
 PlayBGM(10);
 SetFlag(1020,1)
 end
 if (not GetFlag(1021)) and War.Turn==4 then
 WarModifyAI(18,1);
 WarModifyAI(93,1);
 WarModifyAI(77,1);
 WarModifyAI(103,1);
 WarModifyAI(17,1);
 WarModifyAI(172,1);
 WarModifyAI(170,1);
 WarModifyAI(276,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(311,1);
 WarModifyAI(328,1);
 WarModifyAI(336,1);
 WarModifyAI(337,1);
 SetFlag(1021,1)
 end
 if WarCheckLocation(0,16,1) then
 WarGetExp();
bonus_moneyexp_4()
 PlayBGM(7);
talk(1,"ŠoM! ‚BƒaS Œz‚Sƒv †o†oƒm„S …yM.",
 19,"I‡JG? ‚G‚P^ ‚G…qƒP ~‚C„S ˆGnŠgMƒd!? dƒGŠJ¡­¡­ ƒA…eƒS q‹wf ‚a†y‚T.");
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(19,"a‚b q ‚aM. ‚S„y‰X ƒA…eƒS †~G„kM.");
talk(1,"ŠoM, ƒLƒP ‰dƒQG [ƒG ‚Bf †o†oƒm„S ^…x.");
 PlayBGM(7);
 NextEvent();
 end
 WarLocationItem(13,15,3,196); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¹Ä´µ¾ß
 end,
 [276]=function()
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £·£°£°S ƒYƒC!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [277]=function()
 JY.Smap={};
 SetSceneID(0,5);
talk(64,"†o†oƒm„S ^‚V‚CZ. †o†oƒb bƒGƒW …g‹JhLM.",
 1,"ŠoM. „i? …f…x‚b †u‚wŠm?",
 248,"‚G‚U†f!",
 1,"[, ‚G…W. †jn „O„k‚wƒ`!",
 248,"k. ‚U†f, …f‚b Gd b…gƒm„S ‰Bn‡y q ‚aKLM. ƒJƒKƒm‚VMA …f‚h …hƒ`^ ‚K‡I‚V[.",
 1,"I‡JG[?",
 248,"‚C‚qƒSf‚b ƒQmfQ ‚gŠe„~ƒmƒv Gd‚b n‚`LM. ‚^ƒZ …hƒ`^ ‚K‡I‚V[.");
 local menu={
 {" ‚G…WS …hƒ`…yM",nil,1},
 {"‚G…WS …hƒ`^‚C ‚k‚bM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"ƒA‹mG[. ƒ[†{ ‰HŠ_ †o†oƒm„S †h‚VM.",
 248,"[, ‡N‚rWLM.");
 ModifyForce(248,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚G…WG ‚G‚PƒP ‚^a^ „C„kM!");
 elseif r==2 then
talk(1,"…hƒ`‡y q ‚am. ƒ[‚_‚b ‚T‰hf ‡GG‚b ƒuS Œk‚Sa‚b ‚r†vG[. ‹Iƒm„S‚b …x‚G„BQ aƒd Š]ƒb ‚_„S ‚r‚V[. ƒ[„KG ƒ[‚_fQD ‚]‚Da[.",
 248,"¡­¡­„a†yKLM. ‚U†fƒP ƒ]G‚fA ƒ[ua‚CZ. ƒ[†{ …f‚b Gd …x‚G„SG ‚Cƒ_†yKLM.",
 1,"‚G…W, ƒdŠOm.");
 end
talk(64,"†o†oƒm„S ^‚V‚CZ.");
 NextEvent();
 end,
 [278]=function()
 DrawStrBoxCenter("‚G‚P‚b ‚G…q^ „O‚b †o†oƒm„S ˆuS ‰XPM.");
 NextEvent();
 end,
 --µÚ¶şÕÂ¿ªÊ¼
 --µÚ¶şÕÂ¡¡Òş·üĞÂÒ°
 [279]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d2ƒa¡¡ƒN…E ƒb†E";
 DrawStrBoxCenter("d2ƒa¡¡ƒN…E ƒb†E");
 LoadPic(13,1);
 DrawMulitStrBox("ƒQm‚b eDfƒW vvfQ OPM. vvƒsM ‚Io ‚~ƒ}S ‚C‰C‚MfD D„XG rn ‚GƒMo ‚^a‚h ˆ[‚C ˆfo ˆ~G„kM. ƒQm‚Tƒb ‚ofƒW‚^ƒh IHˆk Oo ƒuGM. vv‚b ƒQm‚TƒP IƒaƒRS ‡g‚D‚V‰a o‰F ‚I‚_o ƒoƒ}S Gƒ^„kM.")
 LoadPic(13,2);
 
 -- 0 ÉÏ 1 ÏÂ 2 ×ó 3 ÓÒ
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†o†o";
 JY.Base["D‚wC"]=13;
 AddPerson(95,25,9,1);
 AddPerson(113,25,15,2);
 AddPerson(120,14,9,3);
 AddPerson(1,5,19,0);
 SetSceneID(86,5);
 DrawStrBoxCenter("†o†o ƒP‚r‰R");
talk(95,"‚G‚P, ˆE‚Kf †[ ƒuS †I~a[.");
 MovePerson(1,5,0);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<°İ¼ûÁõ±í£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [280]=function()
 if JY.Tid==113 then--²Ìè£
talk(113,"‰q…f …fŠs ‚K‚JS Œr‚S…E‚CZ. kƒP‚h n‚VƒG ƒUŒeLM.");
 end
 if JY.Tid==120 then--ØáÔ½
talk(120,"‚G‚U†f, ‹pQ „C‚S …A†hKLM. …f‚b ‡w‡cG‚f WLM. ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==95 then--Áõ±í
 JY.Status=GAME_SMAP_AUTO;
talk(95,"ƒ[‚_^ G‡Ef ŠXƒmL vvD ‰H‚^„S ‡YS ‚_‚C‚b ˆfX ƒuG[. …X‚M ‹^ƒd ‚Cƒ_‚V[. ¡­¡­[, ƒ_ nƒRƒRS m†Ka†ym. ‡w‡c, ‚GƒG‡z ‚GTS …d…e[‚V[.",
 120,"k.");
 MovePerson(120,3,1);
 MovePerson(120,2,3);
 MovePerson(120,9,1);
 DecPerson(120);
 AddPerson(115,-4,23,0);
 AddPerson(121,-2,24,0);
 MovePerson( 115,7,0,
 121,7,0);
talk(95,"‚G‚P nƒO, G ŠeG ƒ_ nƒRG[. G‹JG ‚GƒG, …f‹JG ‚GTG[.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [281]=function()
 if JY.Tid==113 then--²Ìè£
talk(113,"‚GƒG‚b ‚B ‚^j m`Gƒd, ‚GTƒb ‚Cƒg ‚^j, ‰b d †uG m`hLM.");
 end
 if JY.Tid==115 then--Áõçù
talk(115,"‹n‚M ‹p†yKLM. ŠU ‚^…a…w„tLM. ƒ{G ‚GƒTG‚Vƒd n„qŠi{ ˆEdsG‚V‚fL, ƒ[ŠQMA dQ‚b †f‚^ŠiG‚V‚TZ. †f‚^Ši, ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==121 then--Áõçı
talk(121,"‹n‚M ‹p†yKLM. …f‚b ‚GTG‚f WLM. ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==95 then--Áõ±í
talk(95,"‚G‚P nƒO, ƒ_ ‚[ nƒRS ŠU ‚^…aa[. †~, ‚G‚P nƒO. ƒv‚h ‚nB ƒN…Eƒ{S ŠEn ‚C‰a ‚K‚C ‚k†ym?",
 1,"ƒN…Eƒ{ ˆ|Š[hLY?",
 95,"ƒ{ƒb „^‚C ‚kƒmƒv ˆE‚KƒP ˆz‡k†MG[. ƒ[‡EfƒW vvƒP ‚l†YS †ja ‚KƒG ƒU‚f[.",
 1,"ŠoKLM. ƒo†daQ †cƒ`B ‚K‚VL ‡N‚rWLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ĞÂÒ°³Ç£®>
 NextEvent();
 end
 end,
 [282]=function()
 if JY.Tid==113 then--²Ìè£
talk(113,"ƒN…E‚h ŠU ‚C‰a ‚K‡I‚V[. M„V vvfQƒW ‡f ˆGnƒv [ŠVM aL …f„SƒW‚b ‹D OFhLM.");
 end
 if JY.Tid==115 then--Áõçù
talk(115,"‹Iƒm„SD ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==121 then--Áõçı
talk(121,"ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==95 then--Áõ±í
talk(95,"ƒN…E‚b †o†oƒP ˆz‡k†MG[. ƒ[†{ ‚^…aa[.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [283]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13; --ÆäÊµĞÂÒ°Ã»ÓĞµÀ¾ßµê£¬ÕâÀïÓÃµÄÊÇÏåÑôµÄ
 AddPerson(1,25,9,1);
 AddPerson(2,25,11,2);
 AddPerson(3,23,12,2);
 AddPerson(54,22,9,3);
 AddPerson(64,20,10,3);
 SetSceneID(71);
 DrawStrBoxCenter("ƒN…E");
talk(2,"GƒuG ƒOuƒP †D ƒ{G„S‚T. …Xƒlƒ_ ˆu ŒE…I ‡EG `‹HM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÊÓ²ì³ÇÄÚ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [284]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"GƒuG ƒOuƒP †D ƒ{G‚TZ. †J‚V d ƒ{G „O‚S…E …X‚MG ‹^hLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, Gd…E …X‚MG ‹^hLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"G‡EfƒW †D„S‡S ŠdS ‚VJa‚b ƒuGM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, G‡Ef ‡f ŠXƒmL ƒO…m ƒ{‚oS Še…eƒs†B ‚rFS †j‰X‚V‚CZ.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [285]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13; --ÆäÊµĞÂÒ°Ã»ÓĞµÀ¾ßµê£¬ÕâÀïÓÃµÄÊÇÏåÑôµÄ
 AddPerson(1,25,9,1);
 
 AddPerson(114,7,14,0);
 AddPerson(117,27,18,2);
 AddPerson(355,20,5,3);
 AddPerson(359,13,8,3);
 AddPerson(357,14,20,2);
 SetSceneID(71,5);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [286]=function()
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"¡­¡­„i? …f‡Lƒb ‚G‚PŠiG n†m^?");
 MovePerson(114,2,3);
 MovePerson(114,5,0);
talk(114,"‚G‚U†fG‡ILY? ƒ{‚of „T‚VM‚b ˆ|S Š^ƒd ‹qnŠXKLM. …f‚b GƒLG‚f WLM. …fŠs ‚K‚J ‚G…qŠ_ƒW ‡iƒNS DƒO‚f ƒsƒ_ŠVKLM. ŠU ‚^…a…w„tLM.",
 1,"‡z ‚KŠV‚wƒ`. †~ƒm„S ŠU‹km. [ŠWƒ` ƒ_^ ŠU ‚^…aB…E†ym.");
 ModifyForce(114,1);
 PlayWavE(11);
 DrawStrBoxCenter("GƒLG ‚G‚PƒP ‚^a^ „C„kM.");
talk(114,"o ^‚C ˆ|Š[…wuƒd…x WLM. ˆE‚Kf qƒ@ …m`G‚f …du‚b ƒdno ‡LG „T‚VL ‚^ƒZ o‚W „Vƒv ƒs‡I‚V[.",
 1,"qƒ@ …m`G‚f. ‚SŠSab „Vƒv…E a[?",
 114,"qƒ@ …m`ƒb ‡Aƒb ‚X‚r‡z „W‚Ga‚VL ‚U†fŠ_ DˆlG Š}‚C ‚Z‹{LM.",
 1,"„a†ym. GƒL, ƒdŠOm.",
 114,"M„V ‚SƒZf ‚r‚V‚b‚C‚b …fD ‚Z‹{LM.",
 1,"Šom. ŒoS ƒ_‚S ‹qnƒs†ym.");
talk(114,"ƒ[†{ …f‚b ƒP‚r‰Rƒm„S ^†yKLM. …w„u ˆ|Š[G „l „OƒmL ƒP‚r‰RfƒW ‹p‚CZ.");
 MovePerson(114,12,1);
 DecPerson(114);
 SetFlag(1022,1);
 end
 if JY.Tid==117 then--Áõ·â
 MovePerson(117,5,2);
 MovePerson(117,2,0);
talk(117,"‚G‚U†fG‡ILY? …f‚b ‚G‡WG‚f WLM. ‚U†fŠ_ƒW ƒN…Ef [ŠVM‚b ˆ|S Š^ƒd …I‚^…e ƒP…aa…e ŠXƒmL ‚^ƒZ †E‚[‚S ‚K‡I‚V[.",
 1,"ŠoM! ŠUB ƒsQ!",
 117,"n, ‡N‚rWLM!");
 ModifyForce(117,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚G‡WG ‚G‚PƒP ‚^a^ „C„kM.");
talk(117,"ƒ[†{ …f‚b ƒP‚r‰Rƒm„S ^†yKLM.");
 MovePerson(117,12,1);
 DecPerson(117);
 SetFlag(1023,1);
 end
 if JY.Tid==355 then--Å©Ãñ
talk(355,"qƒ@ …m` ˆ|hLY? qƒ@ …m`ƒb †o†oƒ{f ‚r‡ILM. M„V …x‚K †LS ‚PƒO‚V‚CZ.");
 SetFlag(1024,1);
 if GetFlag(1022) and GetFlag(1023) and GetFlag(1024) and GetFlag(1025) and GetFlag(1026) then
talk(1,"ƒ[†{ ƒP‚r‰Rƒm„S ^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==359 then--ÂÃ¿Í
talk(359,"ƒQm^ …G„kM„l‚TZ. ƒ[‰S…l ‚I‚_o ƒoƒ}G„k‚b…hD vvfQ ‚Cƒd ˆ|ƒtKLM.");
 SetFlag(1025,1);
 if GetFlag(1022) and GetFlag(1023) and GetFlag(1024) and GetFlag(1025) and GetFlag(1026) then
talk(1,"ƒ[†{ ƒP‚r‰Rƒm„S ^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==357 then--ÉÌÈË
talk(357,"‚G…qŠiƒP ‚Cƒg ‚^jƒb d ˆjnƒR ‚GTS …C„T„S ƒoƒOƒ` oM„l‚TZ. ‡mƒv ƒa…x‚b ‚GƒGj…h ˆ|hLM.");
 SetFlag(1026,1);
 if GetFlag(1022) and GetFlag(1023) and GetFlag(1024) and GetFlag(1025) and GetFlag(1026) then
talk(1,"ƒ[†{ ƒP‚r‰Rƒm„S ^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [287]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(54,20,9,1);
 AddPerson(3,11,16,0);
 AddPerson(64,9,15,0);
 AddPerson(114,14,11,3);
 AddPerson(117,12,12,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒN…E ƒP‚r‰R");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë¹ØÓğµÈÌ¸ÂÛ½ñºóÖ®ÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [288]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"GƒRƒb Gd ‡f ˆEŠiŠ_ ƒP…aa…e †[ …xƒRG‚f WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, †h…xƒG IƒaG ‹j ƒX„k‚TZ!");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"IƒaG ƒX‚SD ˆDƒxS †E„Q‚C ‚kƒmA m„o‚aM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚r†vG ‡An‚C‚b w Šoƒb …IG‚CZ!");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"‚G‚U†f, ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"…fŠs ‚K‚J ‚G…qŠ_ƒW ZŠr †Z†dG „OƒmƒN ‡KWLM. n…X ‚IaƒP …A‚d „U…Z…I ƒuhLM.",
 1,"‚IaƒP …A‚dG‚f?",
 114,"ƒ[ŠQKLM. ‚Iaƒ{ƒb ˆE‚KƒP ˆz‚l†Mj…h †Z†G DƒLG ƒv…@ƒv ‚S‚CŠpKLM.");
 NextEvent();
 end
 end,
 [289]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…A‚d g…FG‚f. d^ ƒvE ƒuY‚CD ‚a†y‚C„V ƒ[†GD ^†yKLM!");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"IƒaG ƒX‚SD ˆDƒxS †E„Q‚C ‚kƒmA m„o‚aM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚r†vG ‡An‚C‚b w Šoƒb …IG‚CZ!");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"‚Ia‚b ˆE‚KƒP ˆz‚l†MhLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"†Z†G ‚Iaf DƒLG ƒv…@ŠgM WLM.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ‚G…qŠ_ƒW G …I„S †Z†daƒNML ƒOu^ ƒ[ OF†Eu‚h ‚aŒi …wu‚CZ.",
 1,"G‰S…l ƒs†ja ‚K‚VL ƒL‚SD Œv…X…yƒb ‹yn…E‚CZ.",
 3,"ŠoKLM! FaŠVƒmA ‚SƒW …bFa‚V‚CZ.",
 54,"ƒa‚P, HI …x„Va‚C …X‚f.",
 114,"…fŠs ‚K‚J ‚G…qƒP †Z†dS f‚S ‚K‚VL ‡N‚rWLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×¼±¸ÏûÃğ½­ÏÄÃ«Ôô£®>
 NextEvent();
 end
 end,
 [290]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"„[ƒLG‚f? ƒ_ C‚_^ ˆf „C‚C.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒLƒb DƒL ŒlhLM. ƒ[‹@ …v‡iƒRS †@ŠH „oƒWX q ‚aKLM!");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, …bFS ƒe‚Pa‚V‚CZ!");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"ƒG‚_‚h …f„qu‚C ‚k†yKLM. ‚C‰a‰} ‚K‡I‚V[.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"…fŠs ‚K‚J ‚G…qƒP †Z†dS f‚S ‚K‚VL ‡N‚rWLM.");
 end
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"ˆEŠi, ƒe‚P„CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
talk(2,"‚_‚AS ‹s…c‡I‚V[!");
 WarIni();
 DefineWarMap(20,"d2ƒa ‚Ia ‚B„e","1. ƒaI ˆL†U",40,0,117);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,1,3,4,0,-1,0,
 -1,2,3,4,0,-1,0,
 -1,1,4,4,0,-1,0,
 -1,2,5,4,0,-1,0,
 -1,3,5,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 -1,2,2,4,0,-1,0,
 -1,1,1,4,0,-1,0,
 -1,0,2,4,0,-1,0,
 -1,0,6,4,0,-1,0,
 });
 DrawSMap();
talk(2,"…bFa†yKLM.");
 JY.Smap={};
 SetSceneID(0,3);
talk(114,"‚G‚U†fŠ_ƒW‚b ‚Ia^ ‹n‚MG‚V‚CZ. d^ †r‹QG‚h a†yKLM.");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 117,30,18,3,2,27,11,0,0,-1,0,
 118,29,19,3,0,24,11,0,0,-1,0,
 310,29,17,3,0,22,11,0,0,-1,0,
 311,26,10,2,4,21,11,11,4,-1,0,
 312,27,14,2,4,21,11,11,4,-1,0,
 313,21,17,3,4,20,11,9,13,-1,0,
 314,23,16,3,4,20,11,9,13,-1,0,
 274,30,16,3,0,23,5,0,0,-1,0,
 275,28,11,2,4,23,5,11,4,-1,0,
 292,27,12,2,4,21,8,11,4,-1,0,
 293,23,17,3,4,21,8,9,13,-1,0,
 332,22,16,3,4,23,14,9,13,-1,0,
 333,27,11,2,4,23,14,11,4,-1,0,
 336,27,9,2,4,23,15,11,4,-1,0,
 337,20,18,3,4,23,15,9,13,-1,0,
 340,24,16,3,4,22,17,9,13,-1,0,
 341,25,17,3,4,20,17,9,13,-1,0,
 342,26,13,2,4,21,17,11,4,-1,0,
 141,29,2,3,2,30,3,0,0,-1,1,
 142,28,1,3,2,30,16,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [291]=function()
 PlayBGM(11);
talk(118,"‚G…q‚TG ‡O ŠX†sŠm? ƒd‡Co ƒuƒR. Šz†KƒRn! …fƒRS ƒq‚S‚f.");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [292]=function()
 if WarMeet(3,119) then
 WarAction(1,3,119);
talk(3,"DƒLŒN, ƒSˆc‚C …X‚f. ƒc…~S ƒ_‹^n‚f!",
 119,"„h? …fŒNG ƒv‡z ‚r`†@†MS a†yMƒd? s†w„O‚T. †u‚wj‚C‚b Œ{‚fD C‚_B ‚K‚C.");
 WarAction(6,3,119);
 if fight(3,119)==1 then
 WarAction(8,3,119);
talk(119,"…v¡­¡­!");
 WarAction(18,119);
talk(3,"ŒL, C‚_‚fƒd X ƒuD ‚a‚T! †g o ‚Wf …GML. ˆuD …^ ‚o ‹E„~‚b…h.");
 WarLvUp(GetWarID(3));
 DrawStrBoxCenter("ƒa‚P^ ƒOƒo‚h ‹QƒtM!");
 else
 WarAction(4,119,3);
talk(3,"¡­¡­");
 WarAction(17,3);
 WarLvUp(GetWarID(119));
 DrawStrBoxCenter("g‡YG ƒOƒo‚h ‹QƒtM!");
 end
 end
 if WarMeet(54,118) then
 WarAction(1,54,118);
talk(118,"ŒL, [W‚CŠzƒRn. ƒ_ ‹MƒT‚h ƒsn‚f! …f ‚_ƒaS ˆ|fƒW ƒq‚S „n‚S„]ƒ` ‚K…X!",
 54,"‚M, G‹Jƒm„S [‚b …f…x‚b¡­¡­ DƒLƒP ‚[ƒcj ‡Ka‚T. ŠoM! ƒ_^ ƒq†yM!");
 WarAction(6,54,118);
 if fight(54,118)==1 then
 WarAction(8,54,118);
talk(118,"HI ‚IaM¡­¡­ …v!");
 WarAction(18,118);
talk(54,"G ˆ|G dˆF Šo‚TZ. ˆnƒd ^†yKLM.");
 WarGetItem(GetWarID(54),7);
 --WarLvUp(GetWarID(54));
 DrawMulitStrBox("‚G‚P‚TG ‚IaƒP DƒLS ˆL†UPM.");
 NextEvent();
 else
 WarAction(4,118,54);
talk(54,"‚_†Ma‚wƒv!");
 WarAction(17,54);
 WarLvUp(GetWarID(118));
 DrawStrBoxCenter("ƒaI^ ƒOƒo‚h ‹QƒtM!");
 end
 end
 if (not GetFlag(1027)) and War.Turn==4 then
 WarModifyAI(311,1);
 WarModifyAI(312,1);
 WarModifyAI(313,1);
 WarModifyAI(314,1);
 WarModifyAI(275,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(332,1);
 WarModifyAI(333,1);
 WarModifyAI(336,1);
 WarModifyAI(337,1);
 WarModifyAI(340,1);
 WarModifyAI(341,1);
 WarModifyAI(342,1);
 SetFlag(1027,1)
 end
 WarLocationItem(18,24,21,79); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º½üÎÀîø
 WarLocationItem(7,28,27,197); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÏÀÒå¾«Éñ
 if (not GetFlag(198)) and WarCheckLocation(-1,15,30) then
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £´£°£°S ƒYƒC.");
 SetFlag(198,1);
 end
 if JY.Status==GAME_WARWIN then
talk(118,"Fˆ| ‚G‚P‚TG‚d ˆ|GŠm? HI ‚IaM¡­¡­ …v!");
 DrawMulitStrBox("‚G‚P‚TG ‚IaƒP DƒLS ˆL†UPM.");
 NextEvent();
 end
 end,
 [293]=function()
 PlayBGM(11);
 WarShowArmy(142-1);
 WarShowArmy(143-1);
talk(142,"‚K‚G, …f ‚^‚_‚b ‚SƒZƒP ƒuG[? ‚G…q‚Tf …f‰S…l ‚Io …x^ „OM‚b ˆ|ƒb ƒRƒb ƒLG ‚am.",
 143,"‚ZKS ƒsL ‚G‚Pj ‡KWLM.",
 142,"‚G‚P‚f? o„U vv‡z ‡fC‡fa„S ‰jƒOŠB …x^ n†m^. ƒ[ŠQMA …f DƒLƒRG ‡iBƒ_‚C ˆfo ƒuD ‡i…Ba‚T.",
 143,"„v†G …f DƒLƒRS ‚^ƒ` ‚Ia‚h ƒOu ‚l[ƒP ƒuƒm„S |ƒmƒ` Pƒmƒv, …fƒRG „O‚b o ‚Ia‚h ‡Yf †pƒG‚b ‚SŠq†yKLM.",
 142,"ˆE‚K‚h …Vƒmƒ`A ‰Bn^ ‚_‚uS M‚V ƒoƒO‚b „KG ‹o†yKLM.",
 143,"‚XS …HƒR†yKLM!");
 WarAction(16,142);
 WarAction(16,143);
talk(1,"…f ‚^‚_‚b ‚SƒZƒP ƒuGŠm? DƒLƒb n†m ‡KaM. ‚TƒGƒP t…x^ I‡JGŠm? ¡±‡Y¡±j^?");
 PlayBGM(7);
 GetMoney(800);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¸£°£°S ƒYƒC!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [294]=function()
 SetSceneID(0,5);
talk(2,"ˆEŠi, ‚G…qŠ_ „auŒs…E‚CZ. …fŠs‚b ‰q…f ƒN…E„S ‰Bn^ ƒGMu†yKLM.",
 1,"ŠoM! ƒ[†{ ƒv‚b †o†oƒm„S ^†yM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ÏåÑôÏòÁõ±í»ã±¨Õ½¹û£®>
 NextEvent();
 end,
 [295]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†o†o";
 JY.Base["D‚wC"]=13;
 AddPerson(95,25,9,1);
 AddPerson(113,25,15,2);
 AddPerson(120,23,16,2);
 AddPerson(122,14,9,3);
 AddPerson(123,12,10,3);
 AddPerson(1,5,19,0);
 SetSceneID(86,5);
talk(95,"‚G‚P, I‡H …IG[?");
 MovePerson(1,5,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [296]=function()
 if JY.Tid==113 then--²Ìè£
talk(113,"I‡H …IG `„} [ƒN ƒuƒb nL†y‚CZ?");
 end
 if JY.Tid==120 then--ØáÔ½
talk(120,"‚G‚P, I‡H …IG[?");
 end
 if JY.Tid==122 then--ÎÄÆ¸
talk(122,"‚G‚P, I‡H …IG[?");
 end
 if JY.Tid==123 then--ÍõÍş
talk(123,"‚G‚P, I‡H …IG[?");
 end
 if JY.Tid==95 then--Áõ±í
talk(95,"I‡JG[? ‰r‰l ‚IaƒP DƒLS ƒwFPMƒd! †~ƒm„S qƒdPm! ƒ[ „[ƒLƒRG „V„V„Q ‚kƒt‚b…h, ƒ_ ‚^‚_D Œi‚h K„km. {…B ‚G‚P„S‚wƒ`!",
 1,"‡i„Q ‚kKLM. ‚G…q ˆEŠiŠ_ƒW ƒN…Eƒ{Y‚C ƒ_‚S ‚KŠVƒmL, G„Vo …I„S‚b ƒ[ ƒbƒp‚h ‹yƒGf u‚aG ‚^„RWLM.",
 1,"ƒ[uƒd o ^‚C bvƒd…x WLM.",
 95,"I‡H …IG‡ILY?",
 1,"‚IafƒW ƒA…eƒvƒG „L‚B, DƒL{‚b Ieo ‚^‚_‚h ƒsƒtKLM. ƒn ‹C_f ¡±‡Y¡±G‚f ƒL‹u „O„kKLM.",
 95,"I‡JG[? ¡±‡Y¡±G‚f ƒL‹u „O„kMƒd? [¡­¡­ ƒ[ŠQ‚T¡­¡­",
 1,"†u‚wƒP ‚^‚_hLY?",
 95,"‚G‚P nƒO, ˆE‚Kf †[ ‚C Œv…X „C‚C ‚kƒtƒmL ƒ_^ ƒ[ ‚^‚_f ‚_B E‚XB ‚K†ym.");
 PlayBGM(11);
 DrawMulitStrBox("ˆE‚K‚b ƒo ƒn ƒoƒ} ‚rGf „Om. ‡k‹Jƒb vv, ƒW‹Jƒb …S‚K, M‡M aƒv^ ‚l‹JƒP ‚l[Z. [‚b ‚_‚_„S ‡YƒT …I„RG Mƒ~„~ƒd ‚CƒgƒP ‚Kjƒb ‡Y‡bG[. ˆE‚K‚b [ˆs ƒo‡c [‡z ~‰S ‡LŠwS ^„kƒd, ‡Y‡bƒP n‚P ‡Y†Tƒb ‚G…q ‚^aƒP ‡Yf …G„km.");
talk(95,"¡­¡­‚rFG ƒ[…ea[.",
 1,"ƒ[ŠQ‚TZ. ƒ[ŠQMA ƒ[ DƒLƒRƒP ‚q‚lD ‡Y‡bG ‚r‚Ko ƒuG„k‚TZ.",
 95,"G‡Eƒb [R‚l‚o ŠZ…IG ‚a„km. ¡­¡­ ‚G‚P nƒO, ƒ_ ~‚C‚b vvD ƒ@„TB…E a[. ƒN…E„S ‰Bn^ A ‹]‚V[.");
 PlayBGM(5);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<»ØĞÂÒ°£®>
 NextEvent();
 end
 end,
 [297]=function()
 if JY.Tid==113 then--²Ìè£
talk(113,"…M! dˆF ŠUaƒG‚b P‚C. ‡mƒv ƒ[ FD ‰S‰rGƒb ƒvD X q „Om.");
 end
 if JY.Tid==120 then--ØáÔ½
talk(120,"‚IaƒP …A‚dS g…FB ‚K‚VL ‡N‚rWLM.");
 end
 if JY.Tid==122 then--ÎÄÆ¸
talk(122,"‚IaƒP …A‚dS g…FB ‚K‚VL ‡N‚rWLM.");
 end
 if JY.Tid==123 then--ÍõÍş
talk(123,"‚IaƒP …A‚dS g…FB ‚K‚VL ‡N‚rWLM.");
 end
 if JY.Tid==95 then--Áõ±í
talk(95,"ƒN…E„S ‰Bn^ A ‹]‚V[.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [298]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 SetSceneID(54,5);
talk(2,"ˆEŠi, „Nƒg p…x^ vv^ ƒQm‚h ‚~„dPMƒd „aƒ` ŠXKLM.",
 1,"I‡JG? vv^ ƒQm…X…f |…s†M ˆ|GŠm!");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë¹ØÓğÉÌÁ¿£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [299]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, „Nƒg p…x^ vv^ ƒQm‚h ‚~„dPMƒd „aƒ` ŠXKLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"†J‚V aƒKƒb „[ƒL ‚i‚n‚b ƒ_ C‚_^ ˆf „C‚C.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚G…qŠiD Œi‚h KŠB ‚IaƒP …AƒLS ‚G‚PŠiG ‚aŒiŠVML, †~ƒm„S ‚_†Ma‡ILM!");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"ƒQm…X…f vv‚h ‡f‚C ˆfP‚TZ!");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"Gd vvf ŠGE q „O‚b G‚b ‚G…qŠiŠFhLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"n, ‚K‚J. ‡YŠiG †[ ‡KWLM.");
 AddPerson(115,0,5,3);
 MovePerson(115,7,3);
 NextEvent();
 end
 end,
 [300]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒnˆEŠi, ‚GƒG ‚J…xŠ_ƒW aN ˆ|Š[G „O‚b ‡KWLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚GƒG ‚J…xŠ_ƒW …I‚^…e ‹qn[ŠVƒmL I‡H …IG „O‚b ‚Z†ohLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ƒO…m ‚GƒG ‚J…x‚h „Vƒv ƒs‚V‚CZ.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚GƒG ‚J…x„S‚T. I‡H …IG[?");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ƒO…m ‚GƒG ‚J…x‚h „Vƒv ƒs‚V‚CZ.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚K‚J, ƒO…m ‚GƒG ‚J…x‚h „Vƒv ƒs‚V‚CZ.");
 end
 if JY.Tid==115 then--Áõçù
talk(115,"†f‚^Ši, …f‚b ‚Ia„S ^Q „C„kKLM. ‡i‡L…y ŠI‚S‚CQ „C‚S …I‚^…e JŠZ j‚r‚h …wu…e ŠXKLM.",
 1,"…I‚^…e ‚@‚MB ‚KL ƒdŠO‚wƒ`.",
 115,"‹Iƒm„S I‡H …IG „Oƒm‚VA …f‡zD CƒPB ‚K‡I‚V[. ƒ[†{ ƒA…e^†yKLM.");
 MovePerson(115,8,2);
 DecPerson(115);
 NextEvent();
 end
 end,
 [301]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚GƒG ‚J…xŠ_ƒW ‚GT ‚J…x‡zƒP …C„T …Zd„S Œ[‚V ‡w„S„EaƒNM„l‚TZ. ƒ[ „U…Zf ‚Ia„S ^‚V‚b ƒuƒb n†tYZ?");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚Ia‚b ƒ_^ ‚_ƒN ƒwFB ƒe ‡EG‚C.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚GƒG ‚J…xƒP Œv†^G ‹D en‚CƒN ‡KWLM. †Z†dG ^ƒN ‚Z†ohLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚G‚U†f, „Nƒg ƒ{‚ofƒW qƒ@ …m`S Œr„kKLM. ‚^ƒZ o‚W „Vƒv ƒs‡I‚V[.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"GƒLG ‚B‚^ƒh qƒ@ …m`S G…EƒGaŠB…h, ‚_…r ‚S†A ‡L…IY.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚K‚J, ‹wf ƒv^ ƒU†vGƒv D‚V‚b ƒuG ‚S‹c†yKLY?");
 end
 end,
 [302]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(1,25,9,1);
 AddPerson(382,7,14,0);
 AddPerson(372,27,18,2);
 AddPerson(355,20,5,3);
 AddPerson(359,13,8,3);
 AddPerson(357,14,20,2);
 SetSceneID(71,5);
 
 MovePerson(382,2,3);
 MovePerson(382,5,0);
talk(382,"[, ƒ[‚_^ ‚G‚U†fG[?",
 1,"ƒ[ŠQKLM„V, ƒ[…e‚V‚b ‡Lƒb?",
 382,"{…B ƒ[ŠQ‚wƒ`. ‚Xƒ{S Š^ƒd …I‚^…e Œr…e ŠXm. ƒv‚b ‚r…X‚g‚f a†B ƒoCfƒW‚b qƒ@ …m`G‚f ‚^‚j[.",
 1,"‡iƒNG ƒU„S qƒ@ …m`G‚V‚TZ. ‡q…h ‚SŠS …f‚h n‡ILY?",
 382,"G‡E †eƒ{ƒRG wu ƒ[‚_‚h W‡pa[. QM^ ‚IaƒP ‰jˆlƒb †~ƒm„S †|†}Pm.",
 1,"‚Z‚[ „o†_o ƒaqƒR ‡V‡LhLM!",
 382,"{…B eƒO, ƒa‚P, v‡SG „O‚wƒ`. ‡mƒv ƒ_^ ƒsƒGf js^ n„L ‚Z…x‚f[.",
 1,"nL, ƒ[ŠQ‚C‚b ‚k†y‚CZ.",
 382,"ƒ[ŠQMA ‚SŠS G‹@ Jƒb ƒ{Gƒv ‚C‰Jƒd „Om? ƒ[‚_fQ „l ƒn ƒ]G ‚a†M ˆ|G[?",
 1,"¡­¡­",
 382,"ƒ[ŠQ‚C¡­¡­ ‚D‡l{ ‡W…c ^‡S…h aƒv„V …V‚SD ƒ[‚_ƒP ƒn ƒ]ƒb ‰u„C‚C ‚kS ƒuG[.",
 1,"‚D‡l? ‡W…c? ƒ[ƒRG †u‚whLY?",
 382,"‚D‡lƒb ƒ{G d‡y, GŠKƒb †o, …x‚b ‚J‚XG[. ‡W…c‚b ƒ{G „N, GŠKƒb „w, …x‚b ‚rƒQG[.",
 1,"d‡y„X¡­¡­ ‚J‚X¡­¡­ „N„w¡­¡­ ‚D‡l{ ‡W…c^ ƒ[ƒRG‚d ˆ|Š[hLY?",
 382,"‚J‚Xƒb †o†o ƒW‹J ‡X‚eƒP ‚VŒAf ‚r[. ƒ]G „O†Eˆe o‚W ‹qn^ ƒs‚V[.",
 1,"‡X‚eG‚f. „a†yKLM. „CD…l Wu ‹qn^†yKLM.",
 382,"ƒ[†{ ƒvD ƒ[‚_‚h „V‚q gG[. G„V ^†ym.");
 MovePerson(382,12,1);
 DecPerson(382);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚÒéÊÂÌüÓë¹ØÓğ¡¢ÕÅ·ÉËµÖî¸ğÁÁµÄÊÂ£®>
 NextEvent();
 end,
 [303]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 SetSceneID(54,5);
talk(1,"eƒO, ƒa‚P. ‚Cƒg ‡X‚eƒm„S …yM.",
 3,"I‡H …IhLY? Gu ƒW‚[‚j‚VML.",
 2,"‡X‚ef‚b I‡H …I„S ^‡ILY?",
 1,"„Nƒg ‚K‡ffƒW GƒLS „VŠg‚b…h qƒ@ …m` G…EƒG^ ƒvŠXM.",
 114,"[, qƒ@ …m`S „VƒvŠV‚TZ.",
 1,"qƒ@ …m`G ˆ|aƒG‚h, d‡y„X …x‚b ‚J‚XG‚f‚b ‚r†vG ‡X‚ef „[M„l‚wƒv.",
 3,"ƒ[ d‡y„XG‚f‚b …x^ ƒ[u ‚_†Mo …h^ „OKLY?",
 1,"qƒ@ …m`ƒP ˆ|„e„S‚b ‚_†Mo jƒAj ‡KaM.",
 2,"ƒ[ŠQMA ˆEŠiŠ_ƒW o‚W MˆQ[Œs…E†y‚TZ.",
 1,"eƒO‚b ‹D ˆf…Xˆmo ‚Z†oG‚wƒv?",
 3,"…fD ŠZ„S ƒ_‰J‚C ‚kKLM.",
 1,"ƒ[u ˆ|a‚C ˆ|ƒd ‰HŠ_ ^…x.",
 2,"k!");
 MovePerson( 2,2,2,
 3,2,2);
 MovePerson( 2,1,2,
 3,1,1);
 MovePerson( 2,2,1,
 3,2,1);
 MovePerson( 2,7,2,
 3,7,2);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [304]=function()
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"…I~ ‰Bn[‡I‚V[. d^ ƒ{S ‚C‰J†yKLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"…I~ ‰Bn[‡I‚V[. qƒ@ …m`Š_ƒW ‚s†EaŠVMA „s‚V ‚_†Mo jƒA…I ƒuhLM. ‡X‚e ˆ|hLY? †o†o ƒW…g‹JƒP o …XSG‚CZ.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"…I~ ‰Bn[‡I‚V[.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"…I~ ‰Bn[‡I‚V[.");
 end
 end,
 [305]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡X‚e";
 JY.Base["D‚wC"]=0;
 AddPerson(1,9,12,3);
 AddPerson(2,5,11,3);
 AddPerson(3,7,10,3);
 AddPerson(381,11,13,2);
 SetSceneID(44,8);
 DrawStrBoxCenter("‚J‚X ƒ|ƒ`");
talk(2,"G‡EG ƒ[ ‚J‚XG ‚r‚b †LhLY?",
 3,"ƒ[‰S…l ‚_†Mo ‚r†vG G‹@ ‡Ef „[†M ˆ|hLY?",
 2,"ˆEŠi, ƒO…m …f ‚l…xfQ ƒA‚Sƒs‚V‚CZ.")
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [306]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚l…xfQ ƒA‚Sƒs‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚l…xfQ ƒA‚Sƒs‚V‚CZ.");
 end
 if JY.Tid==381 then--Í¯×Ó
talk(381,"xƒN‚CZ?",
 1,"oƒP …pƒa‚T ƒPƒ{F…C ~k‚Kƒc ‚U†f ‚G‚P^ …m`S Œr…e ŠXm. ‚of „aƒ` ‚K‚V[.",
 381,"‡dŠu„VZ. ƒ[ŠQQ ŒI GŠKƒb ˆf ƒkŒ|LM.",
 3,"ƒ[†{ ƒN…EƒP ‚G‚P^ ŠXMƒd„V ‚BB ‚K‚V[.",
 381,"…m`Šiƒb ƒv^ŠVKLM.",
 2,"oƒP …pƒa‚T ƒPƒ{F…C ~k‚Kƒc ‚U†f ‚G‚P^ …m`S Œr…e ŠXm. ‚of „aƒ` ‚K‚V[.",
 381,"‚o „T‚V[? ‚SƒZ„S ^ŠVm? ˆAd ‰Bn[‚V[?",
 381,"‚Z‹{LM. ƒg„N ‰Bn[N „UD „Oƒd o†~ ‚o [N „UD „OKLM.");
 NextEvent();
 end
 end,
 [307]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ƒN…E„S ‰Bn^‚V‚CZ.");
 MovePerson( 2,0,2,
 3,0,2);
 DecPerson(2);
 DecPerson(3);
 NextEvent();
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚SŠq‚ru o ‚W ŠX‚b…h ‚aML. ƒnˆEŠi, ‚J‚XG‚fƒd ŠZƒu „O†yKLY. ƒ[„V‚[‚V‚CZ.");
 end
 if JY.Tid==381 then--Í¯×Ó
talk(381,"ƒN…EƒP ‚G‚PŠiG MˆQ^ŠVMƒd ‰@ ‚BB …wu†yKLM.");
 end
 end,
 [308]=function()
 if JY.Tid==381 then--Í¯×Ó
talk(381,"…m`Šiƒb n„L ‚o ‰Bn[ŠVKLM.");
talk(381,"ƒN…EƒP ‚G‚PŠiG MˆQ^ŠVMƒd ‰@ ‚BB …wu†yKLM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [309]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(2,25,7,1);
 AddPerson(3,29,9,1);
 AddPerson(1,25,9,1);
 AddPerson(112,6,14,3);
 AddPerson(372,27,18,2);
 AddPerson(355,20,5,3);
 AddPerson(359,13,8,3);
 AddPerson(357,14,20,2);
 SetSceneID(71,5);
 PlayBGM(6);
 MovePerson(112,4,3);
talk(112,"‚Cƒg G ƒoCƒb¡«");
 MovePerson(112,4,0);
talk(112,"‚S‚CŠpƒd¡« ‡O ‚S‚CŠp‚wƒv");
 MovePerson(112,4,2);
talk(112,"ƒv‚b ƒGM¡«u„p¡« G ƒoCS ‚wX¡« ‚r†vS.");
 MovePerson(112,4,1);
talk(112,"ƒv¡«fQ s‚K‚b¡« „Oƒmƒv¡«.");
 MovePerson(112,2,3);
talk(112,"ƒv‚h¡« ˆ`‚b¡« G^ ‚a‚wƒv.");
talk(3,"ƒnˆEŠi, …f…x‚b ‚_…r yLY? ‹D GCa‚C ‚kKLY?",
 1,"nLM, …f ƒY†G‚b …I‚^…e ‚r†vƒP „I†rS ˆnƒ`‚b ƒuGM. z qƒ@ …m`G ˆ|o ‚D‡lGƒv ‡W…c^ n†tY?",
 3,"I‡H ˆ|Š[G‡ILY. ƒ[Šl u ‚aKLM.",
 1,"nLM, ‡L‚XaM. ŠoM, ˆ|S ‚@‚S ƒs…x.");
 MovePerson(1,3,1);
talk(1,"†EƒG …m`.");
 MovePerson(112,3,0);
talk(112,"k, I‡H …IGƒN‚CZ?",
 1,"N‹~‚C„V †O‰HS bŒq‚SD „C†ym?",
 112,"…f‚b ƒWƒW‚f WLM.",
 1,"n, ‚r†vS ŠUˆf ƒsƒt‚wƒ`. N‹~Pm.",
 112,"ƒ[…e‚V‚b ‡Lƒb xƒN‚CZ?",
 1,"ƒv‚b ‚G‚P‚f a[.",
 112,"n! ‡p‚wWLM. ‚G‚U†fGƒN „{ ‚Z‚jƒd I‹~‚h ‚mPKLM. Nƒb qƒ@ …m`Š_ ‚U†fƒP ˆ|Š[S Š^ƒd, „I†rS ˆnƒd…x bƒGƒW ƒY†G‚h …dŠjKLM. ƒ[uaA i q „Oƒmu‚f b‹H‚CZ.",
 1,"qƒ@ …m`ƒP ŒzG‚V[? ‚S‹cm, ƒv‚h D‡z‚K‚C ‚k†ym?",
 112,"ƒA‹mhLM. …fD ƒ[u `‚Eaƒd „O„kKLM. ŠU ‚^…a…w„tLM.",
 1,"ƒ[†{ ‰HŠ_ ƒ{ƒm„S ƒR‚S†h‚VM.");
 ModifyForce(112,1);
 PlayWavE(11);
 DrawStrBoxCenter("ƒWƒW^ ‚^a^ „C„kM.");
 MovePerson( 1,1,1,
 112,1,3);
 MovePerson( 1,11,1,
 112,11,1);
 DecPerson(1);
 DecPerson(112);
talk(3,"n! ^ „q„~‚TZ. …f, Še[ ˆEŠi. ZŠr ƒnˆEŠiG ‹D GCa‚C ‚kKLY?",
 2,"js‚h ƒc…X‚jQ ‚wa‚V‚b Q‚C. ƒnˆEŠiŠ_‚b ƒnˆEŠiƒP `‚EG „Oƒm‚VM.",
 3,"G…eM ƒnˆEŠiG ‡F‡F „l GCB‚C‚V‚b ƒu n‚`LY.",
 2,"ƒ[u „efN ƒUf‚b ƒOuD ƒ{ƒm„S ƒR‚S^…x.",
 3,"„a†yKLM!");
 NextEvent();
 end,
 [310]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(9,25,9,1);
 AddPerson(17,14,9,3);
 AddPerson(18,12,10,3);
 AddPerson(20,10,11,3);
 AddPerson(69,25,15,2);
 AddPerson(77,23,16,2);
 AddPerson(78,21,17,2);
 AddPerson(19,17,13,0);
 SetSceneID(85,11);
 DrawStrBoxCenter("‡m†g ƒP‚r‰R");
 LoadPic(30,1);
 DrawMulitStrBox("¡¡G IŠq vv‚Tƒb ƒQm‚TƒP ‰xb ‚~ƒ}S ‚aŒiƒd ƒQmƒP ˆmS ‚Z‚[ ‡Yf †p„kM. G„S‰l vv‚b ‡k„N ‚B†JS „y‚CPM.*¡¡vvƒP M‚M ƒc…q‚b ‚G‚P …I‚]G „O‚b ˆE‚K, ƒ[uƒd ‚l[ŠbM.");
 ModifyForce(103,9);
 LoadPic(30,2);
talk(9,"ƒQm‚b G†w †UPƒmL G‚W‰` ˆE‚K‚h †R „y‹~M. vj, ƒ[‚_^ ‰q…f ‚TS Gˆnƒd ‚G‚PƒP Nƒ}S ‹Xƒs‚f. ƒ[ ‡Df …bF b‚^‚h Fa†yM.",
 19,"„a†yKLM. ‡mƒv ‚G‚PƒP Nƒ}G ƒOu ‚Tf †T„{ „Va†yKLY?",
 9,"ƒvD ƒ[u `‚EoM„V, ‚Sj‚C ‚G‚P‚f‚b …x^ ƒX …X‚Mf ‚@ƒjM. „N†da‚C …X‚f.",
 19,"k, ‰b ‚TS Gˆnƒd …b_a†yKLM.");
 MovePerson(19,9,1);
 DecPerson(19);
 NextEvent();
 end,
 [311]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 AddPerson(112,10,10,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒN…E ƒP‚r‰R");
talk(54,"‚K‚J, G‡LG ‚J‚XhLY?",
 1,"nLM. ƒWƒW‚f‚b ‚r†vGM. qƒ@ …m`{ ŒzG‚f a‚b‚wƒv.");
 MovePerson(112,3,3);
talk(112,"‚K‚J, ‚J‚XS n‡ILY?",
 1,"n, qƒ@ …m`Š_ ƒR„kS ŠFG[. ‚J‚XS …VƒmA ƒ_ ‹dD G‹a q „OM a‚V„l‚T.",
 112,"ƒ[ŠQKLY. …f‚b ‚J‚X{ [ˆs ˆj‚whLM.",
 1,"I‡JG[! †~ƒm„S ŠU‹k‚wƒ`. ƒWƒW, ‚J‚XS ƒ_Q m†KB ‚K‚C ‚k†ym?",
 112,"ƒ[ƒuG, d^ ‰RoMƒd ˆl„L…I jƒAG n‚`LM. ‚K‚JŠ_ƒW „L‰n MˆQ[‚V‚b „KG Šo†yKLM.",
 1,"ƒ[‹@^¡­¡­?",
 112,"M„V ‚J‚XS …V‚b …Iƒb †@ŠH …y†M„Q ‚kKLM.",
 54,"ƒ[‚_‡z †T‚KA ‚S‹cm?",
 112,"…f‚b ƒ[f o†~ †w„Q‚C ˆfWLM.",
 3,"Fˆ| ƒ[u ‚_†MWLY? …f ‚r†v ‚SZ^ GCWLM.",
 112,"…fD ƒvŠK‚_„S …xƒNƒb „OKLM„V, ‚J‚Xƒb …fƒsM ƒ]G {| TLM.",
 1,"ƒ[‹@^. ŠoM, eƒO, ƒa‚P. o ‚W „l ^ ƒs…x.",
 3,"nGƒd, ‡O ^‡ILY?",
 1,"Gd‚b ‰BnŠXS‚CD ‚Z‡MM. QM^ ƒWƒWƒP ˆ|S ƒRƒmL ‚S‹cQˆe „Vƒv…E†yM.",
 2,"^…x, ƒa‚P. …^‚Pa†E‚f.",
 3,"k.");
 MovePerson( 2,2,2,
 3,2,2);
 MovePerson( 2,1,2,
 3,1,1);
 MovePerson( 2,2,1,
 3,2,1);
 MovePerson( 2,7,2,
 3,7,2);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÙ·ÃÂ¡ÖĞÖî¸ğÁÁ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [312]=function()
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"…I~ ‰Bn[‡I‚V[.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"qƒ@ …m`Š_ƒW ‚s†EaŠVMA †@ŠH ŒG‚OG ‚aS ƒuhLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚^ƒZ …I~ ‰Bn[‡I‚V[.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚^ƒZ …I~ ‰Bn[‡I‚V[.");
 end
 if JY.Tid==112 then--ĞìÊü
talk(112,"‚^ƒZ ‚J‚XS ‚ZŒs [‡I‚V[.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [313]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡X‚e";
 JY.Base["D‚wC"]=0;
 AddPerson(1,9,12,3);
 AddPerson(2,5,11,3);
 AddPerson(3,7,10,3);
 AddPerson(380,27,12,0);
 AddPerson(381,11,13,2);
 SetSceneID(44,8);
 DrawStrBoxCenter("‚J‚X ƒ|ƒ`");
talk(2,"G‡EG ƒ[ ‚J‚XG ‚r‚b †LhLY?",
 3,"ƒ[‰S…l ‚_†Mo ‚r†vG G‹@ ‡Ef „[†M ˆ|hLY?",
 2,"ˆEŠi, ƒO…m …f ‚l…xfQ ƒA‚Sƒs‚V‚CZ.")
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [314]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"G‚Wf‚b „TNY?");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"n, G‚W‰` ‚o [‚b Q ƒvS ŒPPKLM. ¡­¡­n, ƒnˆEŠi. ƒ[u IƒW‡S Œv†^ a‚C …X‡I‚V[.");
 end
 if JY.Tid==380 then--Öî¸ğ¾ù
talk(1,"¡­¡­…f‰S…l ‚uf Œ{‚[B ƒOu‚h „an…^‚CD ˆfa‚b‚T. …f ‚r†vG ŒG‚O‚aG ‚J‚XGM.");
 end
 if JY.Tid==381 then--Í¯×Ó
talk(381,"n, ƒN…EƒP ‚G‚U†fG‚V‚TZ. ‡d‚V„V ƒGMu‡I‚V[. [ƒXƒb …m`ŠiG „T‡ILM.");
 MovePerson(381,4,3);
 MovePerson(381,4,0);
talk(381,"…m`Ši, ƒN…EƒP ‚G‚U†fŠ_ƒW [ŠVKLM.",
 380,"‚M¡­¡­? [, ‚G‚U†fG‚V‚TZ.");
 MovePerson(380,1,1);
 MovePerson( 380,3,1,
 381,3,1);
 MovePerson( 380,3,2,
 381,3,2);
talk(380,"‚G‚U†f, ‚SƒW [‡I‚V[.");
 NextEvent();
 end
 end,
 [315]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"G ‚r†vG ‚J‚XhLY? ‚S[ ˆN‚^‹n†{ ƒshLM„V.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"I‡JG? G…x^ ‚J‚XG‚fƒd? G…x^ ‚J‚XG‚fA ƒWƒW^ {| ‹N‹Na†yKLM.");
 end
 if JY.Tid==380 then--Öî¸ğ¾ù
talk(380,"ˆEŠiS ‹qn[ŠV‚TZ.",
 1,"„i? ƒ[†{ …m`G ‡z‡l …m`G nL‚V[?",
 380,"ƒ[ŠQKLM. …f‚b ƒ[ƒP nƒO d‡yˆRhLM. …fŠs‚b |ˆEd„S, }ˆE d‡y†Zƒb ‚l[fƒW ‹S…jS aƒd …f‚b ‡fƒ_G†B ‚J‚Xƒb Še[ ˆEhLM.",
 1,"‡z‡l …m`ƒb bƒG ‚o „T‚V[?",
 380,"k, n„L ‰Bn[‚C ‚kƒmŠVKLM. ˆEŠiƒb o‚W ƒv^‚VA ˆAd ‰Bn[N‚C …fŠsD ‚Z‹{LM. ‡p‚wWLM.",
 1,"ƒ[‹@^, ‡O „Vƒv‚C ˆfP‚wƒv.");
 NextEvent();
 end
 if JY.Tid==381 then--Í¯×Ó
talk(381,"‡m, …m`G n†m ‚Z†ohLM.");
 end
 end,
 [316]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‡O ‰u‚@‚MG‚TZ. ‚S‹W q ‚aƒmL ‰Bn^‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW ‰Bn^‚V‚CZ. „@ƒR‚S …G†yKLM.");
 end
 if JY.Tid==380 then--Öî¸ğ¾ù
talk(1,"G ƒWƒNS ‡z‡l …m`Š_ ‚BB ‚K‚V†ym?",
 380,"k, …A…w‚V ‚Ba†yKLM. ‹`ƒS ˆEŠi„l…e ‹qnŒr‚f a†yKLM.",
 1,"ƒ[Šl ƒu ‚am. ƒ_^ M‚V [†ym. ƒWƒN„Vƒb ‰@ ‚BB ‚K‚V[. ƒ[†{ ƒA…e^†ym.");
 MovePerson( 2,0,2,
 3,0,2);
 DecPerson(2);
 DecPerson(3);
 PlayBGM(5);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<»ØĞÂÒ°£®>
 NextEvent();
 end
 if JY.Tid==381 then--Í¯×Ó
talk(381,"†ja ^‡I‚V[.");
 end
 end,
 [317]=function()
 if JY.Tid==380 then--Öî¸ğ¾ù
talk(380,"ˆEŠiƒb n„L ‰Bn[‚C ‚kƒmŠVKLM. ‡p‚wWLM.",
 1,"ƒWƒN„Vƒb ‰@ ‚BB ‚K‚V[. ƒ[†{ ƒA…e^†ym.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==381 then--Í¯×Ó
talk(381,"…m`ƒb n„L ‰Bn[‚C ‚kƒt‚wƒv. ‚SƒZ„S ^ƒN ƒu…IY.");
 end
 end,
 [318]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 AddPerson(112,10,10,3);
 SetSceneID(54,11);
talk(112,"‚K‚J, „Nƒg m‚yG ŠXKLM. vv‚TG Gu„S [ƒd „OKLM.",
 1,"I‡JG! vv‚TG!",
 2,"ƒLƒaƒb vjG‚f WLM.",
 3,"vv G …yƒL! ƒQmƒP ˆmS …VƒdD ‚Z…x‚f†M ˆ|j^. †~ƒm„S ~ŒTƒ~…e‡S …x„SM.",
 54,"‚K‚J, …bFS ƒe‚Pa‚V‚CZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×ö³öÕ÷²Ü²Ù¾üµÄ×¼±¸£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [319]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"vv^ vjS ‚Kƒaƒm„S |ƒtƒd, ‚Cƒg ‚_‚TS Gˆnƒd …g†of G‚jŠjM WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"G‚W‰` ƒOuD ‚~ƒ}{ ƒaq^ ‹r‹raL k‚B‹n†{ ‡iaƒd„V „O‚C‚b ‚k†yKLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒQm‚h ‚ao M‚M ƒc…q^ ˆE‚K„S‚TZ. vvƒP ŒT†dƒb ‹[G ‚aKLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"ƒN…E‚h IQ ‚CX‚VM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚SƒW …bFS ƒe‚PaŒs…E WLM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"C‚_^ vv‚TGL ‡t‡LŠW ƒe‚PB…E WLM.");
 end
 if JY.Tid==112 then--ĞìÊü
talk(112,"G‚W ‰jˆlƒb d „T‚vS ƒsb …w„u Šoƒb ƒG‚}hLM. ‚^ƒZ …f‚h …hƒ`^ ‚K‡I‚V[.",
 1,"Šom, ƒ[‚_ƒP „T‚vS @ŠP ƒs‚V[. ƒ[‚_„V ˆ[†ym.",
 112,"ƒdŠOKLM.");
 NextEvent();
 end
 end,
 [320]=function()
 if JY.Tid==2 then--¹ØÓğ
 if talkYesNo( 2,"…b_a‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(2,"‚^‚_‚h FƒfB ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(21,"d2ƒa …g†o ‚B„e","1. vj ‚p…D",40,0,18);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,2,0,4,0,-1,0,
 111,2,2,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 -1,1,3,4,0,-1,0,
 -1,4,2,4,0,-1,0,
 -1,0,2,4,0,-1,0,
 -1,3,1,4,0,-1,0,
 -1,1,1,4,0,-1,0,
 -1,1,0,4,0,-1,0,
 -1,0,0,4,0,-1,0,
 });
 DrawSMap();
talk(2,"ŠoKLM, …g†oƒm„S g_a†yKLM.");
 JY.Smap={};
 SetSceneID(0,3);
talk(112,"‚K‚J, …g†oƒm„S ^‚V‚CZ.");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 18,21,9,3,2,30,3,0,0,-1,0,
 19,19,8,3,2,27,24,0,0,-1,0,
 172,19,10,3,2,27,5,0,0,-1,0,
 123,12,6,3,1,26,11,0,0,-1,0,
 124,12,11,3,1,26,11,0,0,-1,0,
 115,18,9,3,2,27,2,0,0,-1,0,
 256,14,7,3,2,25,2,0,0,-1,0,
 257,14,11,3,2,25,2,0,0,-1,0,
 258,14,4,3,2,24,2,0,0,-1,0,
 259,14,14,3,2,24,2,0,0,-1,0,
 260,17,4,2,2,23,2,0,0,-1,0,
 261,17,14,1,2,23,2,0,0,-1,0,
 262,20,4,2,2,23,2,0,0,-1,0,
 263,20,14,1,2,23,2,0,0,-1,0,
 274,12,7,3,1,25,5,0,0,-1,0,
 275,12,10,3,1,25,5,0,0,-1,0,
 276,16,8,3,2,24,5,0,0,-1,0,
 277,16,10,3,2,22,5,0,0,-1,0,
 278,17,7,3,2,22,5,0,0,-1,0,
 279,17,11,3,2,23,5,0,0,-1,0,
 292,16,6,3,2,23,8,0,0,-1,0,
 293,16,12,3,2,22,8,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"G‚W‰` ƒOuD ‚~ƒ}{ ƒaq^ ‹r‹raL k‚B‹n†{ ‡iaƒd„V „O‚C‚b ‚k†yKLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒQm‚h ‚ao M‚M ƒc…q^ ˆE‚K„S‚TZ. vvƒP ŒT†dƒb ‹[G ‚aKLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"ƒN…E‚h IQ ‚CX‚VM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚SƒW …bFS ƒe‚PaŒs…E WLM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"C‚_^ vv‚TGL ‡t‡LŠW ƒe‚PB…E WLM.");
 end
 if JY.Tid==112 then--ĞìÊü
talk(112,"G‚W‰` …f‚h ‚C‰a‰} ‚K‡I‚V[.");
 end
 end,
 [321]=function()
 PlayBGM(11);
talk(19,"[†q, ŠX‚wƒv. [†G ƒGM„~M. b‚H, ‰q…f ^ƒW ƒLƒP Nƒ}S ‹Xƒs‚f.",
 124,"‚XS …HƒR†yKLM!",
 19,"ƒvŠc‚C ‚^‚_‚b ˆl„LG‚C …X‚f! ‰AƒG „OQ ƒLS ˆn‚SƒRŠbM^ „I‹If ‚ZG†Eˆe ‡G†bQ ŠP‚f! „a†y†sŠm!");
talk(1,"ŠoM, ‡T‚J‚p!!",
 112,"‚K‚J, ‡d‚V ƒGMu‡I‚V[. ƒLƒP gˆES ƒsL vjG ƒOu‚h ˆn‚SƒRGƒ`‚b ‡KWLM. G‚_„S ‰B‚paA ‚n…UWLM. ab ^ƒa ‚o‹J …[…@u ‹JS „QA ƒLƒP gˆES ‚NJ…e„]„u q „OKLM.",
 1,"^ƒa ‚o‹JS ˆ|G[?",
 112,"ƒ[ŠQKLM. G gˆEƒb FAfƒW „QA †Tƒdaƒv AAfƒW „QA I‚jƒd l‡CWLM.",
 1,"[, G‹@ gˆES o„If ƒsƒd Z„]„u ˆFS „anƒ_ML¡­¡­",
 112,"‚SŒJˆe ƒLƒP gˆES ‚NJ…e„]uƒ`A ‚o‹JS ŠP…E oM. ŠP‚f!");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [322]=function()
 if WarMeet(3,125) then
 WarAction(1,3,125);
talk(3,"vv‚T †K „Gƒb ŒNƒR! G‚W‰` ƒ[ˆ} ‚[‚C ‚k†yM! ƒ_^ H‚h ƒq†yM!",
 125,"…fƒuG ƒa‚P„S‚T. m…Zf ‚_†MaM„lL, ƒ_^ o‚W „}B ƒs†yM!");
 WarAction(6,3,125);
 if fight(3,125)==1 then
talk(125,"¡­¡­! ‚o „C†yM, G‚_„S‚b gM! G‰S…l ‚IX „{G…E.",
 3,"Gd „anD ‹z„kM! …ftƒm„S ƒsƒ_ ‚K…X!");
 WarAction(8,3,125);
talk(125,"…v¡­¡­!");
 WarAction(18,125);
 WarLvUp(GetWarID(3));
 else
 WarAction(4,125,3);
talk(3,"¡­¡­");
 WarAction(17,3);
 WarLvUp(GetWarID(125));
 end
 end
 if WarMeet(54,124) then
 WarAction(1,54,124);
talk(54,"†EƒG ‚_ƒa! ƒ_^ C‚_a†yM!",
 124,"…fw v‡SG n†m^? ¡­¡­bƒGƒW ‚nƒo‚h „n„QA ƒ_ GŠKD wu „aƒ`‚C†y‚C. ŠoM! v‡S, G b‚HG C‚_a…X.");
 WarAction(6,54,124);
 if fight(54,124)==1 then
talk(54,"†gS …Hn‚f!!");
 WarAction(8,54,124);
talk(124,"…v¡­¡­!");
 WarAction(18,124);
 WarLvUp(GetWarID(54));
 else
 WarAction(4,124,54);
talk(54,"‚_†Ma‚wƒv!");
 WarAction(17,54);
 WarLvUp(GetWarID(124));
 end
 end
 if GetFlag(138) then
 
 elseif between(JY.Death,257,262) then
 SetFlag(138,2);
 PlayBGM(11);
talk(19,"[†q, [H‚f! ‚G‚P! ŠoM, ‚B‚T ‡T‚J‚p! ‚G‚P‚TS ‚aŒi‚f!");
 WarModifyAI(18,1);
 WarModifyAI(19,1);
 WarModifyAI(172,1);
 WarModifyAI(115,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(258,1);
 WarModifyAI(259,1);
 WarModifyAI(260,1);
 WarModifyAI(261,1);
 WarModifyAI(262,1);
 WarModifyAI(263,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(278,1);
 WarModifyAI(279,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 DrawStrBoxCenter("ƒLG ‚J‚pS ‚VJPM!");
 elseif between(JY.Death,263,264) then
 SetFlag(138,1);
 PlayBGM(11);
talk(19,"I‡JG! ‚G‚P‚TG ‚SŠS †VgˆFS ‚o†M ˆ|j^!? ƒn…IGM! …f‡EG ŒCuA ƒOu‚b d‚_„S …A‚pX q ‚aM!!",
 112,"‚K‚J, G„S‰l ƒLƒb Šcu‡z ‹vu^ ƒW„S‚h ‰B…R q ‚aQ „C„kKLM. †M…~f Œ{nŠP ƒLS IŠS‚j‚V‚CZ.");
 WarModifyAI(19,6,16,13);
 WarModifyAI(172,6,14,6);
 WarModifyAI(292,6,14,9);
 WarModifyAI(277,6,18,8);
 WarModifyAI(278,6,20,11);
 WarModifyAI(279,6,21,6);
 WarEnemyWeak(2,2);
 DrawStrBoxCenter("ƒLƒP ‚C‚g^ ‚NJ…eƒFM!");
 PlayBGM(10);
 end
 if JY.Status==GAME_WARWIN then
 --DrawMulitStrBox("ÔÚÕâÀï£¬ÊÂ¼şÊı¾İµÄ¹¹ÔìÉÏ²»ÄÜÊ¹ÓÃ£È£Å£ØÊ¤Àû£®»¹ÓĞ£¬Ò»°ãÓÎÏ·Íæµ½ÕâÀïÊ±Ó¦¸ÃÊÇ³ö´íÁË£®");
talk(19,"dƒGŠJ¡­¡­! GuŠ} „{ƒb Œ{„gM! ‚B‚T, …C…Da‚f!!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡vjG ƒA…eƒvƒd ‚G‚P‚TG vj‚TS I‹xŠjM.");
 GetMoney(5000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°£°S …V„kM!");
 if JY.Base["ÊÂ¼ş"..138]==1 then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [323]=function()
 SetSceneID(0,3);
talk(2,"‡m, ƒWƒWfQ „d‚DPKLM. †~ƒm„S †|†}o ‰jˆlG„kKLM.",
 3,"ƒv„SƒW‚b DI‚C „a q^ ‚a‚T¡­¡­",
 112,"aaa, ‰jˆlƒb Iƒ}„Vƒm„S G†r q ‚a‚CZ. ƒ[†{ ‚K‚J, ƒN…E„S ‰Bn^‚V‚CZ.");
 NextEvent();
 end,
 [324]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d2ƒa¡¡d‡y‚J‚X …b‚r";
 DrawStrBoxCenter("d2ƒa¡¡d‡y‚J‚X …b‚r");
 LoadPic(14,1);
 DrawMulitStrBox("¡¡‚G‚P^ vj‚TS „_„kM‚b m‚yƒb ‰b vvƒP ˆHf ƒR‚S‰tM. vjƒP ƒsƒd„S ƒsn ‚G‚P^ ƒWƒW‚h …V‚S „@G ‚IBg ƒuG ‡L‚XPM.*¡¡Gf vv‚b ‚^a F„m{ ‰HŠ_ ƒWƒW‚h ‚G‚PfQƒW Œl‚S ‹^S „T‚uS bƒPPM.");
 LoadPic(14,2);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Óë¹ØÓğÌ¸ÌÖÏÂÒ»²½Ö®ÊÂ£®>
 NextEvent();
 end,
 [325]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 AddPerson(112,10,10,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒN…E ƒP‚r‰R");
talk(2,"ˆEŠi, „T‡ILY? …Xƒl ŠU‹kKLM. ƒWƒW^ ˆEŠiŠ_ …w„u ˆ|Š[G „O‚b ‡KWLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [326]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒWƒW^ ˆEŠiŠ_ …w„u ˆ|Š[G „O‚b ‡KWLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒWƒW, „Nƒg o G…EƒG‚h ƒnˆEŠiŠ_D ˆ|Š[…wuQ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒWƒW^ ‚K‚JŠ_ …w„u ˆ|Š[G „O‚b ‡KWLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"ƒWƒW^ ‚K‚JŠ_ …w„u ˆ|Š[G „O‚b ‡KWLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"ƒWƒW^ ‚K‚JŠ_ …w„u ˆ|Š[G „O‚b ‡KWLM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"ƒWƒW^ ‚K‚JŠ_ …w„u ˆ|Š[G „O‚b ‡KWLM.");
 end
 if JY.Tid==112 then--ĞìÊü
talk(112,"Nƒb ‚SŠcLŠ_ƒW ƒsƒ_ƒN ƒWƒNS …HƒtKLM. vvfQ ŒE‹Q‹u „T‚VM‚b ƒ_„oG„kKLM.",
 1,"I‡JG[!",
 112,"‚SŠcLŠ_ƒW ƒk„S„Ea‡ILM. ‡iƒa Œr…e ^ƒd Š]KLM. „y…X ŒMƒ_ƒG ‚Sƒ`‡S ˆ|Š[G[ƒv ‚^ƒZ ‹Xƒv‚b ƒuS ‡mˆyB ‚K‡I‚V[.",
 1,"ƒWƒW, ‚Z…xƒP FƒsM „lo ƒuƒb ‚am. ‚SƒW ‚SŠcŠiS Œr…e ^‚V[. ƒOu‚b ‡O „VƒS ƒSG „OS ƒuG[.",
 112,"‚K‚J, ˆUˆU¡­¡­ ‡N‚rWLM!");
 NextEvent();
 end
 end,
 [327]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒWƒW, ŠU ^‚V[!");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒWƒW, ‚SŠcŠiŠ_ yDa‚V[!");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‰HŠ_o ‚V…yƒb Cƒtƒmƒv †~ƒm„S ˆB†Efm.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚Z‹n†{ qƒ@ …m`Š_ƒW ‚s†EB ‰HŠ_ ‚K‚JS ‰IQ „C„k‚b…h †~ƒm„S n‡PKLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"ƒWƒW‚b ƒe‚@hLM. †~ƒm„S n‡PKLM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‡m, ƒn ‡YNG„SM.");
 end
 if JY.Tid==112 then--ĞìÊü
talk(112,"‚K‚J, ‡N‚rWLM. dDfƒW b…e‡LƒP ‹I†rG „A„daƒG‚h Œf†yKLM. ˆUˆU¡­¡­ ‚o‡}ŠW „T‡I‚V[.");
 MovePerson(112,7,2);
 NextEvent();
 end
 end,
 [328]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ƒWƒW‚h ƒsƒ_ƒG n‹]„Ea‚V‚b …X‚M ŠU …FLM. ‡mƒv GƒuD ‡S‚XGL …X‚MS ƒr‡I‚V[.");
 end
 if JY.Tid==3 then--ÕÅ·É
 DrawMulitStrBox("‚K‚J!!");
talk(3,"„i? ƒWƒWƒP ƒcmu^ nLŠm?");
 MovePerson(112,10,3);
 NextEvent();
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"js‚h aƒv ŒO„kƒmL ‚K‚JƒP †dFS ŠIn„tLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚Z‹n†{ qƒ@ …m`Š_ƒW ‚s†EB ‰HŠ_ ‚K‚JS ‰IQ „C„k‚b…h †~ƒm„S n‡PKLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"ƒWƒW‚b jsŠbƒmL †~ƒm„S n‡PKLM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‡m, ƒn ‡YNG„SM.");
 end
 if JY.Tid==112 then--ĞìÊü
talk(112,"‚K‚J, ‡N‚rWLM. dDfƒW b…e‡LƒP ‹I†rG „A„daƒG‚h Œf†yKLM. ˆUˆU¡­¡­ ‚o‡}ŠW „T‡I‚V[.");
 end
 end,
 [329]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒWƒW^ ‚SŠS M‚V ‰BnŠXSY?");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒWƒW, ‚_…r I‡H …IG[?");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒWƒW, I‡H …IG[?");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"ƒWƒW, I‡H …IG[?");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"ƒWƒW, I‡H …IG[?");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"ƒWƒW, I‡H …IG[?");
 end
 if JY.Tid==112 then--ĞìÊü
talk(112,"d, d^ nY ƒ@‚UG ‚a‚S ‚K‚JŠ_ o ^‚C ˆ|Š[…wu‚b ƒuS Šk„kKLM.",
 1,"I‡H …IG[?",
 112,"‚^ƒZ ‚J‚XS ‰RB [‡I‚V[. ‚J‚XG ‚K‚JS ‚nB …IoMA …fƒsM {| ƒn „@G Š} ƒuhLM.",
 1,"„a†ym. ƒOu‚h G‰S…l …`ƒ`B ‚K‚b ƒ[ …X‚Mf ƒs†CaƒG ‚nBƒW‚fD …A…w‚V ‚J‚XS EƒDa†ym.",
 112,"k, ƒ[†{ ‚K‚JŠ_ƒW‚b ‚^ƒZ ˆuv†da‡I‚V[.");
 MovePerson(112,10,2);
 DecPerson(112);
 ModifyForce(112,0);
talk(1,"ŠoM. ƒWƒW^ …fu ‚s†EaL ŒG‚O‚aS ƒuGM. eƒO, ƒa‚P. ‡X‚eƒm„S …yM.",
 3,"nGƒd, ‡O ^‡ILY!",
 1,"‚S? ƒa‚P, ˆf…Xˆmo ‚Z†oG‚wƒv.",
 3,"‡i…Ba‚CZ. ‰r‰l ƒo ‚W[hLM.");
 NextEvent();
 end
 end,
 [330]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠiŠ_ƒW G†w ‚[ ‚WGƒv ^ŠVKLM. ‚Cƒvˆj ƒuƒb n†m‚CZ. ‚J‚XG ˆEŠiS ‰Xa‚b ƒuƒb n‚`LY.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚J‚X „Gƒb D„]ƒG^ js…I u ‚aKLM. ƒnˆEŠiƒb ^‚C …X‚Vƒd d^ ˆnƒd [†yKLM.",
 1,"HI I‹~aM. ƒ[uBƒW‚b ‚o ˆYM! ƒa‚P, H‚b ‚i‚f[‚C …X‚f. ƒv‡z eƒO ŠeG ^†yM.",
 3,"¡­¡­‚[ ˆEŠiG ^‚V‚b…h …f„V ‚o ^‚b ƒuƒb Du^ nL‚CZ. …fD ^†yKLM.",
 1,"ƒ[ŠQMA …m` ‹IfƒW I‹~‚h ‚mBƒW‚b ‚o ˆYM.",
 3,"kk, „a†yKLM.");
 MovePerson( 2,2,2,
 3,2,2);
 MovePerson( 2,1,2,
 3,1,1);
 MovePerson( 2,2,1,
 3,2,1);
 MovePerson( 2,7,2,
 3,7,2);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Èı·ÃÂ¡ÖĞÖî¸ğÁÁ>
 NextEvent();
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"…f‚b ‚K‚JƒP ‡L‚^‚h ‚i‚h ŠFhLM. ‚J‚XG „sZaM bƒGƒNMA ƒ]‚_„S a‡I‚V[.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"qƒ@ …m`f ƒWƒWY‚C „@‰l ‚s†EPƒmL ŒG‚O‚aS ƒuhLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"ƒWƒWƒsM ˆc‚SƒvMA †~ƒm„S ‚_†Mo js†y‚CZ. ‡q…h Fˆ| ƒ[ŠlYZ?");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‡m, iNŠW ƒWƒW‚h ‚_ƒNX js^ „sZaŒI WLM.");
 end
 end,
 [331]=function()
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‡X‚ef ^‚V‚b ƒuG ‰r‰l ƒo ‚W[„S‚TZ.",
 1,"‚A ‚W †e ‚WG‚fD ‚J‚XS ‚ZŒs [†yM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚^ƒZ ‡z‡l …m`S ‹pƒd [‡I‚V[.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"Šoƒb m‚yS ƒGMu†yKLM.");
 end
 if JY.Tid==83 then--¼òÓº
talk(83,"‚^ƒZ …I~ ‰Bn[‡I‚V[.");
 end
 end,
 [332]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡X‚e";
 JY.Base["D‚wC"]=0;
 AddPerson(1,9,12,3);
 AddPerson(2,5,11,3);
 AddPerson(3,7,10,3);
 AddPerson(381,11,13,2);
 SetSceneID(44,8);
 DrawStrBoxCenter("‚J‚XƒP ƒ|ƒ`");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [333]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"[ƒXƒb „TƒN ‚Z†oG‚T. {…B ‚J‚Xƒb ‚S†A jƒA…IY. „Vƒv ƒsƒd G…EƒGa…x.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…M, ‚J‚X ƒ[…x^ ‹U‹VWLM. [ƒXƒb ^…GS Œz„} ‹^†yKLM.");
 end
 if JY.Tid==381 then--Í¯×Ó
talk(381,"n, ‚G‚U†fG‚V‚TZ. ‚SƒW [‡I‚V[.",
 1,"‚J‚X …m`ƒb „T‚V[?",
 381,"k, ‚Cƒg ‰i‡dS ‚KI‡ILM. Z„E …wu†yKLM.",
 1,"ƒ[…e‚C …X‚V[. ‚KI‚VQ ‚[‚V[. ƒv‚b bƒGƒW ƒGMu†ym.");
 NextEvent();
 end
 end,
 [334]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(1,"…x„pƒRƒb ‹wfƒW ƒGMuQ. ƒv‚b bƒGƒW ƒGMu†yM.",
 2,"„a†yKLM. GƒsQ ƒa‚P, ‹wƒm„S ƒv^ƒo.",
 3,"kk.");
 MovePerson( 2,0,2,
 3,0,2);
 DecPerson(2);
 DecPerson(3);
 NextEvent();
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚J‚X G…x^ ‡dS ‰xMƒdZ? HI I‹~WLM. d^ ZƒO†yKLM.",
 1,"ƒa‚P, Q ŒU†E‚f! I‹~‚h ‚mBƒW‚b ‚o ˆYM.",
 3,"ŒL, „a†yKLM. ˆ| ‚k†yKLM.");
 end
 if JY.Tid==381 then--Í¯×Ó
talk(381,"Fˆ| ZƒO‚C ‚knD „C†yKLY?",
 1,"ƒ[ŠQm, †KƒP„Q …X‚V[.",
 381,"‚M¡­¡­.");
 end
 end,
 [335]=function()
 if JY.Tid==381 then--Í¯×Ó
talk(381,"nGƒd, ‚G‚U†f. n„L ‰Rm‚h ˆf PKLM. ‰Rm‚h BD „C†yKLY?",
 1,"n, ƒA‹mG[. ^ƒW ‰Rma‚V[. †KƒP„Q …X‚V[.",
 381,"ƒ[†{ N‹~a†yKLM.");
 MovePerson(381,6,3);
 NextEvent();
 end
 end,
 [336]=function()
 if JY.Tid==381 then--Í¯×Ó
talk(381,"nGƒd, ‚G‚U†f. n„L ‰Rm^ ‹[ƒv‚C ‚kƒtKLM.");
 MovePerson(381,3,0);
 NextEvent();
 end
 end,
 [337]=function()
 if JY.Tid==381 then--Í¯×Ó
talk(381,"nGƒd, ‚G‚U†f. n„L ‰Rm^ ‹[ƒv‚C ‚kƒtKLM.");
 MovePerson(381,6,1);
 NextEvent();
 end
 end,
 [338]=function()
 if JY.Tid==381 then--Í¯×Ó
 MovePerson(1,5,3);
talk(1,"‡m, n„L Z‚C ‚kƒmŠV‚wƒv. …fu ‚|…BŠW ‡dˆe ‚ZK„V ƒsnD G ‚r†vƒb ‡L‚X ‚_†Mo jƒAGM.");
 AddPerson(3,7,10,3);
 MovePerson(3,3,3);
talk(3,"G…x^ n„LD …x‚b „fhLY? „l‚b ˆf †~†yKLM. †Lf …dS ‹^n …x‚b‚C ‚o …x‚b‚C ƒs†yKLM!");
 AddPerson(2,5,11,3);
talk(2,"ƒa‚P, ‰H‚^„S †^‚C …X‚f!");
 MovePerson(2,3,3);
talk(2,"HI ƒ{†PaM. E‚BŠW „O†E‚f. ƒa‚P, ˆEŠi ˆ|Š[S ‚i‚jQ.",
 3,"n, „a†yKLM. ˆ| ‚kƒmA Š} ƒu n‚`LY. …f ƒd‡Co …x „GƒmL.");
 MovePerson( 2,3,2,
 3,3,2);
 DecPerson(2);
 DecPerson(3);
 NextEvent();
 end
 end,
 [339]=function()
 if JY.Tid==381 then--Í¯×Ó
talk(381,"nGƒd, ‚G‚U†f. n„L ‰Rm^ ‹[ƒv‚C ‚kƒtKLM.");
 MovePerson(381,6,2);
 NextEvent();
 end
 end,
 [340]=function()
 if JY.Tid==381 then--Í¯×Ó
talk(381,"nGƒd, ‚G‚U†f. n„L ‰Rm^ ‹[ƒv‚C ‚kƒtKLM.");
 MovePerson(381,6,3);
 NextEvent();
 end
 end,
 [341]=function()
 --talk( 381,"°¦£¬Áõ±¸È¥ÄÄÄØ£¿");
 if JY.Tid==381 then--Í¯×Ó
talk(381,"n, ‚G‚U†f. ‰Rm‚h M …X‡RKLM.");
talk(126,"Q „O†sŠm?",
 381,"n, …m`ŠiG ‚^‚j‡ILM. ‡d‚V„V ƒGMƒ` ‚K‡I‚V[.");
 MovePerson(381,6,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [342]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡X‚e";
 JY.Base["D‚wC"]=0;
 AddPerson(1,4,8,3);
 AddPerson(381,19,15,0);
 AddPerson(126,21,14,1);
 SetSceneID(45);
talk(126,"†EƒG †u^ „O†sŠm? ‚S†A …{jG ŠX†sŠm?",
 381,"‚G‚U†fG‡ILM.",
 126,"I‡JG? ‚SŠS gJ ƒv‚h ZƒO‚C ‚kƒt†sŠm?",
 381,"‚G‚U†fŠ_ƒW ZƒO‚C ˆ|‚f aŠVKLM.",
 126,"„a†yM.");
 MovePerson(126,2,1);
 MovePerson(126,2,2);
talk(126,"n, ‚G‚U†f. [ƒN „{ Œ{„gMƒd‚b aƒv ‰i‡dS …xƒd „O„kƒmL †~ƒm„S I‹~PKLM. ‡p‚wWLM. …x, ‚oƒm„S …w‚V‚CZ!");
 MovePerson( 126,2,0,
 1,2,3);
 MovePerson( 126,1,0,
 1,1,0);
 MovePerson( 126,1,2,
 1,1,0);
 MovePerson( 1,0,3);
 NextEvent();
 end,
 [343]=function()
 local menu={
 {"¡¡ r‚bM",nil,1},
 {"¡¡ Š^‚bM",nil,1},
 {"¡¡ EƒDoM",nil,1},
 {"¡¡ „IƒAS UƒjM",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"ƒ[†G, I‡H ˆ|Š[S …w„uYZ?");
 elseif r==2 then
talk(126,"b…e „y‹~ ˆuS ‰i…c‚S G †u…co ‡EY‚C [ŠVƒmL IˆA^ ƒs†CB …wƒ`…E†y‚CZ.");
 elseif r==3 then
talk(126,"‚Sd ƒWƒNS Fƒd ƒv‚f‚h ‚waƒd †eƒ{S †Z†da‚V‚b ‚U†fƒP ƒ]f ‰KG ‡N‚lPKLM. ‡mƒv …f‚b ƒvG ‚Suƒd n‚b ƒU^ ‚a‚S DˆlG „C‚C ˆfX ‡KWLM.",
 1,"‡i„Q ‚km. qƒ@ …m`{ ƒWƒW^ ƒ[‰S…l „@‰l ƒ[‚_‚h ‚s†EPƒmL ƒ[ƒRG ŒG„u u ‚am.",
 126,"ƒ[‡LƒRƒb ‚Z‚[ ˆc‚S‚q jƒAGƒv …f‚b oŠt ƒW`f ‚Cƒv‚C ‚kKLM. ‚sa‚_‚r‚h baƒGf‚b „@G †w„Q‚C ˆfWLM.",
 1,"‚_ƒa‚^^ ƒ@ƒoƒP ƒGs‚h ƒBƒdD ‰RIS „[…EfƒW ‰u„CG ƒsƒ_ML †~ƒm„S n‡Pm. ‚^ƒZ „[S ƒ_ƒ`‡z ƒv‚h D‡z‚K‚V[.",
 126,"‚G‚U†f, ƒ[ŠQMA ƒ~ƒ~„SƒP „@ƒm„S vvf ŠGE „ND‚h „aƒ` …wu†yKLM.");
 NextEvent();
 elseif r==4 then
talk(126,"‚G‚U†f, ‚SŠS †h…xƒG „IƒAS Uu‡ILY. ‚^ƒZ ƒd†K‚h …w‡I‚V[.");
 end
 end,
 [344]=function()
 local menu={
 {"¡¡ r‚bM",nil,1},
 {"¡¡ Š^‚bM",nil,1},
 {"¡¡ EƒDoM",nil,1},
 {"¡¡ „IƒAS UƒjM",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"vvf ŠGE „ND‚fL, ƒvD vvf ŠGE q „OM‚b ˆ|G[?",
 126,"ƒ[ŠQKLM. |ƒdƒ|ƒ`f ‚_o d ƒs†ChLM.");
 NextEvent();
 elseif r==2 then
talk(126,"ƒJƒKƒm‚V†yKLY? ŠU ƒR‚S ‚K‡I‚V[.");
 elseif r==3 then
talk(126,"¡­¡­£®");
 elseif r==4 then
talk(126,"‚G‚U†f, ‚SŠS †h…xƒG „IƒAS Uu‡ILY. ‚^ƒZ ƒd†K‚h …w‡I‚V[.");
 end
 end,
 [345]=function()
 local menu={
 {"¡¡ r‚bM",nil,1},
 {"¡¡ Š^‚bM",nil,1},
 {"¡¡ EƒDoM",nil,1},
 {"¡¡ „IƒAS UƒjM",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"…f‚b ƒ[…f Fƒ{f ƒs†CX ŠF M‡M ƒ]ƒb ‚aKLM.");
 elseif r==2 then
talk(126,"vv‚b ‚s‚V‡z j@‚h …Vƒd †e„V ‚_‚TS †E†s„~ƒmL ‚Cƒgƒb ŠGE q ‚aKLM. ‡Oo ‚l[‚b ‡YƒT |‚_‚h G‚S ‚^‚IaL G †J‚V ‡iƒaƒb „}‹a q ‚aKLM.",
 126,"G ˆE‚K‚b ˆmG ƒGŠK‚Cƒd „W„wG „KuaL aƒXG ‚U†fŠ_ ƒ_uƒN ‡EG‚f X „VWLM. ‡Oo ˆE‚K ƒW‹J …S‚K‚b ‚s…BƒP Z†DG†B †eƒ{G ‹r‹raƒd ƒv‚f^ ‚IWLM.",
 126,"ˆE‚K‡z …S‚K‚h lB IQ M‚C‚VA ‡kƒm„S vvf ŠGƒWƒd ‚lƒm„S ‡Y‡bS ‡fS q „OKLM.",
 1,"‚sa‚h Gƒm„S ƒv†u…x‚b ˆ|G[?",
 126,"ƒ[ŠQKLM. ‚sa‚h Gƒm„S ƒv†uƒ`A vv‡z ‡Y‡bG ƒW„S ŠGƒWQ B…E WLM. GƒuG ‚sa|‡L‚C„ThLM.");
 NextEvent();
 elseif r==3 then
talk(126,"¡­¡­£®");
 elseif r==4 then
talk(126,"‚G‚U†f, ‚SŠS †h…xƒG „IƒAS Uu‡ILY. ‚^ƒZ ƒd†K‚h …w‡I‚V[.");
 end
 end,
 [346]=function()
 local menu={
 {"¡¡ r‚bM",nil,1},
 {"¡¡ Š^‚bM",nil,1},
 {"¡¡ EƒDoM",nil,1},
 {"¡¡ „IƒAS UƒjM",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"‡mƒv ˆE‚KƒP ‚G…q‡z …S‚KƒP ‚Gƒaƒb ‚Z‚[ ƒv‡z „Gƒb TˆjG[. „y…X ƒ[ƒRƒP ˆmS Šf„hS q‚b ‚am.",
 126,"ƒ[ŠQ‚C ‚kKLM. ‚G…q‚b ‚~‡Cab [†G †j‚C ˆfX ƒuGL ‚U†fŠ_ƒW ƒ[ …xu‚h GƒmŒsD …ZdŠ} ƒuG ‚aKLM. ‡Oo ‚Gƒaƒb „c‚Tƒm„S GŠKŠgƒmL ƒ[‚h ŠP †eƒ{S ‚wa‚VA …XˆmŠW ‡N‚r‚h …HƒmN ƒuhLM.");
 NextEvent();
 elseif r==2 then
talk(126,"‚sa‚h Gƒm„S ƒv†uƒ`A vv‡z ‡Y‡bG ƒW„S ŠGƒWQ B…E WLM. GƒuG ‚sa|‡L‚C„ThLM.");
 elseif r==3 then
talk(1,"‡z‡l …m`, ƒv‚h D‡z‚K‚C ‚k†ym?",
 126,"…f‚b [†G HS ‡yn ŠXƒd G‹@ ŠdS ŠonWLM. b…e „y‹~ ˆuS ‰i…c‚S [ŠVƒmƒv ‰HŠ_ ‡y q‚b ‚aKLM.");
 elseif r==4 then
talk(126,"‚G‚U†f, ‚SŠS †h…xƒG „IƒAS Uu‡ILY. ‚^ƒZ ƒd†K‚h …w‡I‚V[.");
 end
 end,
 [347]=function()
 local menu={
 {"¡¡ r‚bM",nil,1},
 {"¡¡ Š^‚bM",nil,1},
 {"¡¡ EƒDoM",nil,1},
 {"¡¡ „IƒAS UƒjM",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"‚LƒmA H ‡yƒd ‚P [A ‚u F‚b G‡E `ˆdG d ƒ{Ff ŠGKLM.");
 elseif r==2 then
talk(126,"d ˆ|ƒb bƒGY‚ChLM.");
 elseif r==3 then
talk(126,"¡­¡­£®");
 elseif r==4 then
talk(1,"ƒ_ s‚K„S‚b „Nƒg aƒN ˆ|Š[G oƒUŒm ‹d„V „Gm. ‡mƒv …m`G ‡X‚efƒW oƒw`S ‰u„CG ƒsˆZMA „V†eƒ{ƒb ‚SŠS „C†ym? ƒ[ `‚E„V aA¡­¡­ ‚NˆU¡­¡­.",
 126,"„a†yKLM. ‚U†fƒP ƒ]G IƒRu‚C ‚k‚b o „@S MB ƒs„sa†yKLM.");
 PlayBGM(7);
talk(1,"[! ƒv‚h D‡z‚K‚V†ym. ƒdŠOm.");
 ModifyForce(126,1);
 AddPerson(380,2,9,3);
 MovePerson(380,4,3);
 MovePerson(380,1,0);
talk(380,"ˆEŠi, ‰BnŠXKLM.");
 MovePerson(126,1,1);
talk(126,"ˆRn, ƒv‚b o‚l‚o ‚G‚U†fS ƒs„sa†yM. H‚b G‡E HS ŠU ‚C‰J†E‚f. ‚JS Gƒ^‚b ƒS ‰Bn[…X.",
 380,"„a†yKLM.");
 AddPerson(2,6,9,3);
 AddPerson(3,4,10,3);
 DrawSMap();
talk(3,"‚J‚XŠ_ƒW ‡z ‚K‚VL †~ƒm„S ŠU‹kKLM.");
talk(2,"ƒ[†{ ƒN…E„S ‰Bn†h‚VM.");
 DrawMulitStrBox("Guab d‡y„Xƒb ‚G‚PƒP ‚T‚r^ „C„kƒd, G…C G ƒv‚fƒP †J‚r‚b d‡y„XƒP ‚wC‚_„S U…e^Q ˆYM.");
 NextEvent();
 end
 end,
 [348]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d2ƒa¡¡vv …gF";
 DrawStrBoxCenter("d2ƒa¡¡vv …gF");
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(383,7,8,3);
 AddPerson(9,14,9,3);
 AddPerson(17,19,8,1);
 AddPerson(19,21,9,1);
 AddPerson(20,23,10,1);
 AddPerson(69,9,14,0);
 AddPerson(77,11,15,0);
 AddPerson(78,13,16,0);
 AddPerson(112,27,18,2);
 SetSceneID(84,11);
 DrawStrBoxCenter("‡m†g †X‚B");
talk(9,"ƒWƒW, G‚Wf ‚G‚P^ ‚J‚XS …V„kM„l‚T. ‚J‚Xƒb ‚S†A jƒAj^?",
 112,"‚J‚Xƒb …fƒsM „V †c‚b ˆc‚S‹_LM. nL, ƒ[ GC…I ƒuhLM.",
 9,"ƒ[‚_‚b vjS ‚SƒjŒi‹n†{ „Dƒj ‚r†vG[. ƒ[‹@ ƒ[‚_^ ƒ[u ˆ|aL ‚J‚Xƒb ‚_†Mo jƒAj ‚Z†oG‚T.");
 MovePerson(17,4,3);
 MovePerson(17,2,1);
 MovePerson(17,3,2);
talk(17,"‚K‚J, ƒ[ I‡H ˆ|Š[G‡ILY. d^ …gFab ‚J‚XƒP ƒcS ƒq‚S ƒU„Q†yKLM.",
 9,"[, ¡­¡­ŠoM! G ƒG‚}f ‚G‚P‚h ‚aoM.",
 383,"ƒ[ƒuƒb nL „C[!");
 MovePerson(9,1,1);
 MovePerson(9,0,2);
talk(9,"ŠDa, I‚S‚f aŠVKLY? ‚G‚P‚b …A‚dS …Iƒm‰m †JƒLhLM. ƒ[‚h „Q‚b ƒuS …A‚_aƒN†M ˆ|hLY?",
 383,"¡­¡­£®",
 9,"ŠDa, ‚G‚P‚h „Q‚b ƒuƒb ƒv‚fƒP ƒw@‚h ‚n‰HhLM. ƒ[…eL ‚^ƒZ ‰S‰rS ‚Xa‚b vƒW‚h ƒ_ƒ` ‚K‡I‚V[.",
 383,"¡­¡­£®",
 9,"ŠDaŠ_ƒW …_…r^ „K„Q ‚kƒmƒN ‡KaL ‚o†daƒd ‹]‡I‚V[. d^ ‚_ƒN ‚XS ƒ_u†yKLM.",
 383,"¡­¡­£®");
 MovePerson(383,1,1);
 MovePerson(383,2,3);
 MovePerson(383,1,0);
 MovePerson(383,12,3);
 DecPerson(383);
 MovePerson(9,0,3);
talk(9,"a…C‡], ƒ_^ ‚Ud‚h ‚_ƒNB ‚XoM. Œa‚V ‚TS Gˆnƒd ‚G‚P‚h ‚aŒi‚f.",
 17,"k! ‚XS …HƒR†yKLM! t‚Bƒs‚h ƒGMƒ` ‚K‡I‚V[!");
 MovePerson(17,13,3);
 DecPerson(17);
talk(112,"¡­¡­£®");
 JY.Smap={};
 SetSceneID(0);
talk(17,"‚G‚P, …ftƒm„S ƒsƒ_ ‚K…X! ‚B‚T ƒv‚h ‚i‚f ‚Bga‚f!");
 LoadPic(15,1);
 DrawMulitStrBox("Guab a…C‡]S …m‡Wƒm„S o vvƒP …gFG ‚VJ„C„kM.");
 LoadPic(15,2);
 NextEvent();
 end,
 [349]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(126,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(128,9,15,0);
 AddPerson(117,7,14,0);
 AddPerson(369,10,10,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒN…E ƒP‚r‰R");
 DrawMulitStrBox("vv^ …gFS ‚VJPM‚b m‚yG ‚G‚PfQ ‚BBƒFM.");
talk(2,"ˆEŠi, vv‚TƒP Fƒo‚h †j‰X…e ‰tŠB p…x^ ‰BnŠXKLM. G…EƒG‚h ƒR‚S ƒs‚V‚CZ.");
 --Ê¾ÈÎÎñÄ¿±ê:<ÓëÖî¸ğÁÁµÈÌ½ÌÖÏÂÒ»²½ÔõÃ´°ì£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [350]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"vv‚TƒP Fƒo‚h †j‰X…e ‰tŠB p…x^ ‰BnŠXKLM. G…EƒG‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ZŠr vv^ …x‚K ŠPƒR‚S[‚b…h, ‡O [ƒ`‚b ƒu…IYZ?");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒO…m p…xƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚~‚rƒRƒP ˆDƒxƒb …X‡RƒmL ˆAdˆe …bFB ƒLS ŠGS q „OKLM.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"vv‚b ‚C‚q‚Wf ƒFƒmL Gd ˆf [‚b ƒu n‚`LY?");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"vjS ‚cJƒ_‚C ˆfaA vv‚fD ˆ{†jS ƒ_…E‚CZ.");
 end
 if JY.Tid==369 then--Îä¹Ù
talk(369,"‚K‚J, ‚TFS nŠnLM. vv‚TG G†w ˆl„LŠbKLM. ‚Kƒaƒb a…C‡]G†B ƒOƒg{ G‚BD ‰HŠ_hLM.");
 NextEvent();
 end
 end,
 [351]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEƒo^ Šo‚C ‚k‚wƒv. ‚SŠSaA Šo†ym?");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"n, ˆEƒo^ ‚n†PWLM. Gd ‚J‚X …m`Š_ƒW „T‚uS ƒ_‚KŒs…E†yKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"G‚W vv‚Tƒb ‚[ƒ`…[ ƒuG ‚aKLM. M„V¡­¡­.",
 1,"M„V? M„V I‡JG[?",
 126,"M„V eƒOŠi{ ƒa‚PŠiG d ‚XS ‚i‚j‚C ‚kƒmNY …`ƒ`ŒjLM. ab ‚K‚JŠ_ o ^‚C ‰RG „OƒmL, ‚K‚JƒP ~ˆVS Œfƒ` ‚K‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×¼±¸³öÕ÷Ó­»÷²Ü²Ù¾ü>
 NextEvent();
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ‚SƒW ‚_‚uS ƒoƒOŒs…E WLM.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚K‚J, ‚SŠSXYZ?");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"vv^ ‚_‚TS „jƒmL ‚SŠSXYZ?");
 end
 if JY.Tid==369 then--Îä¹Ù
talk(369,"vv‚TƒP ‚Kƒaƒb a…C‡]G†B ƒOƒg{ G‚BD ‰HŠ_hLM.");
 end
 end,
 [352]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"G‚W‰` …fD ƒa‚PƒP ƒP†Tf ‡Zƒ{WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚J‚XS ˆ[‚SD „C†yKLY? vv‚TG ‚_‚Tƒm„S [L ƒ{S IQ ‚C‰a…E WLM.");
 if talkYesNo( 3,"ƒnˆEŠi, ƒ{S IQ ‚C‰J‚b ƒuG ‚S‹c†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(3,"ƒLƒP ƒGƒo^ ‚rƒvƒOL ‚SƒW ‚^‚_‚h „Kƒ{W‚VM.");
 WarIni();
 DefineWarMap(23,"d2ƒa ƒN…EI ‚B„e","1. a…C‡] ‚p…D*2. d‡y„XG ‚T„Xƒd Šxl",40,0,16);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,7,5,4,0,-1,0,
 125,10,6,4,0,-1,0,
 2,8,7,4,0,-1,0,
 -1,6,7,4,0,-1,0,
 -1,5,7,4,0,-1,0,
 -1,6,4,4,0,-1,0,
 -1,4,6,4,0,-1,0,
 -1,10,3,4,0,-1,0,
 -1,10,5,4,0,-1,0,
 -1,9,10,4,0,-1,0,
 -1,7,10,4,0,-1,0,
 });
 DrawSMap();
talk(3,"ƒ[†{ ƒN…EfƒW ƒLS ŠGn ‰jƒO…x.");
 JY.Smap={};
 SetSceneID(0,11);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 16,27,5,3,4,32,9,7,10,-1,0,
 129,24,6,3,4,29,2,7,10,-1,0,
 62,24,9,3,4,28,2,7,10,-1,0,
 115,25,1,3,2,28,2,0,0,-1,0,
 128,23,9,3,4,29,15,7,10,-1,0,
 79,25,8,3,4,29,24,7,10,-1,0,
 102,28,5,3,4,29,22,7,10,-1,0,
 348,28,4,3,4,25,19,7,10,-1,0,
 256,23,3,3,2,24,2,0,0,-1,0,
 257,26,6,3,4,25,2,7,10,-1,0,
 292,27,9,3,4,24,8,7,10,-1,0,
 293,25,5,3,4,25,8,7,10,-1,0,
 294,28,7,3,2,25,8,0,0,-1,0,
 
 274,25,3,3,2,24,5,0,0,-1,0,
 275,26,10,3,4,25,5,7,10,-1,0,
 276,28,8,3,4,25,5,7,10,-1,0,
 277,27,7,3,2,25,5,0,0,-1,0,
 278,23,4,3,4,24,5,7,10,-1,0,
 279,24,10,3,4,25,5,7,10,-1,0,
 328,29,6,3,4,25,13,7,10,-1,0,
 329,25,9,3,4,24,13,7,10,-1,0,
 78,1,5,4,1,29,8,0,0,-1,1,
 280,0,4,4,1,25,5,0,0,-1,1,
 281,0,5,4,1,25,5,0,0,-1,1,
 282,0,6,4,1,25,5,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(356); --goto 356
WarSave(6)
 end
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"~ˆVS Œfƒ` ‚K‚V†yKLY?") then
 RemindSave();
talk(126,"ƒdŠOKLM.");
 MovePerson(126,1,2);
 MovePerson(126,2,1);
 MovePerson(126,5,3);
 MovePerson(126,0,2);
talk(126,"ˆ{ˆo†VfƒW ƒLS ŠG‚bM. dƒaƒb ‚XS ƒRƒm‚f.");
 MovePerson(3,2,2);
 MovePerson(3,2,1);
 MovePerson(3,4,3);
talk(3,"H „Gƒb Œi‡pGƒP ‚Xƒb Š^ƒd Š]‚C ‚kM.",
 126,"ˆ|S |^‡I‚V[. ‚K‚JƒP ~ˆVG bƒG „OKLM. ‚XS ‚SƒG‚b …x‚b KLM!",
 3,"H ‚i‚n^ ƒv‚h ‚{ q „O†y†sŠm?");
 MovePerson(2,3,2);
 MovePerson(2,2,1);
 MovePerson(2,3,3);
talk(2,"ƒa‚P, ƒ[ƒuƒb ˆEŠiƒP ƒsˆVGM. ‚Cƒg ‚XS ‚SƒG‚b ƒuƒb ‰b ƒnˆEŠiS †Eƒ~‚j‚b ƒuGM. ƒO…m o‚W ‰j„E ƒsƒd ƒvƒW ˆ|BD ‹z‚C ‚kM.",
 3,"„a†yKLM. …M, ‰q…f †hLM.");
 MovePerson( 2,12,2,
 3,12,2);
 PlayBGM(12);
talk(126,"eƒw, ‚G‡W.",
 128,"k.",
 117,"k.");
 MovePerson( 128,1,2,
 117,1,2);
 MovePerson( 128,1,2,
 117,1,0);
 MovePerson( 128,2,0,
 117,2,0);
 MovePerson( 128,2,3,
 117,2,3);
talk(126,"‚[ ‚r†vƒb G…eG…eaQ a‡I‚V[¡­¡­.",
 128,"k.",
 117,"„a†yKLM.");
 MovePerson( 128,9,2,
 117,9,2);
talk(126,"‚K‚J, ‚E ƒaqfQ J‚B ‚X‚YS ƒ_„~KLM.");
 WarIni();
 DefineWarMap(22,"d2ƒa ˆ{ˆo†V ‚B„e","1. a…C‡] ‚p…D",40,0,16);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,0,14,4,0,-1,0,
 125,0,13,4,0,-1,0,
 53,19,9,4,0,-1,0,
 -1,2,9,4,0,-1,0,
 -1,1,10,4,0,-1,0,
 -1,1,11,4,0,-1,0,
 -1,2,11,4,0,-1,0,
 -1,1,12,4,0,-1,0,
 2,11,3,1,0,-1,1,
 1,11,14,2,0,-1,1,
 154,12,15,2,0,-1,1,
 82,10,3,1,0,-1,1,
 116,12,5,1,0,-1,1,
 127,13,13,2,0,-1,1,
 });
 DrawSMap();
talk(126,"…b‚~a†yKLM!");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 16,36,13,3,0,33,8,0,0,-1,0,
 129,32,13,3,0,29,2,0,0,-1,0,
 62,35,14,3,0,28,2,0,0,-1,0,
 115,36,11,3,0,28,2,0,0,-1,0,
 128,37,10,3,0,29,15,0,0,-1,0,
 274,35,11,3,0,26,5,0,0,-1,0,
 275,39,13,3,0,26,5,0,0,-1,0,
 276,33,10,3,0,27,5,0,0,-1,0,
 277,33,14,3,0,27,5,0,0,-1,0,
 278,34,10,3,0,28,5,0,0,-1,0,
 279,36,10,3,0,28,5,0,0,-1,0,
 292,37,14,3,0,27,8,0,0,-1,0,
 293,34,13,3,0,27,8,0,0,-1,0,
 294,33,12,3,0,28,8,0,0,-1,0,
 295,37,12,3,0,28,8,0,0,-1,0,
 296,38,13,3,0,29,8,0,0,-1,0,
 256,32,12,3,0,27,2,0,0,-1,0,
 257,34,11,3,0,27,2,0,0,-1,0,
 336,35,12,3,0,27,15,0,0,-1,0,
 328,38,11,3,0,29,13,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent(); --goto 353
WarSave(6)
 end
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚SŒJˆe ‚Cƒgƒb ƒWŠe…e ƒLS ŠGS ƒe‚P‚h B…E WLM.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"d^ ƒsƒG‰` ƒN…E‚h IQ ‚C‰J‚b „KG ‹oKLM.");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"ƒe‚P‚b „CŠVKLY?");
 end
 if JY.Tid==369 then--Îä¹Ù
talk(369,"vv‚TƒP ‚Kƒaƒb a…C‡]G†B ƒOƒg{ G‚BD ‰HŠ_hLM.");
 end
 end,
 [353]=function()
 PlayBGM(11);
talk(126,"ƒ[†{ v‡SŠ_ƒW‚b a…C‡]S G‡Eƒm„S ‚Gja‡I‚V[. a…C‡]ƒb „o†_aƒv ƒLS ‹Bƒs‚b „qqG „OM WLM. …A…w‚V ˆGƒ`ƒR ƒuGL ƒ[ ‡FS G„oB ‚e‡aƒm„S ˆn‚SƒRG‡I‚V[. ƒOu ƒPD‚h …w…eƒ_ƒW‚b ‚o ŒjLM.",
 54,"„a†yKLM.",
 126,"‚K‚J, a…C‡]G †l‚BŠW ‚@ƒ`ƒRƒG ‚Bf‚b …b‚Ba‚C …X‚Vƒd ƒvŠc‚C ‚~ƒ}S ‡G‚D‚V‰J‡I‚V[. eƒOŠi{ ‚K†gƒb …XS …g‹J „[f, ƒa‚PŠi{ …y‡rƒb …XS ‡k‹J „[f ‡G‚DWLM.",
 1,"„a†yKLM.",
 126,"Gd v‡SŠ_ƒW „Av„SG Bƒ_ƒNMA ƒ{‚JhLM.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [354]=function()
 if WarMeet(2,116) then
 WarAction(1,2,116);
talk(2,"…f ‚_ƒaƒb k‚r„B‚C ‚k‚wƒv. G eƒO‡z …I‚_…I„S „}ƒ^†y†sŠm!",
 116,"n, eƒO„S‚T! ŠoM, [H‚f.");
 WarAction(6,2,116);
 if fight(2,116)==1 then
talk(2,"H‚b ƒ_ C‚_^ ˆf ˆYM. ƒA…eƒv‚f!",
 116,"ƒA…eƒv†ym, ƒA…eƒv†ym.");
 WarAction(16,116);
 WarLvUp(GetWarID(2));
 else
 WarAction(4,116,2);
talk(2,"¡­¡­");
 WarAction(17,2);
 WarLvUp(GetWarID(116));
 end
 end
 if WarMeet(54,129) then
 WarAction(1,54,129);
talk(54,"a…C‚d! ‚SŠS bƒGf „O‚b^!",
 129,"…x‡l, b…e ˆ| „sZ ‚a„p. [Q.");
 WarAction(6,129,54);
 if fight(54,129)==1 then
talk(54,"„l ‰j„ED ƒ[‚_fQ t„[ƒb ‚a„p. ‚S†A^, ‡g‚DaQ!",
 129,"¡­¡­„a†y„p. ‚G‚PŠiS ‚nB …Ia†y„p.");
 ModifyForce(129,1);
 PlayWavE(11);
 DrawStrBoxCenter("a…C‚dG n‚Tf ^†iPM!");
talk(129,"M„V ‚Cƒgƒb ‰jƒOƒd Š]‚C ‚k„p.",
 54,"Šom, ‰q…f ƒA…eƒv‚V[.");
 JY.Person[129]["µÀ¾ß1"]=0;
 JY.Person[129]["µÀ¾ß2"]=0;
 WarAction(16,129);
 WarLvUp(GetWarID(54));
 else
talk(54,"¡­¡­");
 WarAction(16,54);
 WarLvUp(GetWarID(129));
 end
 end
 if (not GetFlag(1028)) and (not GetFlag(139)) and War.Turn==10 then
 PlayBGM(11);
talk(130,"a…C‡] ƒa‚T, „Nƒg …m‚[ ‚^‚_ƒP ƒsƒdhLM. ƒLG @‚JS ƒe‚Paƒd „OM WLM.",
 17,"I‡JG[?",
 130,"‡mƒv ƒOu …m‡WG ‰B‚pB ƒLƒP „N@ ‚^‚_‚h ‹e‚S ‹^ƒtƒmL ‚Cƒg ‰b ŠP…E WLM.",
 17,"ŠUPM. ŠoM, Œa‚V ‚J‚pa‚f!");
 WarModifyAI(16,1);
 WarModifyAI(129,1);
 WarModifyAI(62,1);
 WarModifyAI(115,1);
 WarModifyAI(128,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(278,1);
 WarModifyAI(279,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(295,1);
 WarModifyAI(296,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(336,1);
 WarModifyAI(328,1);
talk(126,"I‡JG, @„T^ …y†V‡iPMƒd!? ‡m, vƒg„V „l …I~ ƒLS ˆn‚SƒRŠb„l‚fA¡­¡­.",
 1,"‚SŠS ˆY …IG[?",
 126,"Gu„CA „ND^ ‚aKLM. ‚B‚Uƒb …duaƒv FAfƒW ƒLS ƒAu†R q‹wfZ.");
 WarShowArmy(2-1);
 WarShowArmy(155-1);
 WarShowArmy(83-1);
 WarShowArmy(3-1);
talk(2,"G‚W ‰jˆlƒb Œ[‚V „@„}…[ ‡KWLM¡­¡­.",
 3,"d^ gJ ‚J‚XS ˆ[S q ‚aM Pw„V ˆ|D ˆf aQ aŠV‚CZ.");
 PlayBGM(9);
 SetFlag(1028,1)
 end
 if (not GetFlag(140)) and (not GetFlag(1028)) and WarCheckArea(-1,9,26,12,31) then
talk(17,"[, ƒLG ƒsjM! o‚W „Dn ‚K‚C. ŠoM, ‚B‚T …b‚p!",
 130,"a…C‡] ƒa‚T, ƒLfQ I‡H „T‚vG „OS‚C ‚Z‹{LM. Iu‚_ƒd ˆGƒ`ƒRA ‚n…UWLM!",
 17,"I‡H ‰umuŠm! ƒ[u ˆlL…eƒR‚SƒW‚b G†r ‰jˆlD ˆf GŒIM. ‚[ƒ`„E …X‚f! ‚Bga‚f!");
 WarModifyAI(16,1);
 WarModifyAI(129,1);
 WarModifyAI(62,1);
 WarModifyAI(115,1);
 WarModifyAI(128,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(278,1);
 WarModifyAI(279,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(295,1);
 WarModifyAI(296,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(336,1);
 WarModifyAI(328,1);
 SetFlag(140,1);
 end
 if (not GetFlag(139)) and (not GetFlag(1028)) and WarCheckArea(16,8,17,10,21) then
 PlayBGM(12);
talk(126,"ŠoM! ‚G‡W, eƒw. …dS ‹^n‚f!");
 WarShowArmy(128-1);
 WarShowArmy(117-1);
 PlayWavE(51);
 WarFireWater(11,8,1);
 WarFireWater(11,10,1);
 WarFireWater(12,10,1);
 WarFireWater(12,11,1);
 WarFireWater(13,7,1);
 WarFireWater(14,7,1);
 WarFireWater(15,7,1);
 WarFireWater(16,7,1);
 WarFireWater(17,8,1);
 WarFireWater(18,8,1);
 WarFireWater(19,8,1);
 WarFireWater(15,11,1);
 WarFireWater(16,11,1);
 WarFireWater(17,11,1);
 WarFireWater(18,11,1);
 WarFireWater(19,11,1);
 WarFireWater(20,11,1);
 WarFireWater(21,11,1);
talk(17,"ƒmŒF! ‚SŠS ˆY …IGŠm, ƒLG @‚JS MM! ƒn…IGM!");
 WarModifyAI(16,2);
 WarModifyAI(129,2);
 WarModifyAI(62,2);
 WarModifyAI(115,2);
 WarModifyAI(128,2);
 WarModifyAI(274,2);
 WarModifyAI(275,2);
 WarModifyAI(276,2);
 WarModifyAI(277,2);
 WarModifyAI(278,2);
 WarModifyAI(279,2);
 WarModifyAI(292,2);
 WarModifyAI(293,2);
 WarModifyAI(294,2);
 WarModifyAI(295,2);
 WarModifyAI(296,2);
 WarModifyAI(256,2);
 WarModifyAI(257,2);
 WarModifyAI(336,2);
 WarModifyAI(328,2);
 WarEnemyWeak(2,1);
 WarEnemyWeak(2,1);
 WarEnemyWeak(2,2);
 WarEnemyWeak(2,2);
 WarEnemyWeak(2,2);
 DrawStrBoxCenter("ƒLG ‚c‚df ƒEƒFM!");
 WarShowArmy(155-1);
 WarShowArmy(2-1);
talk(2,"ŠoM! †M…~f Œ{nŠP ƒLS I‹x…e‚f!");
 WarShowArmy(83-1);
 WarShowArmy(3-1);
talk(3,"‚J‚X, ƒ{‚JG[! ŠoM! ‚B‚T, vv‚TS ŠP‚f!",
 1,"[, ‚J‚Xƒb {…B ‚X…d‡m‚BG„SM!",
 126,"‡i„Q ‚kKLM, aƒKƒb s‚K…I ŠFhLM. ‚Cƒg ƒLG ‚c‚do ŒoS …@ ˆK…fŠW IH„]u‡I‚V[.");
 PlayBGM(9)
 SetFlag(139,1);
 end
 if (not GetFlag(1029)) and GetFlag(139) and War.Turn==15 then
talk(17,"dƒGŠJ, G‚_„S‚b „T…{ …V‚SŠGƒG„V a†yM. ‚Z‚[ Œa‚V ˆl„Lb‚f! ‚E ‚^‚_‚b ^Y‡S ƒLS ŠP‚f!");
 WarModifyAI(16,0);
 WarModifyAI(129,0);
 WarModifyAI(62,0);
 WarModifyAI(115,0);
 WarModifyAI(128,0);
 WarModifyAI(274,0);
 WarModifyAI(275,0);
 WarModifyAI(276,0);
 WarModifyAI(277,0);
 WarModifyAI(278,0);
 WarModifyAI(279,0);
 WarModifyAI(292,0);
 WarModifyAI(293,0);
 WarModifyAI(294,0);
 WarModifyAI(295,0);
 WarModifyAI(296,0);
 WarModifyAI(256,0);
 WarModifyAI(257,0);
 WarModifyAI(336,0);
 WarModifyAI(328,0);
 SetFlag(1029,1);
 end
 if JY.Status==GAME_WARWIN then
talk(17,"‡m, ‚G‚P ‚i‚n Œi‡pGfQ ‚CML. …C…Da‚f!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG a…C‡]S ƒAu‡RM.");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¹£°£°S ƒYƒC!");
 if GetFlag(139) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [355]=function()
 SetSceneID(0,3);
 if GetFlag(139) then
talk(3,"ŠoKLM, vv‚TGb [H‚f!",
 2,"‡m, ƒ[ƒv…fƒv ‚J‚Xƒb †~ƒm„S ‚_†Ma‚wƒv!",
 3,"¡­¡­ƒ[ŠQKLM. ‚S‹W q ‚a‚TZ, „d‚DPKLM.",
 126,"ƒa‚P, I‚S‚f P†sŠm?",
 3,"n, n, n‚`LM. nI ˆ|D ‚o PKLM.",
 126,"ƒ[‹@^. a…C‡]ƒb ƒA…eŠgƒmƒv vv^ …A…w‚V ƒi ƒhGL „N†dX q ‚aM.");
 elseif GetFlag(1028) then
talk(3,"ŠoKLM, vv‚TGb [H‚f!",
 2,"‡m, G‚W @‚Jƒb ƒ]‚_„S „C‚C ‚kƒtƒmƒv ‚J‚Xƒb b‚BŠW ƒNƒG‡^„[ƒP jƒAG„SM.",
 3,"ƒ[ŠQKLM. @‚JG NOo ƒuD ƒ[ƒP ˆ~ƒb n†m ‡KWLM.",
 54,"†~ƒm„S ‚^ˆaŠpKLM¡­¡­.",
 3,"aaa! ‹kKLM, ‹k‚SZ! ‚J‚XfQ „d‚Do ‚@„S a‚CZ.",
 126,"ƒa‚P, I‚S‚f P†sŠm?",
 3,"n, n, n‚`LM. nI ˆ|D ‚o PKLM.",
 126,"ƒ[‹@^. a…C‡]ƒb ƒA…eŠgƒmƒv vv^ …A…w‚V ƒi ƒhGL „N†dX q ‚aM.");
 else
talk(3,"Gƒs‡I‚V[ ƒnˆEŠi, …f‚b ‰j…[ †EuD ‚a„kKLM.",
 2,"‡m, ƒv‚h ˆ`‚C ‚kƒdD ‚_tS †E‚[„kƒmL ‚J‚XG ‚_†MaM X‹wf.",
 3,"ƒ[ŠQKLM. ‚S‹W q ‚aG „d‚DX q‹wfZ.",
 126,"ƒa‚P, I‚S‚f P†sŠm?",
 3,"n, n, n‚`LM. nI ˆ|D ‚o PKLM.",
 126,"ƒ[‹@^. a…C‡]ƒb ƒA…eŠgƒmƒv vv^ …A…w‚V ƒi ƒhGL „N†dX q ‚aM.");
 end
 NextEvent(360); --goto 360
 end,
 [356]=function()
 PlayBGM(11);
talk(17,"…M, ˆK‡rƒ{G‚f oƒR ‚_qŠm! ƒN…E„S g‚Ta‚f!",
 116,"a…C‡] ƒa‚T, ‚Cƒg ƒOu ‚Tƒb ‚T„X ƒs†PG ‚SŠqKLM. ‚~ƒ}S ‹D …gƒG‚b „KG Šo†yKLM.",
 17,"aaa! G‚B, OG ƒv‚b Q„S‚T. ‚[ƒ`„E …X‚f. …f‹@ ƒ{Gƒb „A‚y…yf „n‚SgM. H‚b bƒGƒW ƒGMƒ`‚f!",
 3,"‚J‚X, ƒv‚b DI‚C ‡iƒNS ˆ[‚C ˆfa†ym. gŠa Nƒ}S ƒsb „{ q „O†ym? vv‚TƒP ‚T„XS Šf„h‚bMA „d‚Da†ym.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [357]=function()
 if WarMeet(3,63) then
 WarAction(1,3,63);
talk(3,"ŠoM, ‚J‚XG ‚a‚SD G†r q „O‚MS ƒnˆEŠiŠ_ ƒsb …wu†yM. †EƒG ‚_ƒa! ƒv‡z ‚r`†@†MS a…x!",
 63,"‡m, H‚b †u‚wŠm? ŠoM, H‚h ƒq‚S ‚JS ƒoƒO†yM!");
 WarAction(6,3,63);
 if fight(3,63)==1 then
talk(3,"ƒmn…v!");
 WarAction(8,3,63);
talk(63,"G, Gƒuƒb¡­¡­!",
 3,"G ƒa‚PƒP ƒa‚Z^ Œv…Xƒv IƒW‡S‚C „aƒt†sŠm!",
 63,"I‡JG! „p^ ƒa‚PŠb‚wƒv! ‡iB‰M q ‚aM! ˆGnƒv…x!");
 WarAction(16,63);
talk(3,"n, ‹^ŠP „q„~‚wƒv.");
 WarLvUp(GetWarID(3));
 else
 WarAction(4,63,3);
talk(3,"¡­¡­");
 WarAction(17,3);
 WarLvUp(GetWarID(63));
 end
 end
 if WarMeet(54,129) then
 WarAction(1,54,129);
talk(54,"a…C‚d! ‚SŠS bƒGf „O‚b^!",
 129,"…x‡l, b…e ˆ| „sZ ‚a„p. [Q.");
 WarAction(6,129,54);
 if fight(54,129)==1 then
talk(54,"„l ‰j„ED ƒ[‚_fQ t„[ƒb ‚a„p. ‚S†A^, ‡g‚DaQ!",
 129,"¡­¡­„a†y„p. ‚G‚PŠiS ‚nB …Ia†y„p.");
 ModifyForce(129,1);
 PlayWavE(11);
 DrawStrBoxCenter("a…C‚dG n‚Tf ^†iPM!");
talk(129,"M„V ‚Cƒgƒb ‰jƒOƒd Š]‚C ‚k„p.",
 54,"Šom, ‰q…f ƒA…eƒv‚V[.");
 JY.Person[129]["µÀ¾ß1"]=0;
 JY.Person[129]["µÀ¾ß2"]=0;
 WarAction(16,129);
 WarLvUp(GetWarID(54));
 else
talk(54,"¡­¡­");
 WarAction(16,54);
 WarLvUp(GetWarID(129));
 end
 end
 if (not GetFlag(1030)) and War.Turn==5 then
 WarModifyAI(16,3,0);
 WarModifyAI(129,3,0);
 WarModifyAI(62,3,0);
 WarModifyAI(128,3,0);
 WarModifyAI(79,3,0);
 WarModifyAI(102,3,0);
 WarModifyAI(257,3,0);
 WarModifyAI(275,3,0);
 WarModifyAI(276,3,0);
 WarModifyAI(278,3,0);
 WarModifyAI(279,3,0);
 WarModifyAI(292,3,0);
 WarModifyAI(293,3,0);
 WarModifyAI(348,3,0);
 WarModifyAI(328,3,0);
 WarModifyAI(329,3,0);
 SetFlag(1030,1)
 end
 if (not GetFlag(1031)) and War.Turn==8 then
talk(1,"‡m, ƒLG ƒv…@ŠgM."); --DOS°æÎª17ÏÄºîª£¬µ«ÊÇ¸Ğ¾õ¹Ö¹ÖµÄ£¬¸ÄÎª1Áõ±¸
 WarShowArmy(79-1);
 WarShowArmy(281-1);
 WarShowArmy(282-1);
 WarShowArmy(283-1);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ŠXM!");
talk(79,"[, a…C‡] ƒa‚T. ƒLG „V„V„Q ‚kKLM!",
 17,"…M, ƒ[Šl u^! H‚b I‡Ja…e ŠX†sŠm?");
 SetFlag(1031,1);
 end
 if (not GetFlag(1032)) and War.Turn==30 then
talk(17,"I‡JG! ‚T„XG MPMƒd? ‡m, ‰jˆlG HI †r‚SƒF‚wƒv¡­¡­. a‚b q ‚aM, …C…Da‚f!");
 WarAction(16,17);
 SetFlag(1032,1);
 NextEvent();
 end
 if (not GetFlag(75)) and WarCheckArea(125,0,22,6,31) then
talk(17,"I‡JG? ƒL …I‚^^ ƒOu ‚T„XS Šf„hƒm…e ‰tMƒd! ‡m, ‚Cƒg ƒA…eE q‚b ‚aM! ‚B‚T ‡T‚J‚pab ƒLG ‚T„XS Šf„hƒG ‚Bf ƒN…Eƒ{S ‰Hˆya‚f!");
 WarModifyAI(274,1);
 WarModifyAI(277,1);
 WarModifyAI(294,1);
 WarModifyAI(256,1);
 WarModifyAI(115,1);
 SetFlag(75,1);
 end
 if (not GetFlag(65)) and WarCheckLocation(125,0,29) then
talk(126,"‚K‚JŠ_ nŠnLM. ƒLƒP ‚T„XS ‚Z‚[ Šf„hƒtKLM.",
 17,"‚T„XS Šf„h‹HMƒd? dƒGŠJ, ‚_…r †u‚wfQ ‡iP†sŠm? ‚J‚XfQ Šf„h‹H†M ˆ|GŠm? ‡m, a‚b q ‚aM. …C…Da‚f!");
 WarAction(16,17);
 SetFlag(65,1);
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 end,
 [358]=function()
 PlayBGM(7);
 DrawMulitStrBox("‚G‚P^ a…C‡]S ƒAu‡RM.");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¹£°£°S Šf„hƒtM!");
 if GetFlag(65) then
 WarGetExp();
 end
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [359]=function()
 SetSceneID(0,3);
 if GetFlag(65) then
talk(3,"Gƒs‡I‚V[, ‚J‚X …f ‚r†vG Fˆ|„S ƒLƒP ‚T„XS Šf„hƒtKLM.",
 2,"‡m, ‚J‚Xƒb †~ƒm„S ‚_†Ma‚wƒv.",
 3,"ƒ[ŠQKLM. ‚S‹W q ‚aG „d‚DPKLM.",
 126,"ƒa‚P, I‚S‚f P†sŠm?",
 3,"‚M, d^ I‡H ˆ|S PŠB^Z? n, n‚`LM. nI ˆ|D ‚o PKLM.",
 126,"ƒ[‹@^. M„V ‚K‚J, G‚W‰` a…C‡]G ƒA…eŠgƒmƒv vv^ …A…w‚V ƒi ƒuhLM. ƒLS ‹B‰}ƒW‚b ‚o ŒjLM.");
 else
talk(3,"ŠoKLM, vv‚TGb [H‚f!",
 2,"‡m, ƒ[ƒv…fƒv ‚J‚XƒP „o‚~ƒb †~ƒm„S ‚_†Ma‚wƒv.",
 3,"¡­¡­ƒ[ŠQKLM. „o‚~G …f‰S…l ˆc‚SƒvML, „d‚Da‚C ‚kS q ‚a‚TZ.",
 126,"ƒa‚P, I‚S‚f P†sŠm?",
 3,"‚M, d^ I‡H ˆ|S PŠB^Z? n, n‚`LM. nI ˆ|D ‚o PKLM.",
 126,"ƒ[‹@^. M„V ‚K‚J, G‚W‰` a…C‡]G ƒA…eŠgƒmƒv vv^ …A…w‚V ƒi ƒuhLM. ƒLS ‹B‰}ƒW‚b ‚o ŒjLM.");
 end
 NextEvent(); --goto 360
 end,
 [360]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=8;
 AddPerson(9,7,8,3);
 AddPerson(17,15,12,2);
 AddPerson(19,21,9,1);
 AddPerson(20,23,10,1);
 AddPerson(69,9,14,0);
 AddPerson(77,11,15,0);
 AddPerson(78,13,16,0);
 SetSceneID(84,11);
 DrawStrBoxCenter("‡m†g †X‚B");
talk(17,"ƒnmu‚h „Qƒd …bFPM^ OB ‰BnŠXKLM. ‰rS ƒ_ƒ` ‚K‡I‚V[.",
 9,"tO‚b ‚~^‚CC‚rL b‚h r‚C ‚k†yM. M„V ‚G‚P‚h G‚_„S ‚[A ‹IƒSf G„B‚C ‚kM. ŠoM, ‚B‚T …bF! ‰q…f ‚G‚P‚h ‚aŒiƒd ƒ[M‚M ‡Y‡bS ˆjM.");
 MovePerson(17,3,3);
 MovePerson(17,3,0);
 MovePerson(17,4,2);
 MovePerson(17,0,1);
 AddPerson(367,35,22,2);
 MovePerson(367,8,2);
talk(367,"tC, ˆE‚KƒP ‚r…x‚f Wa‚b …x^ ‹pƒG‚h ‰RWLM.",
 9,"I‡JG? ˆE‚KƒP ‚r…x‚fƒd? ƒR‚f a‚f.",
 367,"k.");
 MovePerson(367,10,3);
 DecPerson(367);
 AddPerson(135,35,22,2);
 MovePerson(135,8,2);
talk(135,"tCS Œr[L „l‚a‚b ~‚HhLM. …f‚b ˆE‚KƒP ‚r…x ‡p‡tG‚f¡­¡­",
 19,"‰xˆ| ˆ|ƒd Z‡F„V ˆ|a‚f!",
 135,"k, k. …fŠs ˆE‚K‚b tC{ ŠGE ƒ]G ‚aKLM.",
 69,"I‡JG[?",
 135,"…fŠs ˆE‚K‚b tCŠ_ ‡g‚Da†B †o†oƒ{S ƒ[‚_„S ƒU„Q†yKLM.",
 9,"†q, ƒ[‹@^. ‚r…x, qƒdPM. ‰Bn^ ‚Ba‚f. G vvfQ ƒU„Q‚b ƒuG‚fA ‡i…BŠW …H†yƒY‚fƒd.",
 135,"k, k. ƒ[†{ ƒA…e^†yKLM.");
 MovePerson(135,10,3);
 DecPerson(135);
talk(77,"‚K‚J, ˆE‚K‚h kCƒsM ‡@Q …VƒmŠVKLM.",
 78,"…gƒb ƒuƒb n„L tCŠ_ ŠGƒW‚b ‚G‚P‚h ‚aŒi‚b …IŠFhLM. ‚G‚P„V ‚aŒiA ‚l[„V …gKLM.",
 9,"‡m, …bF ‚Bf Šoƒb m‚yS ƒR„k‚wƒv. ŠoM, ‚B‚T …bF!");
 NextEvent();
 end,
 [361]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=13;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(128,7,14,0);
 AddPerson(365,-4,3,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒN…E ƒP‚r‰R");
 MovePerson(365,7,3);
talk(365,"o ^‚C n„b…oLM. „Nƒg ‚G…qŠ_ƒW ƒoCS ‹XƒvŠVKLM.",
 114,"I‡JG? ‚G…q ˆEŠiG ‰Bn^ŠVMƒd!",
 126,"ƒ[ŠQMA ‚G…qƒP ‚GˆAƒb I‡JG„km?",
 365,"‚G…qŠ_ƒW‚b ‚GˆAƒm„S ƒa…x ‚GƒG^ nL‚f ‚GTS …C„T„S FaŠVKLM.",
 1,"I‡JG? ‚SŠS ƒ[u ‚Su„Zƒb^! ‚SŠSab ‚GƒG^ nL‚d ˆ|G[?",
 365,"ƒ[ƒuƒb …fD¡­¡­. ƒ[†{ ƒA…e^†yKLM.");
 MovePerson(365,7,2);
 DecPerson(365);
 AddPerson(2,-4,3,3);
 AddPerson(135,-2,4,3);
 MovePerson( 2,3,3,
 135,3,3);
talk(2,"‚SƒW ^‚f!",
 135,"k, ‚^ƒZ ƒc…~„Vƒb †jƒ` ‚K‡I‚V[.");
 MovePerson( 2,4,3,
 135,4,3);
talk(2,"ˆEŠi, ‚T‚rfQ vv^ ‰b ŠPƒR‚S†[M‚b ˆ|S Š^ƒd „ANS ƒv‰tM^ G…x^ qCB ‹Qn ŠXKLM. …Zƒ|B ƒs‚V‚CZ.");
 MovePerson( 2,3,0);
 MovePerson( 2,3,3);
 MovePerson( 2,0,1);
 --Ê¾ÈÎÎñÄ¿±ê:<ÓëÖî¸ğÁÁµÈÌÖÂÛ½ñºóÔõÃ´°ì>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [362]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"„ANS ƒv‰tM^ G…x^ qCB ‹Qn ŠXKLM. …Zƒ|B ƒs‚V‚CZ. ˆE‚KƒP ‚r…x‚f WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ˆE‚KƒP ‚r…x‚fƒd? ‚SƒZ„S ^‚b †rGŠm? I‡H …IGŠm?");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‡p‡tG‚f‚b G…x‚b eƒO^ ‹Qn ŠXKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ˆE‚KƒP ‚r…x‚f. ƒ[‚_ƒP ‚rFƒb ‚_‚v ‰cJG ^[.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"G…x‚h …Zƒ|a‚V‚CZ.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"G…x‚h …Zƒ|a‚V‚CZ.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"G…x‚h …Zƒ|a‚V‚CZ.");
 end
 if JY.Tid==135 then--ËÎÖÒ
talk(135,"‚r, †jƒ` ‚K‡I‚V[.",
 1,"ƒ[‚_‚b ˆE‚K ‹J ‚r†vj^?",
 135,"k, k.",
 2,"‚r…x„SƒW ‚SƒZf MˆQŠX†sŠm?",
 135,"v, vvfQ MˆQŠXKLM.",
 3,"vvfQ‚fƒd? ˆE‚K^ vv‡z I‡H …IG „O†sŠm?",
 135,"N, Nƒb ‚G…qŠ_ƒW G†w ƒoCS ‹Xƒv‚Vƒd ‚GTŠ_ƒW ‡D‚h GƒmŠVKLM.",
 1,"ƒ[ƒuƒb ƒvD „Nƒg ƒR„kM. ‡q…h ‚SŠS ‚GƒG^ nLŠm? ƒs„wƒb ƒa…x^ …C„T^ nL„lŠm.",
 135,"‚GˆAf ƒ[u ƒL‹u „O‚S …^‚Z^ ƒ[‚_„S ‹nuPKLM.",
 2,"…^‚Z‚f? †~ƒm„S qCa‚wƒv! ƒ[M‚Mƒb?",
 135,"G‚S vv^ ŠPƒR‚S†[M‚b m‚yG ƒR‚S‡z ƒNaƒRG CƒPo †@{¡­¡­.",
 54,"†@{^ ‚SŠS „C„k†sŠm? E…X¡­¡­.",
 135,"vvfQ ‡g‚DaƒG„S PKLM.");
 NextEvent();
 end
 end,
 [363]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚Cƒgƒb o‚V^ †PWLM. ˆz…vƒP ƒ@ƒO vv‡z …^‚ZfQ †oAƒm„S ‰G‚J‡iWLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, †o†oS la‚V‚CZ. ‚G…qD …G„kƒmL Gd †EuO ƒuG ‚aKLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"G‚b ‚e‚_o …IhLM. ƒWŠe…e ‡YS ˆ`‚C ‚kƒmA ‰BG‡Q q ‚aKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ‚Cƒgƒb …rAS ‚i‹T „U^ n‚`LM. Œa‚V †o†oS Šf„hƒd ƒ[‡EfƒW vvf ŠGƒW‚b ƒuG C‚uhLM.",
 1,"‡mƒv¡­¡­ ‚G…qŠ_ƒW ƒ[‰S…l ƒOu‚h ƒs†ja ‚KŠV‚b…h Gd ƒ[ nƒRS ˆjML¡­¡­ ‚J‚X, ƒN…E‚h „quƒd ‚GƒG^ Mƒ~u‚b ‚Ia„S ‰Xa‚b ƒuƒb ‚S‹c†ym?",
 126,"ƒ[uBD vvƒP …c‚pS …HKLM. „y‚fu †o†oS Šf„h‚b „KG ‹oKLM. „i? ‚K‚J, †P‚r^ ŠXKLM.");
 AddPerson(365,-4,3,3);
 MovePerson( 365,10,3);
talk(365,"‚K‚J, †PŠW nP …IG „OKLM!");
 NextEvent();
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ‚SŠSXYZ?");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚K‚J, ‚SŠSXYZ?");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚SŠS ‚GƒG^ nL‚f ‚GTG ‡D‚h G„k†M ˆ|j^? ŒR‚C, …^‚ZƒP ˆN…yG„S‚wƒv!");
 end
 if JY.Tid==135 then--ËÎÖÒ
talk(135,"…f, …f‚b ƒ[…f ‚V‰J‚b ‚_„S PS ŠFhLM.");
 end
 end,
 [364]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ‚r…xƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚r…xƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ‚r…xƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒO…m ‚r…xƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ‚r…xƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚K‚J, ‚r…xƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚G‚U†f, G‚b „s‚V …^‚ZƒP ˆN…yhLM. …^‚Z‚b …A…w‚V ‚s‰rS …HS ƒuhLM.");
 end
 if JY.Tid==135 then--ËÎÖÒ
talk(135,"…f, …f‚b ƒ[…f ‚V‰J‚b ‚_„S PS ŠFhLM.");
 end
 if JY.Tid==365 then--Ê¹Õß
 PlayBGM(11);
talk(365,"‚K‚JŠ_ nŠnLM. vv‚TG G†w ˆ{ˆo†Vf G‚jŠjKLM.",
 54,"I‡JG? ‰r‰l ƒ[‡EY‚C ŠX†M ˆ|GŠm?",
 126,"‚SƒZ„S ^ˆe ‚Z‚[ ƒe‚P‚h B…E WLM.");
talk(126,"eƒOŠi{ GƒLƒb o_ ‰q…f ‚Ia„S ^ ‚GƒGŠ_ ‚CƒQS ‰Ra‡I‚V[.",
 2,"„a†ym. ƒOu‚b ‰bƒU„S ‚Ia„S ^†ym.",
 114,"e ƒa‚T, ‚SƒW ‹Xƒv‚V‚CZ.");
 MovePerson( 2,3,2,
 114,2,2);
 MovePerson( 2,2,1,
 114,2,0);
 MovePerson( 2,10,2,
 114,10,2);
 DecPerson(2);
 DecPerson(114);
 ModifyForce(2,0);
 ModifyForce(114,0);
talk(126,"ƒvŠc‚C‚b ‚SƒW …b_S ƒe‚Pa‡I‚V[.");
 MovePerson(365,10,2);
 DecPerson(365);
 MovePerson( 64,1,2,
 128,1,2,
 3,1,2,
 54,2,2);
 MovePerson( 64,1,1,
 128,1,0,
 3,1,2,
 54,1,2);
 MovePerson( 64,1,1,
 128,1,0,
 3,1,1,
 54,1,0);
 MovePerson( 64,1,2,
 128,1,2,
 3,1,1,
 54,1,0);
 MovePerson( 64,10,2,
 128,10,2,
 3,10,2,
 54,10,2);
 DecPerson(64);
 DecPerson(128);
 DecPerson(3);
 DecPerson(54);
talk(126,"ƒ[†{ ‚K‚JŠ_ƒWD …b_S ƒe‚Pa‡I‚V[. ƒe‚P„C‚VA …I…e ‚K‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×öÓ­Õ½²Ü²ÙµÄ×¼±¸>
 NextEvent();
 end
 end,
 [365]=function()
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"vvfQ ‚i‚f‹QŠWA ‰W‚daM. ‚SƒW …b_¡­¡­ „i?");
 JY.Smap={};
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(359,5,5,3);
 AddPerson(371,3,6,3);
 AddPerson(353,1,7,3);
 AddPerson(357,7,6,3);
 AddPerson(355,5,7,3);
 AddPerson(363,3,8,3);
 SetSceneID(54);
talk(355,"‚G‚U†f, …fŠsD ‰HŠ_ …hƒ`^ ‚K‡I‚V[.",
 1,"I‡JG[? ‹Iƒm„S ƒOu‚b vv‡z ‰j„E…E X‚CD ‚Z‚j[.",
 355,"„aƒd „OKLM. ‡mƒv vvfQ ƒMŒT‡ia†sL ‚G‚U†fS ‚i‚j†yKLM. ‚^ƒZ ‰RWLM.",
 1,"¡­¡­Šom, ‚i‚f[‚V[. M‡M GƒRfQD ‚Ba‚V[. ‰HŠ_ …hƒ`^†yMƒd.",
 126,"¡­¡­£¡",
 355,"n, ‡N‚rWLM. ƒ[†{ ‰b ‚Z‚[fQ „au†yKLM!");
 MovePerson( 357,6,2,
 355,6,2,
 363,6,2,
 359,6,2,
 371,6,2,
 353,6,2);
talk(126,"‚K‚J, ‹Iƒm„S vv‚TƒP …c‚pS QuŠP…E WLM. †eƒ{S …hƒ`^A ‚]‚T{ ‚B„ef „NB^ ŒjLM.",
 1,"‚J‚X, …fƒRƒb ‚Z‚[ ƒv‚h ˆ[ƒd ‚i‚j[. …fƒRS „qƒ`‚[ƒd ‡y q‚b ‚am.",
 126,"„a†yKLM. ƒ[†{ †eƒ{ƒR{ ‰HŠ_ ^‚V‚CZ.");
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"†o†oƒm„S ‡y‚C ‚Ia„S ‡y‚C ‚K‚JŠ_ƒW FB ‚K‡I‚V[.");
 local menu={
 {"¡¡†o†oƒm„S",nil,1},
 {"¡¡‚Ia„S",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
 SetSceneID(0);
talk(126,"‚_‚AS ‹s…c‡I‚V[.");
 WarIni();
 DefineWarMap(24,"d2ƒa †o†oI ‚B„e","1. …^‚Z ‚p†j",20,0,112);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,9,22,2,0,-1,0,
 -1,8,22,2,0,-1,0,
 -1,10,22,2,0,-1,0,
 -1,8,21,2,0,-1,0,
 -1,10,21,2,0,-1,0,
 -1,7,22,2,0,-1,0,
 -1,12,22,2,0,-1,0,
 -1,11,21,2,0,-1,0,
 -1,7,20,2,0,-1,0,
 -1,7,23,2,0,-1,0,
 -1,9,20,2,0,-1,0,
 -1,10,20,2,0,-1,0,
 344,6,23,2,0,-1,0,
 345,9,23,2,0,-1,0,
 346,11,23,2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 112,18,4,1,2,31,2,0,0,-1,0,
 121,14,9,3,2,28,8,0,0,-1,0,
 122,17,5,1,0,27,8,0,0,-1,0,
 119,17,6,3,0,28,5,0,0,-1,0,
 130,12,14,1,2,28,2,0,0,-1,0,
 133,15,8,3,0,27,13,0,0,-1,0,
 256,11,4,1,4,24,2,9,8,-1,0,
 257,10,14,1,2,24,2,0,0,-1,0,
 258,11,14,1,2,23,2,0,0,-1,0,
 274,15,10,3,0,24,5,0,0,-1,0,
 275,10,4,1,4,24,5,8,8,-1,0,
 276,9,14,1,2,24,5,0,0,-1,0,
 126,3,17,4,2,27,8,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(); --goto 366
WarSave(6)
 elseif r==2 then
 SetSceneID(0,11);
talk(9,"‚G‚P‚h ‹^„Q‚C …X‚f! …A…w‚V ‚r„S‹Qn‚f!");
 SetSceneID(0);
talk(1,"‚J‚X, vvfQ ‚i‚f‹Q‰o ‡Ka[.",
 126,"a‚b q ‚aKLM. G‡EfƒW vvf ŠG†b‚VM. ‚_‚AS ‹s…c‡I‚V[.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(370); --goto 370
 end
 end
 end
 if JY.Tid==135 then--ËÎÖÒ
talk(135,"ƒv‚b „T…{ bƒG „O‚S…E a‚b^?");
 end
 end,
 [366]=function()
 PlayBGM(11);
talk(113,"ŠoM, ƒ{S ƒv^‚C ˆ|ƒd ‚V…yS ‰r‚S‚f. ‚S„y‰X ‚G‚P‚b bƒG [†G ŠcƒA‚C ˆfoM.",
 126,"‚K‚J, G ‰jˆlƒb „CD…l Wu ‹[ƒ_…E WLM. bƒP„Q ‚kƒmA ƒWŠe…e ‚Ia„S ƒA…eƒv‚V‚CZ.");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [367]=function()
 if WarMeet(54,131) then
 WarAction(1,54,131);
talk(54,"ƒ[‚_ƒRƒb ‚SŠSab vvfQ ‡g‚DP‚b^?",
 131,"HŠs‡z‚b Ce‚a‚b …IGM. vvf ŠGƒWA †j q ‚aƒmL ‡g‚Do ƒuGM.",
 54,"ƒ[ƒuƒb ŒR‚C ‚km.",
 131,"‰xˆ| …X‚f! G ƒd‡Co ƒuƒR! ˆE‚K‚h Šf„hƒmƒ` aML …Gƒd Š]ƒmŠm!");
 WarAction(6,54,131);
 if fight(54,131)==1 then
talk(131,"^, ‚Ia‚wƒv¡­¡­.",
 54,"ƒc…~S ƒ_‹^n‚f!");
 WarAction(8,54,131);
talk(131,"ƒmŒF¡­¡­!");
 WarAction(17,131);
 WarLvUp(GetWarID(54));
 else
 WarAction(4,131,54);
talk(54,"‚Ia‚wƒv¡­¡­.");
 WarAction(17,54);
 WarLvUp(GetWarID(131));
 end
 end
 if (not GetFlag(1033)) and War.Turn==15 then
 PlayBGM(11);
talk(126,"‚K‚J, „Nƒg p…xƒP †PƒshLM. vv‚TG G†w ƒN…Ef G‚jŠjM WLM. bƒGƒW „l ‰jƒOA ‹I‡D„S ‰G‚J‡iX ‚n…UG „OKLM. Œa‚V ‚Ia„S ƒA…eƒvŒs…E WLM.",
 1,"ŠoM, ‚Ia„S …yM!");
 SetFlag(1033,1);
 NextEvent();
 end
 if (not GetFlag(1034)) and War.Turn==3 then
 local wid=GetWarID(127);
 War.Person[wid].enemy=false;
 War.Person[wid].friend=true;
 War.Person[wid].pic=WarGetPic(wid);
 WarShowArmy(127-1);
 DrawStrBoxCenter("‚n…BG ƒv…@ŠgM.")
talk(127,"…^‚Z G ‡G}ƒP DƒLn! ‚G ‚r‚TŠ_ƒW †eƒ{S ‚wa…e [ŠV†EƒX ‚SŠS ‡fnƒW†sŠm!",
 127,"‚U†fŠ_ƒW‚b ‚SƒW ‚TS Gˆnƒd hƒ{a‚V‚S ‰HŠ_ ‡G}ƒY‚h ƒq‡I‚V[!",
 3,"ƒnˆEŠi! ŠPƒR‚S^‚V‚CZ!");
talk(122,"‚_†io ‚n…Bn, ‡NŠW ‚qS …Iƒm‰J†sŠm! ‚_ƒa …Z‡xS „anƒs†y†sŠm!");
 WarModifyAI(127-1,3,122-1);
 SetFlag(1034,1);
 end
 WarLocationItem(3,10,55,152); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º²è
 WarLocationItem(8,5,153,153); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÃÍ»ğÊé ¸ÄÎª 153Í²Ğäîø
 WarLocationItem(3,16,10,154); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÒĞÌì½£
 if JY.Status==GAME_WARWIN then
talk(113,"‚G‚P, ˆE‚K‚b HŠsfQ „|ƒG‚C ‚k‚bM¡­¡­.");
 PlayBGM(7);
 DrawMulitStrBox("…^‚Z‚h ƒqƒd ‚G‚P‚TG …^‚Z‚TS I‹xŠjM.");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¹£°£°S ƒYƒC!");
 WarGetExp();
talk(126,"‚K‚J, …^‚Z‚b ƒq„kƒmƒv †o†oƒ{G …d…@ ˆE…r‚h „an…R q ‚aKLM. vv‚TG ˆv„QA G ƒ{ƒb ‚C‡Q q ‚aƒmL ‚Ia„S ^‚V‚CZ.",
 1,"ŠoM, ‚B‚T ‚Ia„S …yM!");
 NextEvent();
 end
 end,
 [368]=function()
 PlayBGM(11);
 DrawMulitStrBox("‚G‚P^ ‚Ia„S ƒA…eŠgM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [369]=function()
 SetSceneID(0);
talk(1,"‚Ia„S ^…x.");
 --´¢´æ½ø¶È:Õ½³¡´æÅÌ
 SetSceneID(0);
talk(9,"‚G‚P‚h ‹^„Q‚C …X‚f!");
talk(1,"‚J‚X, ‰b vvfQ ‚i‚f‹QŠW†ym.",
 126,"a‚b q ‚aKLM. ƒ[†{ vv‚h ‡fn ‹g‚VM. ‚_‚AS ‹s…c‡I‚V[.");
 NextEvent();
 end,
 [370]=function()
change_mode()
 WarIni();
 DefineWarMap(25,"d2ƒa ƒa‚F†VI ‚B„e","1. vv …D‚E*2. †eƒ{G ‚l…g …XS„S ‰XƒN",70,0,8);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,21,13,4,0,-1,0,
 125,21,12,4,0,-1,0,
 -1,15,12,4,0,-1,0,
 -1,15,14,4,0,-1,0,
 -1,16,11,4,0,-1,0,
 -1,17,11,4,0,-1,0,
 -1,16,15,4,0,-1,0,
 -1,16,16,4,0,-1,0,
 -1,19,11,4,0,-1,0,
 -1,20,11,4,0,-1,0,
 -1,19,15,4,0,-1,0,
 -1,20,15,4,0,-1,0,
 344,20,12,4,0,-1,0,
 345,17,15,4,0,-1,0,
 346,18,16,4,0,-1,0,
 });
 ModifyForce(138,9);
 ModifyForce(139,9);
 ModifyForce(106,9);
 ModifyForce(122,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 8,3,3,1,0,42,9,0,0,-1,0,
 18,3,5,1,3,32,2,0,0,-1,0,
 115,8,12,4,3,31,2,344,0,-1,0,
 16,6,11,4,1,32,9,0,0,-1,0,
 17,7,12,4,1,32,22,0,0,-1,0,
 217,5,3,1,3,32,8,0,0,-1,0,
 79,5,8,4,3,32,24,0,0,-1,0,
 67,1,1,1,1,32,8,0,0,-1,0,
 140,2,2,1,3,31,15,345,0,-1,0,
 105,5,5,1,3,31,8,346,0,-1,0,
 135,4,2,1,0,31,12,0,0,-1,0,
 102,9,10,4,3,31,22,0,0,-1,0,
 137,6,6,1,3,31,11,345,0,-1,0,
 138,5,10,4,3,31,5,346,0,-1,0,
 
 19,7,10,4,3,31,24,344,0,-1,0,
 121,8,6,1,1,31,8,0,0,-1,0,
 292,6,9,4,3,28,8,0,0,-1,0,
 293,2,4,1,0,28,8,0,0,-1,0,
 294,8,8,4,3,27,8,0,0,-1,1,
 295,4,9,4,1,28,8,0,0,-1,1,
 296,6,7,4,1,28,8,0,0,-1,1,
 297,4,6,1,1,27,8,0,0,-1,1,
 310,18,4,1,3,27,11,344,0,-1,0,
 311,18,5,1,3,26,11,345,0,-1,0,
 312,17,6,1,3,25,11,346,0,-1,1,
 274,7,7,4,3,28,5,0,0,-1,1,
 275,5,4,1,3,28,5,345,0,-1,1,
 276,4,8,4,1,27,5,0,0,-1,1,
 
 386,3,4,1,3,36,15,8,0,-1,0,--µäÎ¤S
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [371]=function()
 PlayBGM(11);
talk(9,"…M, ‚G‚P. Gd ‡y ‡EG ‚a‚wƒv. ‚B‚T ‚G‚P‚Tf ‡T‚J‚pS ^a‚f.",
 126,"‡m, †eƒ{ƒRƒP ‚@‚Mƒm„S‚b †@} vv‚TƒP Fk‚h ‡iB‰M q ‚a‚wƒv.",
 1,"‡mƒv …f †eƒ{ƒRƒb ƒv‚h ˆ[ƒd ‚i‚fŠXƒmL †@ŠH „qƒ`Še q ‚am.",
 126,"ƒ[ŠQMA †eƒ{ƒRS ‰q…f ‰XƒN‚V‰J‡I‚V[. Mu wHf …XSG aƒv „OƒmL ƒ[‡Eƒm„S ƒsƒ_‚V‚CZ.");
 WarShowTarget(true);
 WarModifyAI(344,6,32,22);
 WarModifyAI(345,6,32,22);
 WarModifyAI(346,6,32,22);
 PlayBGM(10);
 NextEvent();
 end,
 [372]=function()
 if (not GetFlag(1035)) and War.Turn==3 then
talk(136,"‡q…h †eƒ{S …huƒd MLML, ‚G‚P‚b ‚_…r I‡H `‚Ej^?",
 9,"ƒU„S ƒ[ „U…Zf …f…x^ †eƒ{ƒP ˆC‚Z‚h …H‚b ƒuG†y‚C. {…B †]s‚_‚vƒP jƒAGM. ‡mƒv †eƒ{S …huƒd ˆGnƒvML¡­¡­ †~ƒm„S ‚Su„ZM. ŠoM! ‚Bga‚f.");
 WarModifyAI(8,3,0);
 WarModifyAI(135,3,344);
 WarModifyAI(293,3,0);
 SetFlag(1035,1);
 end
 if WarCheckLocation(344,22,32) then
 PlayBGM(7);
talk(1,"[, ƒO…m †eƒ{S …XS„S ƒs„jƒmL vvD „l‚b ‹Kn[‚C ‚k†y‚C?",
 126,"‰b ‹Kn…oLM. G‚b vv‚h ‚i‰BuƒG ‚no o ^‚C „T‚u…I ŠFGL ‚SƒW ‚Ia„S ^‚V‚CZ.");
 WarGetExp();
bonus_moneyexp_4()
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 if WarCheckLocation(345,22,32) then
 PlayBGM(7);
talk(1,"[, ƒO…m †eƒ{S …XS„S ƒs„jƒmL vvD „l‚b ‹Kn[‚C ‚k†y‚C?",
 126,"‰b ‹Kn…oLM. G‚b vv‚h ‚i‰BuƒG ‚no o ^‚C „T‚u…I ŠFGL ‚SƒW ‚Ia„S ^‚V‚CZ.");
 WarGetExp();
bonus_moneyexp_4()
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 if WarCheckLocation(346,22,32) then
 PlayBGM(7);
talk(1,"[, ƒO…m †eƒ{S …XS„S ƒs„jƒmL vvD „l‚b ‹Kn[‚C ‚k†y‚C?",
 126,"‰b ‹Kn…oLM. G‚b vv‚h ‚i‰BuƒG ‚no o ^‚C „T‚u…I ŠFGL ‚SƒW ‚Ia„S ^‚V‚CZ.");
 WarGetExp();
bonus_moneyexp_4()
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(9,"‡m¡­¡­ n„LD ‚i‚f‹Q‚C ˆfaML. ‚G‚P‚h ‹^ŠPƒW‚b ‚o ˆYM! „T…{ ‹Kn‚f!",
 1,"vv^ ƒA…e‚q ƒuG[?",
 126,"n‚`LM. ‰b M‚V ‹Kn…oLM. G‚b vv‚h ‚i‰BuƒG ‚no „N„K…I ŠFGL ‚SƒW ‚Ia„S ^‚V‚CZ.");
bonus_moneyexp_8()
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 end,
 [373]=function()
change_mode()
 WarIni2();
 DefineWarMap(26,"d2ƒa ƒa‚F†VII ‚B„e","1. vv …D‚E*2. †eƒ{G ƒW‡k Mu„S ‰XƒN",99,0,8);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm2(1,{
 0,25,17,3,0,-1,0,
 125,26,15,3,0,-1,0,
 -1,25,14,3,0,-1,0,
 -1,27,16,3,0,-1,0,
 -1,24,20,3,0,-1,0,
 -1,24,15,3,0,-1,0,
 -1,25,19,3,0,-1,0,
 -1,26,13,3,0,-1,0,
 -1,26,18,3,0,-1,0,
 -1,25,18,3,0,-1,0,
 -1,26,14,3,0,-1,0,
 -1,27,14,3,0,-1,0,
 344,25,16,3,0,-1,0,
 345,24,16,3,0,-1,0,
 346,24,18,3,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 8,27,1,1,0,42,9,0,0,-1,0,
 18,24,1,1,3,32,2,0,0,-1,0,
 115,26,2,1,0,31,2,0,0,-1,0,
 16,29,1,1,1,32,9,0,0,-1,0,
 17,29,0,1,1,32,22,0,0,-1,0,
 217,33,2,1,3,32,8,0,0,-1,0,
 79,32,0,1,3,32,24,0,0,-1,0,
 67,31,1,1,1,32,8,0,0,-1,0,
 140,26,0,1,0,31,15,0,0,-1,0,
 105,32,3,1,3,31,8,346,0,-1,0,
 135,23,0,1,3,31,12,344,0,-1,0,
 102,24,0,1,3,31,22,0,0,-1,0,
 137,27,3,1,3,31,11,345,0,-1,0,
 138,25,3,1,3,31,5,346,0,-1,0,
 
 19,30,3,1,3,31,24,344,0,-1,0,
 121,28,1,1,0,31,8,0,0,-1,0,
 292,34,0,1,3,30,8,0,0,-1,0,
 293,33,0,1,3,29,8,0,0,-1,0,
 294,32,1,1,3,28,8,0,0,-1,1,
 295,31,2,1,3,30,8,344,0,-1,1,
 296,30,2,1,3,29,8,345,0,-1,1,
 297,28,0,1,3,28,8,346,0,-1,1,
 298,28,2,1,1,30,7,0,0,-1,0,
 299,25,1,1,1,29,7,0,0,-1,0,
 300,22,0,1,1,28,7,0,0,-1,1,
 274,29,3,1,3,30,5,0,0,-1,1,
 275,30,0,1,3,29,5,345,0,-1,1,
 276,29,2,1,1,28,5,0,0,-1,1,
 
 386,27,2,1,3,36,15,8,0,-1,0,--µäÎ¤S
 });
 NextEvent();
WarSave(6)
 end,
 [374]=function()
 PlayBGM(11);
talk(1,"vƒg„V „l ^A ƒa‚IG ƒshLM. ‚S‹cQˆe †eƒ{S ƒvƒ^Y‚C …hƒ`^…E WLM. ƒ[‡Ef G‚jA †c^ „OS ƒuhLM.");
 WarShowTarget(true);
 WarModifyAI(344,6,0,10);
 WarModifyAI(345,6,0,10);
 WarModifyAI(346,6,0,10);
 PlayBGM(16);
 NextEvent();
 end,
 [375]=function()
 if WarMeet(54,136) then
 WarAction(1,54,136);
talk(54,"GŠK‚q IƒaG„S‚T. G v‡SG C‚_a†yM!",
 136,"dƒGŠJ¡­¡­!");
 WarAction(6,54,136);
 if fight(54,136)==1 then
talk(54,"ŠP‚f!");
 WarAction(8,54,136);
talk(136,"…v!");
 WarAction(18,136);
talk(54,"[, ƒLG ‚C†m …f ˆVƒb¡­¡­? ƒW…jG ‚VRŠQ‚wƒv. ‡d‚V Œfƒ` ˆ`†yM.");
 WarGetItem(GetWarID(54),11);
 --WarLvUp(GetWarID(54));
 else
 WarAction(4,136,54);
talk(54,"‚_†Ma‚wƒv!");
 WarAction(17,54);
 WarLvUp(GetWarID(136));
 end
 end
 if WarMeet(1,122) then
 WarAction(1,1,122);
talk(122,"‚G‚P! Gd ˆf ˆGn‚qM!",
 1,"‚KjS …}g DƒLG I‡H Hƒm„S ‚r†vS ‚_a†sŠm!",
 122,"¡­¡­¡­¡­");
 WarAction(16,122);
 end
 if (not GetFlag(155)) and WarCheckArea(-1,17,17,22,19) then
talk(116,"†eƒ{G …fƒR{ ‡DGb „OM„lL¡­¡­. {…B ‚G‚P‚TG„SM. dˆF ŠU ‰jƒO‚b‚T.",
 9,"‚Cƒgƒb o^„SG jƒAS bX „U^ n‚`LM. †rƒb aƒvŠF, ‹Kn…E WLM. ‚SƒW ‹Kƒm‡I‚V[.");
 WarModifyAI(8,3,0);
 WarModifyAI(115,3,344);
 WarModifyAI(140,3,345);
 WarModifyAI(121,1);
 SetFlag(155,1);
 end
 if WarCheckLocation(344,10,0) then
 PlayBGM(7);
talk(1,"‹kKLM! …Xƒlƒ_ Œz‚SŠgKLM. bƒGY‚C ŠXƒmL †c^ ‚a‚b vv‚Tƒb ‹Kn[‚C ˆfWLM. ‚SƒW †c‚h …@ƒd ‚Ia„S ^‚V‚CZ.");
 DrawMulitStrBox("‚G‚P‚TG vv‚TƒP …c‚pS Qu‡RM.");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¹£°£°S ƒYƒC!");
 WarGetExp();
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarCheckLocation(345,10,0) then
 PlayBGM(7);
talk(1,"‹kKLM! …Xƒlƒ_ Œz‚SŠgKLM. bƒGY‚C ŠXƒmL †c^ ‚a‚b vv‚Tƒb ‹Kn[‚C ˆfWLM. ‚SƒW †c‚h …@ƒd ‚Ia„S ^‚V‚CZ.");
 DrawMulitStrBox("‚G‚P‚TG vv‚TƒP …c‚pS Qu‡RM.");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¹£°£°S ƒYƒC!");
 WarGetExp();
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarCheckLocation(346,10,0) then
 PlayBGM(7);
talk(1,"‹kKLM! …Xƒlƒ_ Œz‚SŠgKLM. bƒGY‚C ŠXƒmL †c^ ‚a‚b vv‚Tƒb ‹Kn[‚C ˆfWLM. ‚SƒW †c‚h …@ƒd ‚Ia„S ^‚V‚CZ.");
 DrawMulitStrBox("‚G‚P‚TG vv‚TƒP …c‚pS Qu‡RM.");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¹£°£°S ƒYƒC!");
 WarGetExp();
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
talk(9,"‡m, …f‰S…l ‚Io „@G „O„kML. a‚b q ‚aM. …c‚pS z‹t‚f.");
 DrawMulitStrBox("‚G‚P‚TG vv‚TƒP …c‚pS Qu‡RM.");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¹£°£°S ƒYƒC!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [376]=function()
 SetSceneID(0,3);
 NextEvent();
 --PlayBGM(5);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚÒéÊÂÌüÌÖÂÛ½ñºóÈçºÎ°ì£®>
 end,
 [377]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚Ia";
 JY.Base["D‚wC"]=14;
 AddPerson(115,8,8,3);
 AddPerson(2,15,10,3);
 AddPerson(114,11,12,3);
 AddPerson(1,37,23,2);
 AddPerson(126,39,24,2);
 SetSceneID(53);
 DrawStrBoxCenter("‚Ia ƒP‚r‰R");
 MovePerson( 1,10,2,
 126,10,2);
talk(115,"[ŠVKLY! †f‚^Ši, I‚rŠW ‡iDaŠVƒmL M‚]hLM.");
 ModifyForce(2,1);
 ModifyForce(114,1);
 LvUp(2,2);
 LvUp(114,2); --¾ç±¾Ô­±¾Ö»ÓĞ¹ØÓğlv+2£¬ÒÁ¼®ÊÇÃ»ÓĞµÄ
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [378]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, I‚rŠW ‡iDaŒsƒW M‚]hLM. ƒQ‚TS ƒsƒ_‚C ˆfB ‡p‚wWLM. ‚GƒG ‚J…x‡z ‰HŠ_ ˆEŠiS ŠGƒm…e ƒvŠXKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒO…m ‚GƒG ‚J…x‡z ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==115 then--Áõçù
talk(115,"‰q †rS [‚V†s‚f ƒd` ‡AƒmŠVKLM. ‡i‡L…y G‡EfƒW sƒG‚h D‚Za‚V‚CZ.",
 1,"‚GƒG, ƒdŠO„p.",
 115,"‡i„Q ‚kKLM. k‚Bf …f‚h D‡z‚KƒN ƒuS `‚EaA G„Vo …IG ‚_q†yKLY? „i? †u‚wŠm?");
 MovePerson(126,1,0);
 MovePerson(126,1,2);
 MovePerson( 126,0,3,
 1,0,3);
 AddPerson(367,39,24,2);
 MovePerson( 367,8,2);
talk(367,"N‹~WLM. ‚Cƒg ‚l[fƒW v…Z ‚r…x‚h ƒsƒ_ŠX‚b…h ‚SŠSXYZ?",
 115,"I‡JG, ‚l[fƒW v…Z ‚r…x‚h ƒs„jMƒd? ‚l[‚b ƒOu‡z ƒX ‚rG^ Šo‚C ‚kƒt†EƒX ‚SŠS¡­¡­ ƒO…m ‚r…x‚h ƒR‚f a‚f.",
 367,"k!");
 MovePerson( 367,8,3);
 DecPerson(367);
 AddPerson(144,39,24,2);
 MovePerson( 144,8,2);
talk(144,"‚J…x‚h ‹n‚M ‹pKLM. …f‚b ƒY†fG‚f WLM.");
 NextEvent();
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚G‚PŠi, G‡EfƒW ŠGGaQ „C„k‚TZ. bƒGY‚C [ŠVƒmL Gd ‚o‚BWLM.");
 end
 end,
 [379]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚l[ƒP ‚r…x^ G„U I‡H …I„S ŠXSY?");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, OF …X‡I‚V[. ‚l[^ ‚K‚JŠ_ vv‚TƒP Fƒo‚h ‹Xƒs…e †[ ƒuhLM. dQ „T‚uG „OKLM.");
 end
 if JY.Tid==115 then--Áõçù
talk(115,"Gd ‡zƒW v…ZG‚fL qCWLM. v…ZG‚fA „l …I~ ŠX‚S…E‚CZ.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"ƒOu‚b ‚l[‡z ƒX ‚rG^ Šo‚C ‚kƒt‚b…h ‚SŠSab ‚Cƒg¡­¡­.");
 end
 if JY.Tid==144 then--Â³Ëà
talk(1,"ƒ_^ ‚G‚PZ.",
 144,"‚U†fƒP ‚Xƒ{ƒb …SŠW ƒR„kKLM. [ƒX ‹pQ „C‚S †~ƒm„S ƒGŒgLM. M„V †Z†G vv‡z ‰jƒOŠVM ƒR„k‚b…h, vv‚TƒP Fƒo‚h ‹D „aƒ` ‚KN q „O†yKLY? vvƒP Nd ‚~ƒ}ƒb Œv…Xƒv ŒjLY?");
 MovePerson( 126,1,3);
talk(126,"ƒ[ƒuƒb d^ †Ca†yKLM.",
 144,"ƒ[‚_‚b?",
 1,"G‡Lƒb ‚J‚XG[.",
 144,"[, ƒ[‚_^ ƒU„S ‚J‚XG‚V‚TZ. …m`ƒP ‚Xƒ{ƒb …SŠW ƒR„kKLM. ‹pQ „C‚S ~‚HhLM. †~, …Xƒl Šoƒb ƒG‚}hLM. …m`ƒP ˆEŠiD ‚l[f „T‚VL o‚W ‚l[f ‡z ‚K‚V‚C ‚k†yKLY?",
 126,"ƒ[ƒuG…Eˆ|„S d^ ƒU‚fŠB ƒUhLM. ‰b ‚l[„S ^†yKLM.",
 144,"‡N‚rWLM. ‚^ƒZ ƒWŠe…e ‡z ‚K‡I‚V[. ƒ[†{ ƒA…e^†yKLM.");
 MovePerson( 144,8,3);
 DecPerson(144);
 MovePerson(126,0,2);
 NextEvent();
 end
 end,
 [380]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"vv^ ‚TS „jƒmL [ƒv‚fD ‹jƒv „D„g†y‚wƒv.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(1,"‚J‚X, ƒY†ffQ ƒ[u ˆ|P‚b…h Fˆ|„S ‡y gG[?",
 126,"…`ƒ` …X‡I‚V[. ‚Cƒg ˆEƒo„S vvf ŠGE q „O‚b G‚b ‡Y‡bŠFhLM. d^ ‚l[„S ^ …A…w‚V ‡Y‡b{ vv^ ŠGŒEQ a†yKLM.",
 2,"‡mƒv ‚l[f‚b ‚ZƒNG ‡AM ƒR„kKLM. „Vf aƒv ‚T‚rŠ_ ‚tƒd‚fD `ƒGA¡­¡­.",
 126,"eƒOŠi, OF …X‡I‚V[. ‚K‚J, …A…w‚V ‡Y‡bS EƒDa†yKLM. ƒ[†{ MˆQ[†yKLM.");
 MovePerson(126,10,3);
 DecPerson(126);
 MovePerson(1,0,2);
talk(115,"‚J‚X …m`Š_ƒW Fˆ| I‚raNYZ?",
 1,"‚Z‚j†yM. ‡mƒv ‡Y‡bG Fˆ| EƒDˆYMA ƒOuD o…~ ‰B„u q „OM. ‚Cƒg ƒOuƒP ‹IƒSƒb ‚J‚XfQ ‚@‚S …R q‹wf ‚a‚wƒv.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==115 then--Áõçù
talk(115,"‚J‚XŠ_ I‡H `‚EG „Oƒm‚V†y‚CZ.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚J‚XG ‚l[„S …yML ƒ[ ƒc…~G OFG‚wƒv.");
 end
 end,
 [381]=function()
 JY.Smap={};
 SetSceneID(-1,8);
 LoadPic(16,1);
 DrawMulitStrBox("d‡y„Xƒb ‚l‹Jƒm„S wH^ ‡Y‡bS EƒDPM. [ƒv‚ffƒW‚b @ˆj†V^ ƒOƒoPƒmƒv, d‡y„Xƒb [ƒP ‚T‚r ‚K‚G‚h EƒDPM. ‚T‡bS ŠC ‚K‚G^ ‚K‚B†V„S ‰BnƒWL [ƒP ‚B@ b‚^‚b ƒ[ŠQQ FBƒFM.");
 LoadPic(16,2);
 SetSceneID(0);
 LoadPic(31,1);
 --DrawMulitStrBox("²Ü²Ù¾üºÍËïÈ¨¾üÔÚ³à±Ú¶ÔÖÅ£¬²Ü²ÙÅÉÖÜè¤µÄ¾ÉÓÑ½¯Ç¬È¥Ëã¼ÆÖÜè¤£¬µ«±»ÖÜè¤Ê¶ÆÆÁË£®ÖÜè¤·´¹ıÀ´¸ø²Ü²ÙÉèÏÂÈ¦Ì×£¬ÀûÓÃ¿àÈâ¼Æ£¬³É¹¦µØÂ÷¹ıÁË²Ü²Ù£¬ÓÚÊÇÉè¿àÈâ¼Æ°¤´òµÄ»Æ¸Ç»ğÉÕ²Ü²Ù¾ü£¬²Ü²ÙË®¾üÔâµ½ÁË»ÙÃğĞÔµÄ´ò»÷£®ÁíÍâÊ¹ÓÃ»ğ¼Æ£¬»¹ÁôÏÂÁËÖî¸ğÁÁ½è¶«·çµÄ¼Ñ»°£®");
 DrawMulitStrBox("vv‚T{ ‡Y‡b‚Tƒb ƒL…WfƒW ‚_„QPM. vv‚b ‚K‚GƒP Œ^ Œz ƒa…yS ƒsƒ_ ƒ[‚h Qƒ` Pƒmƒv ‚K‚GfQ …y†V‡iPM.");
 DrawMulitStrBox("‚K‚G‚b Du‚S vvfQ SS ‹^n ƒd†Q„T„S ƒ[‚h ‡N‹J„GG …{ŠbM. ‡G‚h ŠGƒb ‚U†K^ vv‚Tf …dS ‹^ƒmL vvƒP q‚Tƒb T†UƒLj …@‚pS h„kM. ‡Oo @„T‡z ‰HŠ_ d‡y„XG ‚l…g†SS Œf„kM‚b G…EƒGD …gƒtM.");
 LoadPic(31,2);
 SetSceneID(0);
 LoadPic(17,1);
 DrawMulitStrBox("vv‚b [‚TƒP †LZo …c‚pS …Hƒtƒd, ‚G‚P‚TD d‡y„XƒP ‚Xf ‚i‚f …D„SƒP Z‡tf ‚~ƒ}S †c„QB vv‚h Œ{nŒEŠbM. ƒ[…eƒv …X‚C‡f Z‡tS ‚C‰JŠB eƒO^ vv‚h ‹^n‚K‚S, vv‚b ‚w‚r…I`ƒm„S ˆE‚K„S ˆGnŠgM. vv^ †~Oo G ‰jˆlG G‡MƒU ƒL…W‚_‚BGM.");
 LoadPic(17,2);
 NextEvent();
 end,
 [382]=function()
 JY.Smap={};
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d3ƒa¡¡ˆE‚K …g‚^ F‚D";
 DrawStrBoxCenter("d3ƒa¡¡ˆE‚K …g‚^ F‚D");
 JY.Base["ÏÖÔÚµØ"]="†o†o";
 JY.Base["D‚wC"]=13;
 AddPerson(9,25,9,1);
 AddPerson(69,25,15,2);
 AddPerson(19,23,16,2);
 AddPerson(17,21,17,2);
 AddPerson(78,14,9,3);
 AddPerson(77,12,10,3);
 AddPerson(20,10,11,3);
 SetSceneID(86,5);
 DrawStrBoxCenter("†o†o ƒP‚r‰R");
talk(9,"ƒmŒF! ‹U‹Vo ‚G‚P, ‹U‹Vo ‡Y‡b. G „QŒTƒb …A…w‚V ŒZ †c„S ‹yn ‚Ku‚f. …A…w‚V ‹yn ‚Ku‚f.",
 19,"‚K‚J, M‚Mƒb ‚SŠSa‚VŠqLY!",
 9,"ƒv‚b ƒO…m ‡m†gƒm„S ‰Bn…yM. vj, ƒ[‚_‚h ‚IS q‚P„S R‚XoM. …A…w‚V ‚ISS ‚rqa‚f. „a†y†sŠm?",
 19,"‚XS …HƒR†yKLM!",
 9,"a…C‡], ƒ[‚_‚b †o†oƒ{S ‚C‰a‚f.",
 17,"‚XS …HƒR†yKLM!");
 JY.Smap={};
 SetSceneID(0);
 LoadPic(18,1);
 DrawMulitStrBox("¡¡vv‚b ‚TS sF‚Paƒd…x ‡m†gƒm„S ‰Bn‰tM. G†w vvƒP ˆmG ˆY ˆE‚K‚b vj{ a…C‡]G ‚C…sM.*¡¡vv^ ‹X‚q ˆE‚K‚b ‚G‚P‡z ‡Y‡bG M„e‚b ƒc…q^ „C„kM.");
 LoadPic(18,2);
 NextEvent();
 end,
 [383]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="[";
 JY.Base["D‚wC"]=0;
 AddPerson(142,28,7,1);
 AddPerson(143,20,12,0);
 AddPerson(148,14,9,3);
 AddPerson(149,10,11,3);
 AddPerson(163,6,13,3);
 AddPerson(14,25,15,2);
 AddPerson(144,21,17,2);
 AddPerson(185,17,19,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("[ †X‚B");
talk(143,"vv‚Tƒb ƒL…WfƒW OB Œ[‚V ‚CŠP „OKLM. …AA ƒOu ‚Tƒb G„} ‚rƒG^ ƒi„gKLM.",
 142,"ƒ[ŠQM. ‚CƒgG…Eˆ|„S ˆE‚K‚h †EŠe „UM. ‚K‚G! ƒ[‚_‚h ‚Kƒaƒm„S |n ‚ISS „QQ a†yM!",
 143,"‚XS …HƒR†yKLM! …A…w‚V RI‚h †lqa†yKLM.");
 MovePerson(143,12,1);
 DrawMulitStrBox("¡¡‡Y‡bƒb ‚K‚GfQ ˆE‚K ‚J‚vS ‚XPM. ˆE‚K‚h …Vƒmƒ`‚b [ˆs †fƒQG „I‹If M^†[ ƒuGM.*¡¡G…C ‚K‚G‡z vjƒb ‚ISfƒW ‚p‚BS ‰rŠbM.");
 NextEvent();
 end,
 [384]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚Ia";
 JY.Base["D‚wC"]=14;
 AddPerson(1,8,8,3);
 AddPerson(115,15,10,3);
 AddPerson(126,11,12,3);
 AddPerson(3,10,16,0);
 AddPerson(114,12,17,0);
 AddPerson(64,14,18,0);
 AddPerson(2,21,9,1);
 AddPerson(54,23,10,1);
 AddPerson(128,25,11,1);
 SetSceneID(53);
 DrawStrBoxCenter("‚Ia ƒP‚r‰R");
 DrawMulitStrBox("¡¡G‡Eƒb ‚IaƒP ƒP‚r‰R. ‚l[ƒP ‚K‚G^ vjG ‚C‰J‚b ‚ISS „Qƒd „OM‚b Fƒs^ ƒR‚SŠXM.*¡¡‚ISƒb ˆE‚KƒP ‚e†df „Oƒm†B ‚IaƒP ƒW…g‹Jf …xuoM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [385]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ƒRƒmŠVKLY? ‚K‚G^ ‚ISS „Qƒd „Oƒm†B vv‚b ‚Cƒg ‚ISf ‚aM WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‡mƒv vv „Gƒb …x‚b †q„CQ ‡iB ‰}…E ‡Lq‚h …FLM. „v„U‚h ƒsb ‚KA E‚BB‚C†y‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒL…WfƒW ƒOu ‚Tƒb ‡Y‡b‚T{ ‡Y‹Qƒd vvf ŠGŒUm. ‹Iƒm„SD ƒ[ e„T‚h ‚G‚CW‚VM.");
 end
 if JY.Tid==115 then--Áõçù
talk(115,"†f‚^Ši, †~ƒm„S ‡p‚wWLM. ZŠr ˆuG ‹D Šo‚C ‚kKLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚GƒG^ ZŠr ˆuG Šo‚C ‚kM‚b…h ƒJƒKS‚C ‚Z‚j†y‚wƒv.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"ƒL…W ‰jˆlƒm„S vvƒP ‚~ƒ}D Œv…X…y „{„k†y‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"vv^ ‚aƒmL ‚CƒgG…Eˆ|„S ˆE‚K‚h „y‚CX Šoƒb ƒG‚}‚f ‹bLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ‚K‚G^ ƒL…W ‚_tƒP ƒGƒo‚h …@ƒd ˆE‚K‚h d ‡Yf †pƒmƒ` WLM.",
 1,"‚M¡­¡­",
 126,"ˆE‚K‚b G†w ‚G…qƒP ˆmG nL‚f vvƒP m‚GhLM. ˆE‚K‚h lB †Z†E„S |‚b ƒu„VG vv‡z ‡Y‡bf ŠGE ‚G…Io †rhLM.",
 1,"¡­¡­",
 126,"G ƒ{ aƒv„S‚b vvˆe ‡Y‡bGˆe ƒOu‚h ‡@Q ‚aL q „OKLM. ‚K‚J, ‚^ƒZ †@†Ma‡I‚V[!",
 1,"ƒ[ŠQMA ˆE‚K‚h loM!",
 126,"ŠoKLM. ‚K‚JŠ_ƒW ~‚XaQ †@†MaŠVƒmL ƒWŠe…e ‚ISS „Q‚V‚CZ. …bFS ƒe‚PB ‚K‡I‚V[.");
 MovePerson(115,1,1);
 MovePerson(115,0,2);
talk(115,"†f‚^Ši, d^ ˆuG Šo‚C ‚kn G‚W‰` †c†]„V a†yKLM.",
 1,"ƒ[…eQ. vUŠi, ˆuvu ŠUa‚VQ.",
 115,"k. GŠQQ †dƒ`‚h ŠYŠP …w„tLM.");
 MovePerson(115,12,3);
 DecPerson(115);
talk(126,"ZŠr ‚GƒG ‚J…xƒP ˆuG ‡AG Co ‡KWLM.",
 1,"‚M, ŠZ…I ‚a‚S…E X ‹|…h¡­¡­",
 126,"†~ƒm„S OFhLM. ‚K‚J, ƒ[†GD …bFS ƒe‚Pa‚V‚CZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<½øĞĞ¹¥´ò½­ÁêµÄ×¼±¸¹¤×÷£®>
 NextEvent();
 end
 end,
 [386]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ƒe‚P„C‚VA …f ˆ|ƒd ‚T‚rŠ_ ˆ|Š[a‡I‚V[.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, G…eƒd „OM^‚b ‚K‚G^ ‚ISS „y‚CWLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚Cƒg ‚K‚G‡z vjG ƒ{S ƒv‡z „^Q ‰jƒO‚b ‚eG‚f ‚ISƒ{G ‚P‚S „OM WLM. {…B Šoƒb ƒG‚}hLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚GƒG^ ZŠr ˆuG Šo‚C ‚kM‚b…h ƒJƒKS‚C ‚Z‚j†y‚wƒv.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"ƒL…W ‰jˆlƒm„S vvƒP ‚~ƒ}D Œv…X…y „{„k†y‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"vv^ ‚aƒmL ‚CƒgG…Eˆ|„S ˆE‚K‚h „y‚CX Šoƒb ƒG‚}‚f ‹bLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 --Ô­¾ç±¾´Ë´¦ÓĞĞŞ¸Ä¹ØÓğÕóÓª¼°µÈ¼¶£¬ÎÒÅ²µ½Ç°ÃæÈ¥ÁË
 if talkYesNo( 126,"…b_a‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(27,"d3ƒa ‚IS ‚B„e","1. g„W ‚p…D",30,0,142);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,1,6,4,0,-1,0,
 -1,2,7,4,0,-1,0,
 -1,2,5,4,0,-1,0,
 -1,2,4,4,0,-1,0,
 -1,3,6,4,0,-1,0,
 -1,4,5,4,0,-1,0,
 -1,0,5,4,0,-1,0,
 -1,0,6,4,0,-1,0,
 -1,0,8,4,0,-1,0,
 });
 DrawSMap();
talk(126,"ŠoKLM, ‚~ƒb ƒN…{‰HG ˆHaL Œa‚V …bFa‚V‚CZ.");
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"ŠoM, ‚ISƒm„S g_oM. ‚ISƒb ‚IaƒP ƒW…g‹JGM.");
 ModifyForce(256+1,9);
 ModifyForce(257+1,9);
 ModifyForce(274+1,9);
 ModifyForce(275+1,9);
 ModifyForce(276+1,9);
 ModifyForce(277+1,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 171,18,9,3,2,33,3,0,0,-1,0,
 170,14,9,3,2,31,8,0,0,-1,0,
 256,17,9,3,0,27,2,0,0,-1,0,
 257,16,11,3,0,26,2,0,0,-1,0,
 274,14,10,3,0,27,5,0,0,-1,0,
 275,18,7,3,0,27,5,0,0,-1,0,
 276,16,7,3,0,26,5,0,0,-1,0,
 277,19,8,3,0,27,5,0,0,-1,0,
 142,35,17,3,0,37,16,0,0,-1,1,
 161,33,15,3,4,31,3,24,9,-1,1,
 165,34,18,3,4,31,3,18,14,-1,1,
 164,31,17,3,4,30,3,18,14,-1,1,
 147,32,18,3,4,34,14,18,14,-1,1,
 162,30,18,3,4,34,9,12,9,-1,1,
 148,29,16,3,4,34,20,24,9,-1,1,
 166,28,19,3,4,34,9,24,9,-1,1,
 258,31,18,3,4,27,2,18,14,-1,1,
 259,33,17,3,4,27,2,14,9,-1,1,
 292,26,18,3,4,29,8,18,14,-1,1,
 293,28,18,3,4,29,8,12,9,-1,1,
 294,31,15,3,4,28,8,24,9,-1,1,
 295,32,16,3,4,28,8,24,9,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [387]=function()
 PlayBGM(11);
talk(172,"I‡JG? ‚G‚P‚TG ŠXMƒd? ‡mƒv vj ƒa‚Tƒb ‚K‚G‡z ‰jƒO‚b ‚eGL ‰Bn[N „UY‚C IQ ‚C‰a…E oM.",
 126,"‚K‚J, vjG ‚K‚G‡z ‰jƒO‚b ‚eG‚f ‚ISƒb …i ƒ{hLM. ƒ[ ‰jˆlG ‹[ƒvA vjGˆe ‚K‚Gˆe GŒI ‹JG ‚ISƒm„S …oLM. ƒ[u„CA ‰W‚daL ‚SƒW ƒ{S ‰Hˆya‚V‚CZ.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [388]=function()
 if WarMeet(54,148) then
 WarAction(1,54,148);
talk(54,"G‡Eƒb G†w ƒOu ƒuGM. HŠs‚b ‚SƒW ‚l[„S ‰Bn^‚b „KG ŠoS ƒuGM.",
 148,"I‡H ‰umuŠm! ƒL…WƒP ƒbƒp‚h Šk„k†sŠm. ƒ_^ H‚h ƒq‚S ‚K…X!");
 WarAction(6,54,148);
 if fight(54,148)==1 then
talk(148,"‚_†ia‚wƒv! [H‚f!",
 54,"H‚b C‚_^ ˆf ˆYM!");
 WarAction(5,54,148);
talk(148,"ŠIŠI!",
 54,"dˆFG‚wƒv!");
 WarAction(8,54,148);
talk(148,"a‚b q ‚aM, ‡iB‰M q ‚a‚wƒv!");
 WarAction(16,148);
 WarLvUp(GetWarID(54));
 else
talk(148,"‚_†ia‚wƒv! [H‚f!",
 54,"H‚b C‚_^ ˆf ˆYM!");
 WarAction(5,54,148);
talk(148,"ŠIŠI!",
 54,"dˆFG‚wƒv!");
 WarAction(9,54,148);
talk(54,"a‚b q ‚aM, ‡iB‰M q ‚a‚wƒv!");
 WarAction(16,54);
 WarLvUp(GetWarID(148));
 end
 end
 if (not GetFlag(1036)) and War.Turn==3 then
talk(126,"‚K‚J, ‚K‚G^ vjS „_ƒd Gu„S [ƒd „OKLM. ‚K‚G^ ‹fƒG ‚Bf ‚SƒW ‚ISS ‰Hˆya‡I‚V[.");
 SetFlag(1036,1);
 end
 if (not GetFlag(1037)) and War.Turn==6 then
talk(126,"‚K‚J, ‚K‚G^ ‰b ‹fS‚C ‚Z‹{LM. ƒOu^ ‚ISS ‰HˆyaƒG ‚Bf [A ‰W‚daL ƒW‚[‚j‡I‚V[!");
 SetFlag(1037,1);
 end
 if (not GetFlag(1038)) and War.Turn==8 then
 PlayBGM(11);
 WarShowArmy(142);
 WarShowArmy(161);
 WarShowArmy(165);
 WarShowArmy(164);
 WarShowArmy(147);
 WarShowArmy(162);
 WarShowArmy(148);
 WarShowArmy(166);
 WarShowArmy(258);
 WarShowArmy(259);
 WarShowArmy(292);
 WarShowArmy(293);
 WarShowArmy(294);
 WarShowArmy(295);
 DrawStrBoxCenter("‚K‚G‚TG ƒv…@ŠgM!");
talk(1,"‹zƒb ƒuj^¡­¡­",
 143,"I‡H …IGŠm?",
 148,"‚K‚G D„`, ‚G‚P‚TG ‚ISS „Qƒd „OKLM.",
 143,"I‡JG! ƒOu^ vj{ ‰jƒO‚b Œof …i ƒ{S V„Q†yMƒd? ‚S‚O‚aM! Œa‚V ‚B‚T ‚G‚P‚h ŠP‚f. ‚ISS ‚G‚PfQ „|†r q‚b ‚aM!!");
 PlayBGM(14);
 War.WarTarget="1. ‚K‚G ‚p…D";
 WarShowTarget(false);
 SetFlag(1038,1);
 end
 if (not GetFlag(1039)) and War.Turn==10 then
talk(143,"‚G‚P, ‚J‚X! ƒ_ ‹MƒT‚h ƒsn‚f! ‚Bga‚f!");
 WarModifyAI(142,1);
 WarModifyAI(161,1);
 WarModifyAI(165,1);
 WarModifyAI(164,1);
 WarModifyAI(147,1);
 WarModifyAI(148,1);
 WarModifyAI(166,1);
 WarModifyAI(258,1);
 WarModifyAI(259,1);
 WarModifyAI(294,1);
 WarModifyAI(292,1);
 WarModifyAI(295,1);
 SetFlag(1039,1);
 end
 if (not GetFlag(1040)) and War.Turn==12 then
 WarModifyAI(162,1);
 WarModifyAI(293,1);
 SetFlag(1040,1);
 end
 if (not GetFlag(1041)) and War.Turn==16 then
talk(143,"I‡H …IGŠm? ‚Cƒg ƒUŒ}M! I‚S‚f¡­¡­ ‚T„XG¡­¡­ [, vj{ ‰j…[ „VA„V ƒe‚PPMƒd. ‚M, „a†yM. …C…Da‚f! ‡mƒv ‚G‚P, ‚J‚X. G …Iƒb G‚@„S ‹[G nLM!!");
 WarAction(16,143);
talk(1,"‚SŠS ˆY …IG[? ‚K‚G^ ƒA…eŠgm.",
 126,"‚T„XG „n‚Sg ƒuG†y‚CZ? vj{ ‰jƒO†s‚f ‚T„XS M ‰l „qƒj ‚Z†ohLM.",
 1,"‡L‚X ƒ[ŠQ†y‚C¡­¡­ ƒ[†{ ƒOu^ G‹H‚wƒv.",
 126,"ƒ[ŠQKLM. ‚K‚J, ƒ@a…w„tLM.");
 SetFlag(1041,1);
 NextEvent();
 end
 if JY.Death==172 then
 if not GetFlag(1038) then
talk(172,"ƒm…v!");
 DrawStrBoxCenter("¡¡g„W‚h ƒAu„Qƒd ‚G‚P‚TG ‚ISS ‡F‚YPM.");
 PlayBGM(11);
 WarShowArmy(142);
 WarShowArmy(161);
 WarShowArmy(165);
 WarShowArmy(164);
 WarShowArmy(147);
 WarShowArmy(162);
 WarShowArmy(148);
 WarShowArmy(166);
 WarShowArmy(258);
 WarShowArmy(259);
 WarShowArmy(292);
 WarShowArmy(293);
 WarShowArmy(294);
 WarShowArmy(295);
 DrawStrBoxCenter("‚K‚G^ ƒv…@ŠgM!");
talk(143,"I‡H …IGŠm?",
 148,"‚K‚G D„`, ‚ISG G†w ‚G‚P‚TfQ ‡F‚Y‡iPKLM.",
 143,"I‡JG! ƒOu^ vj{ ‰jƒO‚b Œof …i ƒ{S V‡R†M ˆ|GŠm. †~ƒm„S ‚P‚Aa‚wƒv! †@ŠH „oƒW„Q ‚k†yM.",
 149,"D„`, ƒOu ‚Tƒb vj{ ‰jƒO†s‚f ‡YNG TLM. „l ‰j„EƒW‚b ‚o ŒjLM. ‰Bn^ ‚_‚uS M‚V ƒoƒO‚V‚CZ.",
 143,"n, †~ƒm„S …C‚}‡f†PG„SM. ˆ|o ‚_„S a…x, …C…Da‚f! ‡mƒv ‚G‚P, ‚J‚X. ‚[ƒd ƒsn‚f!");
 NextEvent();
 else
talk(172,"‹U‹Va‚wƒv! …C…DoM¡­¡­");
 SetFlag(214,1);
 end
 end
 WarLocationItem(17,19,17,199); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¹­ÊõÖ¸ÄÏÊé
 if JY.Status==GAME_WARWIN then
talk(143,"‹U‹VaM! G ƒQoƒb …A…w‚V ‹y†yM! ‚G‚P, ‚J‚X. v†da‚f!");
 NextEvent();
 end
 end,
 [389]=function()
 PlayBGM(7);
 if GetFlag(1038) then
 if not GetFlag(214) then
talk(172,"‚K‚G‚TY‚C¡­¡­ ‚G‚P‚TG‚fL¡­¡­ ‡m, …C…Da‚f!");
 WarAction(16,172);
 end
 DrawStrBoxCenter("¡¡‚K‚G‚TG ƒA…eƒvƒd ‚G‚P^ ‚ISS ‡F‚YPM.");
 end
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°£°S …V„kM!");
 if not GetFlag(1038) then
 WarGetExp();
 end
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [390]=function()
 SetSceneID(0,3);
 if GetFlag(1038) then
talk(126,"ŠoKLM, hƒ{a‚V‚CZ!");
 else
talk(126,"‚ISƒm„S ƒR‚S^‚V‚CZ.");
 end
 ModifyForce(256+1,0);
 ModifyForce(257+1,0);
 ModifyForce(274+1,0);
 ModifyForce(275+1,0);
 ModifyForce(276+1,0);
 ModifyForce(277+1,0);
 NextEvent();
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚ½­ÁêÌ¸ÂÛ½ñºóÖ®ÊÂ£®>
 end,
 [391]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="[";
 JY.Base["D‚wC"]=0;
 AddPerson(142,28,7,1);
 AddPerson(143,20,12,0);
 AddPerson(148,14,9,3);
 AddPerson(149,10,11,3);
 AddPerson(163,6,13,3);
 AddPerson(14,25,15,2);
 AddPerson(144,21,17,2);
 AddPerson(146,17,19,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("‚l[ †X‚B");
talk(143,"†~ƒm„S ‡p‚wWLM. …i ƒ{Gƒv MŠK‚aŠB ‚ISS ‚G‚PfQ Šf„h‹HKLM. …fŠsD ƒc…~S ‚@ƒd ‰jfƒmƒv¡­¡­.",
 142,"…M, ‚G‚P ƒ[…x. ƒL…WfƒW ƒOu^ ‚_ƒN vv‚TS „_‚S ‚K„k†EƒX ƒ[ ƒn ƒbƒpv„y Šk„k†M ˆ|j^!",
 143,"G ƒQo †@ŠH Šk‚C ‚k†yM. ˆAŒW^ …A…w‚V ‚G‚P‚h ƒqƒd ˆ|u‚f!!",
 142,"‚K‚G!",
 149,"D„`!");
 MovePerson(149,3,3);
 MovePerson(149,1,0);
talk(149,"D„`, C‹n‚b ƒJƒKƒm‡ILY. ‚Cƒgƒb Z†oG ƒO…mhLM.",
 142,"ƒ[ŠQm. ‚K‚G, ‚S‹cQˆe ˆuS ‰Bƒs‚V[.",
 143,"†dƒ`‚h ŠYŠP …wƒ` †~ƒm„S¡­¡­.",
 149,"D„`, G‹Jƒm„S [‚V‚CZ.");
 MovePerson( 149,12,1,
 143,12,1);
talk(142,"‚G‚P ƒ[…x^ ‚K‚G‚h G ‚Cƒ@ƒm„S „VƒRƒd …f„V GƒDS JƒGƒ` aML, ‚S‚O‚aM! G‚W‰` ƒ_^ „L‰n ‚B‚TS Gˆnƒd ‚ISS ˆjM. ‚B ƒa‚~ƒb …b_S ƒe‚Pa‚f!");
 MovePerson(144,3,2);
 MovePerson(144,1,0);
talk(144,"‚K‚J, ‡d‚V z…c‡I‚V[.",
 142,"I‡H …IG[, ƒY†f?",
 144,"‚K‚G D„`G ‡f OB ƒOu ‚TƒP ‚rƒG^ „n‚SƒFƒmL ‚Cƒg ‚TS …Iƒm‰J‚b ƒuƒb †@ŠH C‚uG n‚`LM.",
 142,"ƒ[†{ ‚SŠSa…x‚b ƒuG[?",
 144,"d^ ‚G‚P‚h o ‚W „l „Vƒv ƒs†yKLM. ƒ[^ ƒOu ‚l[f I‹~‚h ‚mo …IS ‚iˆk E‚XaA ‚G‚PD „anƒRS‚C ‚Z‹{LM. ‚^ƒZ d^ ‰Bn†[ ‡Df ˆl„LG‡I‚V[.",
 142,"„a†ym. ƒ[†{ ‚SƒW ‚G‚P‚h „Vƒvƒd [‚V[.",
 144,"k!");
 MovePerson( 144,12,1);
 NextEvent();
 end,
 [392]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(128,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(64,7,14,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("‚IS ƒP‚r‰R");
 DrawMulitStrBox("¡¡‚G‚P‚b ‚ISS ‡F‚Yo ‡D a…C‡]G ‚C‰JŠB †o†oD ‰HˆyPM. G„S‰l ˆE‚K ‡k‚^‚b ‚Z‚[ ‚G‚PƒP ƒuG „C„kM.*¡¡Œv…X ‡D ‚l[ƒP ƒY†fG ‚ISf ŠXM.");
talk(2,"ˆEŠi, ‚l[ƒP ƒY†fG ‹pƒG‚h ‰RWLM.");
 AddPerson(144,1,5,3);
 MovePerson(144,7,3);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [393]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚l[ƒP ƒY†fG ‹pƒG‚h ‰RWLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚l[ƒP ‚r…xhLY? …M, „s‚V EˆOG†y‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚ISƒb ‚SŠq‚ru Šf„hƒb ƒOu ˆmhLM. D„S ƒ_ƒeM‚b ƒuƒb G„Qf ŠG‚C ‚kKLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚SŠS ˆE‚K‚h ‚l[f „|ŒI†M ˆ|hLY? ƒ[Šl YVG „OKLY? ‚G…qŠ_ƒW nƒNMA ƒYaN ƒuhLM.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚l[^ G ˆmS ƒQoMA ‚~…X„S Šf„hn ƒs‚f‚C!");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚l[f ‚Z‚r^ ‡AM aL, „s‚V ƒ[ƒRG Q‚h ƒ_‚S ˆE‚K‚h ‰Bƒ` ˆG‚f a‚b ƒuG†y‚CZ.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, …`ƒ` …X‡I‚V[. dQ ‡^‚uG „OKLM.");
 end
 if JY.Tid==144 then--Â³Ëà
talk(144,"‚G‚P ‚J, G‚W …Iƒb ƒOu ‚l[„SƒW‚b ‹_ƒDX q ‚am.",
 1,"ƒ[ƒuG I‡H ˆ|Š[GƒN‚C¡­¡­",
 144,"‡i…Bo ˆ|G[. ƒL…WfƒW vvƒP ‚TS Œ{nˆZ ƒuƒb ƒOu ‚TG†B ƒ[ ‚_^D qm. ƒ[…eL ˆE‚K ‚B…r‚b …XˆmŠW ƒOu ƒuG „C‚S…E a[.",
 126,"ƒY†f ‚_j, ƒ[u `‚Ea‚V‚b ƒuƒb ƒn ŠUˆfhLM.");
 MovePerson(126,1,2);
 MovePerson(144,1,1);
 MovePerson(144,1,3);
talk(144,"‚J‚X ‚JG‚V‚TZ. ƒ_ ˆ|G ŒG„~M‚b ƒuG[?",
 126,"G‡Eƒb ƒOu ˆmD nLƒd „l„l„m ‚l[ƒP ˆmD n‚`LM. G‡Eƒb ‚GƒG ‚J…xƒP ˆmhLM.",
 144,"k?¡­¡­",
 126,"G‡Eƒb „v†G ‚G…qƒP m‚GŠbƒd, ƒOu‚b ‚GƒG ‚J…x‚h ‚_ƒNB vvƒP ‡YfƒW „C‹qƒtS ŠFhLM.",
 144,"a, a‚C„V ƒL…W ‰jˆlfƒW ƒOu ‚TƒP ƒYƒd^ ‰uqƒd^ ˆYM‚b ˆ|G[¡­¡­",
 126,"gFa‡I‚V[. ‚GƒG ‚J…xŠ_ƒW ƒX ‚~„Zf „T‚VL „V…IƒP …IG `†r‚C ‚Z‹{LM. ƒ[„U^ „CA G‡ES ‚l[f „|ƒG‚CZ. ‚Cƒgƒb ƒOu^ ‚l[fƒW ‡d‚V Œfƒ` ŠcI‚b ƒuƒm„S a‡I‚VM.",
 144,"„a†ym. ƒ[ ƒ]S ƒOu ‚K‚JŠ_ ‚Ba†ym. G„V ƒA…e^[.");
 MovePerson(144,10,2);
 DecPerson(144);
 MovePerson(126,0,3);
 NextEvent();
 end
 end,
 [394]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"{…B ‚T‚rG‡ILM. ‚[‚S …XƒZ„S ƒY†fS ‰Bƒ`ƒsƒ_ŠV‚TZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…M, ‚SŠS G‡ES [ƒv‚f †KƒRfQ „|ŒI†M ˆ|hLY.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚ISƒb ‚SŠq‚ru Šf„hƒb ƒOu ˆmhLM. D„S ƒ_ƒeM‚b ƒuƒb G„Qf ŠG‚C ‚kKLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"‚SŠS ˆE‚K‚h ‚l[f „|ŒI†M ˆ|hLY? ƒ[Šl YVG „OKLY? ‚G…qŠ_ƒW nƒNMA ƒYaN ƒuhLM.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚l[^ G ˆmS ƒQoMA ‚~…X„S Šf„hn ƒs‚f‚C!");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚l[f ‚Z‚r^ ‡AM aL, „s‚V ƒ[ƒRG Q‚h ƒ_‚S ˆE‚K‚h ‰Bƒ`…Hƒmƒ`‚b ƒuG†y‚CZ.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, G ˆE‚Kf js^ aƒv „OƒmL ‰RB [‚V‚CZ.",
 1,"‚J‚X, ƒ[Q †u‚wZ?",
 126,"…X„XG‚f‚b ‚r†vƒm„S …I^^ ‚Iaf „[M WLM. …XƒT †L‚oƒb aƒv„GG k‚r„B‚C ‚kKLM.",
 1,"…X„XG‚f. ‚Cƒg ‚Iaf „[Mƒd¡­¡­",
 126,"ƒ[ŠQKLM. ‚K‚JƒP ‚XˆoG‚fA …A…w‚V „iX ƒuhLM. ‚K‚J, ‚^ƒZ …X„XS ‰Ra…e ^‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<»á¼û½­ÏÄÂíÁ¼£®>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [395]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚Ia";
 JY.Base["D‚wC"]=16;
 AddPerson(1,25,9,1);
 AddPerson(175,7,14,0);
 AddPerson(31,5,13,0);
 AddPerson(357,27,18,2);
 SetSceneID(71,5);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [396]=function()
 if JY.Tid==357 then--ÉÌÈË
talk(357,"…X„X ˆ|hLY? n, ƒ[ W „IXƒP ‡LG‚CZ. ‚Cƒg ‚}‡if „TN OLM.");
 end
 if JY.Tid==31 then--ÂíÚÕ
talk(31,"n, …f‚b …X„XG nL‚f ƒ[ nƒO …X…{hLM. d Ff „TƒN ‡LG …X„XhLM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
 MovePerson(1,2,2);
 MovePerson(1,5,1);
talk(1,"N‹~‚C„V †O‰HS bv†ym.",
 175,"…f ˆ|hLY? …f‚b …X„XG‚f WLM.",
 1,"[, …A†hmGM. †@‹~^ ‡Aƒtm. ƒv‚b ‚G‚P‚f a[.",
 175,"n, ‡iƒNG ƒU„S ‚G‚PŠiG‡ILY? Œ{‚f‹pƒd I‹~‚h ‚mPKLM.",
 1,"‡i„Q ‚km. ‚Xƒ{S …SŠW Š^ƒd …I‚^…e „Vƒv…e ŠXm. ‚^ƒZ ƒv‚h D‡z‚K‚V[.",
 175,"‚G‚PŠiŠ_ƒW ‰Ra‚V‚b…h ‚SŠS …XMa†yKLY. „@S Ma†yKLM.",
 1,"ƒdŠOm.");
 ModifyForce(175,1);
 PlayWavE(11);
 DrawStrBoxCenter("…X„XG ‚^a^ „C„kM.");
talk(175,"ƒ[uƒd †w‹n m†Ka‚C ˆfPKLM„V, FƒP G ‚r†vƒb d nƒO …X…{ƒm„S ‡GƒO ˆc‚S‚q ŠLƒbGhLM.",
 31,"‹n‚M ‹p†yKLM. …f‚b …X…{G‚f WLM.",
 175,"…X…{D ‡iƒNS ‚nB …Iaƒd…x WLM„V, ƒ]G ‚S‹XaƒN‚CZ?");
 local menu={
 {" …X…{S …hƒ`…yM",nil,1},
 {"…X…{S …hƒ`^‚C ‚k‚bM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"‚M, †~ƒm„S ŠLƒd ‚GƒMa‚wƒ`. ‹Iƒm„S ‚[ ‡L ‚Z‚[ „@‰l ‚K‚V[.",
 31,"{‡Lo ˆ|Š[hLM.");
 ModifyForce(31,1);
 PlayWavE(11);
 DrawStrBoxCenter("…X…{G ‚^a^ „C„kM.");
 elseif r==2 then
talk(1,"‡m, n„L ƒvG^ ‚Sƒj ‡KaL ‹D „l …x‚d ‡Df ˆ`†ym.",
 175,"ƒ[…e‚VMA¡­¡­ …f, ‚G‚PŠi¡­¡­ nIƒuD n‚`LM. ‚K‚J, ^‚V‚CZ.",
 1,"‚M.");
 end
 MovePerson(175,0,2);
talk(175,"‹Iƒm„S ŠU ‚^…aa[. ƒv‚b ‰q…f ‚ISƒm„S ^†ym.",
 31,"†~ƒm„S n‡@KLM.");
 MovePerson( 175,8,1,
 31,8,1);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<·µ»Ø½­Áê£®>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [397]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(175,15,12,3);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(128,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(117,7,14,0);
 SetSceneID(54);
talk(2,"ˆEŠi, ‰Bn[ŠV‚TZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÁ¿½ñºó£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [398]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ‰Bn[ŠV‚TZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…X„XG‚f‚b …f ‚r†v, „IXG Fˆ| aY‚TZ. ƒvGD ƒ[u ‡A‚C ‚kƒb…h W „IXj ‚r†vG M „OKLY?");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"…ZƒN{ IƒaG ƒX„kƒmL †~ƒm„S Šoƒb …IGM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"…X„Xƒb G ƒdƒafƒW GŠK‚q jƒAhLM. ˆEd^ ‚Z‚[ s‚K„S GŠKŠg‚b…h …X„XG ƒmZG‚CZ. „IXG Šs‚S ƒoCfƒW‚b …XƒT[C ‚e †e†w^ ^ƒa ‹oMƒd WLM. nƒO …X…{D s‚K^ „OKLM.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"…X„XG G‡E ‚rFf eM aL …A…w‚V Šoƒb „T‚uS ‰M ƒuhLM.");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"‚K‚J, ‚SŠSa‚V†yKLY?");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‹Iƒm„S ŠU ‚^…a…w„tLM. ‚K‚J, ˆE‚K‚b ‚IS„V „O‚b ƒuG n‚`LM.",
 1,"ƒ[Q I‡H ˆ|G[?",
 175,"‚IS …g‹JƒP „p ‚T, ‰b ~S¡¤IS¡¤„T†o¡¤ƒa‚rhLM. GƒRS ƒOu ~‰S„S |‚b ƒuG ‚S‹c†yKLY?",
 1,"‚M, ‚SƒZ‚^ƒh „Q‚b ƒuG Šo†ym?",
 175,"ƒa‚rf‚b ‚U‡tG‚f‚b „V„V„Q ‚kƒb IƒaG „OKLM. ‰q…f ~S¡¤IS¡¤„T†oS „Qƒd ƒa‚r‚b …X‚C‡ff „Q‚b „KG ŠoKLM.");
 MovePerson(126,0,3)
talk(126,"…X„XƒP ˆ|‚_„S ƒa‚r‚h [ ƒo ‚TS ‰q…f „Qƒd ƒa‚r‚h …X‚C‡ff „Q‚b ƒuG Šo†yKLM.",
 1,"ƒo ‚TS ‚l‚Vf †RYZ?",
 126,"ƒ[uaA ŒjLM! ‚K‚JŠ_ƒW o ‚^‚_‚h Gˆnƒd ~S¡¤IS¡¤„T†o ‚e o ‡Eƒm„S …bFa‡I‚V[. ƒa‚PŠi{ v‡SŠ_ƒW ‚E‚E o ‚T] ŠEƒd, ‚ISƒb eƒOŠiG ‚C‰J‚VA ŒjLM.",
 1,"ƒ[†{ eƒO, ƒa‚P, v‡S{ ƒ_^ ‚E…x ƒv…mM.",
 126,"~S¡¤IS¡¤„T†o ^‡S…h „QN ‚TS aƒv ƒd‚j‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×ö³öÕ÷¾£ÖİÄÏ²¿µÄ×¼±¸£®>
 NextEvent();
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, …X„XG ƒOu g~f ƒR‚SŠXƒmL †~ƒm„S ŠUˆY …IhLM.");
 end
 end,
 [399]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ‚ISƒb d^ ‚C‰JQ B ‚K‡I‚V[.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW Fa‡I‚V[. …f‚b ‰jƒOƒd Š]KLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ƒo ‚T ^‡S…h aƒv‚h ŒA‚f „Q‡I‚V[. …gƒb ‚Tƒb ƒa‚PŠi{ d^ ƒv†u‚S ŠE†yKLM.");
 end
 if JY.Tid==114 then--ÒÁ¼®
talk(114,"…X„Xƒb G ƒdƒafƒW GŠK‚q jƒAhLM. ˆEd^ ‚Z‚[ s‚K„S GŠKŠg‚b…h …X„XG ƒmZG‚CZ. „IXG Šs‚S ƒoCfƒW‚b …XƒT[C ‚e †e†w^ ^ƒa ‹oMƒd WLM. nƒO …X…{D s‚K^ „OKLM.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"M‚M ‰jˆlf‚b ‚^ƒZ …f‚h ƒsƒ_ ‚K‡I‚V[.");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"M‚M ‰jˆlf‚b ‚^ƒZ …f‚h ƒsƒ_ ‚K‡I‚V[.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‚K‚JƒP ‚nƒo‚fA „p ‚TS ‰Hˆya‚b …IGƒb ‚SŠq‚C ‚kKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"…b_oM.",
 3,"ƒnˆEŠi, ‚S†s ‚TS †R‚C ‚SƒW Fa‡I‚V[.",
 54,"…fŠs‚b ‚K‚JƒP ‡D‚h G‚S …bFa†yKLM.");
 ModifyForce(2,0);
 ModifyForce(3,0);
 ModifyForce(54,0);
 JY.Smap={};
 SetSceneID(0);
 PlayBGM(11);
talk(176,"‚G‚P‚TG ~SS ˆjMƒd? ‚M, ‚SŠSB…E aƒv¡­¡­",
 181,"…M! ‚G‚P‚Tƒb vvf ŠGƒW‚b ‚Su„Zƒb IuM. ISS ƒ_„{ q‚b ‚aM!",
 179,"a¡­¡­ ƒv‚b vv‚h †cƒNX q ‚aM. ‡mƒv „T†oƒP ‚Tƒm„S‚b G†r qD ‚a‚wƒv.",
 183,"…M! ƒa‚rf‚b ‚U‡tG „OM! ‚U‡t„V „OƒmA ‚G‚P‚TS ‚[ƒ`„EX YVG ‚aM.");
 PlayBGM(3);
talk(1,"GƒuG ˆE‚K …g‚^ƒP „p ‚Tj^?",
 126,"ƒ[ŠQKLM. …X„XG ˆ|P‡K ƒa‚rf‚b ‚U‡tG‚f‚b †q‚@G „OƒmL ƒa‚r‚b …X‚C‡ff „Q‚V‚CZ. ‚K‚J, ‚SƒZ‚h „Q‚V†yKLY?");
 local menu={
 {" ISS ˆjM",nil,1},
 {" ~SS ˆjM",nil,1},
 {" „T†oS ˆjM",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"„a†yKLM, ISƒm„S ^†yKLM.");
 SetSceneID(0);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 PlayBGM(12);
 WarIni();
 DefineWarMap(30,"d3ƒa IS ‚B„e","1. ƒg…m ‚p†U*2. ƒL‚T ‡g‚D",35,0,180);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,7,18,4,0,-1,0,
 -1,6,17,4,0,-1,0,
 -1,5,17,4,0,-1,0,
 -1,4,17,4,0,-1,0,
 -1,4,16,4,0,-1,0,
 -1,5,16,4,0,-1,0,
 -1,6,16,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 180,28,4,3,0,36,3,0,0,-1,0,
 181,28,9,3,2,31,6,0,0,-1,0,
 232,15,13,3,2,33,12,0,0,-1,0,
 224,13,7,3,2,32,6,0,0,-1,0,
 274,9,11,3,4,27,5,14,13,-1,0,
 275,23,11,3,0,27,5,0,0,-1,0,
 276,27,7,3,0,26,5,0,0,-1,0,
 292,14,7,3,0,29,8,0,0,-1,0,
 293,16,14,3,0,29,8,0,0,-1,0,
 256,8,10,3,4,27,2,12,7,-1,0,
 257,23,7,3,0,26,2,0,0,-1,0,
 310,13,6,3,0,27,11,0,0,-1,0,
 311,16,13,3,0,27,11,0,0,-1,0,
 332,23,9,3,0,27,14,0,0,-1,0,
 333,28,7,3,0,26,14,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent(400); --goto 400
WarSave(6)
 elseif r==2 then
talk(126,"„a†yKLM, ~Sƒm„S ^†yKLM.");
 SetSceneID(0);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 PlayBGM(12);
 WarIni();
 DefineWarMap(31,"d3ƒa ~S ‚B„e","1. ‚GD ‚p†U*2. ƒL‚T ‡g‚D",35,0,175);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,2,18,4,0,-1,0,
 -1,1,17,4,0,-1,0,
 -1,2,19,4,0,-1,0,
 -1,1,18,4,0,-1,0,
 -1,4,18,4,0,-1,0,
 -1,3,17,4,0,-1,0,
 -1,2,16,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 175,7,0,1,2,35,3,0,0,-1,0,
 176,5,0,4,4,33,8,8,1,-1,0,
 336,6,1,4,4,26,15,0,4,-1,0,
 292,9,3,1,1,26,8,0,0,-1,0,
 293,7,2,1,4,26,8,0,4,-1,0,
 294,10,1,3,4,25,8,8,0,-1,0,
 295,9,0,3,1,25,8,0,0,-1,0,
 274,8,2,1,1,26,5,0,0,-1,0,
 275,7,3,1,4,26,5,0,4,-1,0,
 276,9,1,3,1,26,5,0,0,-1,0,
 277,4,1,4,4,26,5,7,1,-1,0,
 177,15,15,3,1,33,12,0,0,-1,1,
 332,14,14,3,1,30,14,0,0,-1,1,
 333,14,13,3,1,29,14,0,0,-1,1,
 340,13,14,3,1,28,17,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(404); --goto 404
WarSave(6)
 elseif r==3 then
talk(126,"„a†yKLM, „T†oƒm„S ^†yKLM.");
 SetSceneID(0);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 PlayBGM(12);
 WarIni();
 DefineWarMap(29,"d3ƒa „T†o ‚B„e","1. v‚m ‚p†U*2. ƒL‚T ‡g‚D",35,0,178);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,12,22,4,0,-1,0,
 -1,12,21,4,0,-1,0,
 -1,13,23,4,0,-1,0,
 -1,11,22,4,0,-1,0,
 -1,11,20,4,0,-1,0,
 -1,14,21,4,0,-1,0,
 -1,13,20,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 178,11,1,1,2,36,3,0,0,-1,0,
 179,11,3,1,0,33,8,0,0,-1,0,
 151,16,9,4,3,33,3,0,0,-1,0,
 256,10,4,1,0,27,2,0,0,-1,0,
 257,8,5,4,0,26,2,0,0,-1,0,
 274,12,3,1,0,27,5,0,0,-1,0,
 275,8,7,4,0,26,5,0,0,-1,0,
 292,16,7,4,1,29,8,0,0,-1,0,
 293,14,9,4,1,29,8,0,0,-1,0,
 332,15,10,4,1,27,14,0,0,-1,0,
 333,8,9,4,0,27,14,0,0,-1,0,
 336,17,8,4,1,27,15,0,0,-1,0,
 337,10,3,1,0,26,15,0,0,-1,0,
 
 340,21,7,3,1,30,17,0,0,-1,1,
 341,22,8,3,1,30,17,0,0,-1,1,
 342,22,9,3,1,29,17,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(408); --goto 408
WarSave(6)
 end
 end
 end
 end,
 [400]=function()
 PlayBGM(11);
talk(182,"‚K‚J, ‚G‚P^ ˆM†dS „^Q …V„kM WLM. ~‚CƒP ‚o‡}S ‚nBƒW‚fD ‡g‚Da‚b „KG Šo†yKLM.",
 181,"I‡H muŠm! „pŒNG ‚G‚P‡z ƒ_„wP‚wƒv!",
 182,"n‚`LM. †@ŠH ƒ[‹@ ƒuG n‚`LM.",
 181,"‹kM! ƒv‚b ‹[Y‚C ‰jƒO†yM!!",
 126,"‚K‚J, ƒL ^‡S…h‚b ƒOu ‚TS ƒsƒd ‰j…[ ƒ]S ŒO‚b …xD „OKLM. ŠU EƒDB ƒs‚V‚b ƒuD Šo†yKLM.");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [401]=function()
 if WarMeet(155,181) then
 WarAction(1,155,181);
talk(155,"…fƒuG ƒLƒP ‚[ƒcGŠm? ŠoM, ƒq‚S ‚JS ƒoƒO†yM.",
 181,"…fw ŒyŠm? „[ƒL „Gƒb …x„S‚T. ƒ[‹@ …x^ ƒv‚h G†r ƒ{Š]ƒmŠm? ŠoM, ƒ_ ‹MƒT‚h ƒsn‚f!");
 WarAction(6,155,181);
 if fight(155,181)==1 then
 WarAction(8,155,181);
talk(181,"ƒm…v!",
 155,"ŠG…TM! ƒLƒP ‚[ƒcS ƒq„kM!");
 WarAction(18,181);
 WarLvUp(GetWarID(155));
 DrawMulitStrBox("¡¡‚K†gG ƒg…mS ƒqƒd,*¡¡‚G‚P‚TG ISS ‡F‚YPM.");
 NextEvent();
 else
 WarAction(4,181,155);
talk(155,"ƒm…v!");
 WarAction(17,155);
 WarLvUp(GetWarID(181));
 end
 end
 if WarMeet(1,182) then
 WarAction(1,1,182);
 PlayBGM(11);
talk(182,"‚G‚PŠi, …f‚b b‚| ƒg…mƒP ‚XS ‚i„gKLM„V¡­¡­ ŠUˆfo …Ij ‡KWLM. G ISƒb ‚G‚PŠiƒP ƒuG „C‚S…E …XˆmWLM. ‡d‚V„V ƒGMƒ` ‚K‡I‚V[. d^ …f B‡tS ‚aŒi†yKLM.");
 WarAction(16,182);
talk(181,"ƒd, ‚J‚C GŒN! I‡H ŒQGŠm! ƒm…v!!");
 WarAction(18,181);
talk(182,"ƒ_^ ƒg…mS ƒq„kM! ƒv‚b ‚G‚PŠiŠ_ ‡g‚DoM!!");
 DrawStrBoxCenter("ƒg…mG …Gƒd ‚G‚P‚TG ISS ‡F‚YPM.");
 NextEvent();
 SetFlag(137,1);
 end
 if WarMeet(-1,225) and (not GetFlag(141)) then
talk(225,"‚M¡­¡­ GƒuG ‚G‚P‚TƒP Nƒ}j^¡­¡­ †~ƒm„S ‚Ia‚wƒv. [v! ƒv‚h D‡zM[!",
 233,"†~ƒm„S IƒMa‚wƒv. ŠoM! ‚B‚T, ‰B‚p!!");
 WarModifyAI(232,1);
 WarModifyAI(224,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(256,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 SetFlag(141,1);
 end
 if WarMeet(-1,233) and (not GetFlag(141)) then
talk(233,"HŠs ‚i‚n^ ƒv‡z ‰jƒO†yMƒd? …M! …C‚}‡f†PaQ B ‚K…X!!",
 225,"[v‚h D‡z…E oM. ŠoM! ‚B‚T, ‰B‚p!!");
 WarModifyAI(232,1);
 WarModifyAI(224,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(256,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 SetFlag(141,1);
 end
 if JY.Death==225 and (not GetFlag(141)) then
talk(225,"‚M¡­¡­ GƒuG ‚G‚P‚TƒP Nƒ}j^? [v, ^…Iƒb …x„pfQ ŠEƒG†y„p!!",
 233,"†~ƒm„S IƒMo …x„S‚T. ˆGnƒv „q„~M. ‚B‚T, ‰B‚p!!");
 WarModifyAI(232,1);
 WarModifyAI(224,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(256,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 SetFlag(141,1);
 end
 if JY.Death==233 and (not GetFlag(141)) then
talk(233,"ƒv, ƒvD ‡iB‰M q ‚aM¡­¡­ ˆGnƒv‚b Q C‚uGM. nGƒd, ƒn…IGM!!",
 225,"[v^ …G„kMƒd!? dƒGŠJ! ‚B‚T, ‰B‚p!!");
 WarModifyAI(232,1);
 WarModifyAI(224,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(256,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 SetFlag(141,1);
 end
 if (not GetFlag(80)) and WarCheckLocation(-1,6,29) then
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°S …V„kM!");
 SetFlag(80,1);
 end
 if JY.Status==GAME_WARWIN then
 DrawMulitStrBox("‚G‚P‚TG ISS ‡F‚YPM.");
 NextEvent();
 end
 WarLocationItem(3,20,70,81); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º·¢Ê¯³µ(23)
 end,
 [402]=function()
 PlayBGM(7);
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°£°S …V„kM!");
 if GetFlag(137) then
 WarGetExp();
 end
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [403]=function()
 if GetFlag(137) then
 SetSceneID(0,3);
talk(182,"‚G‚PŠi, ‹Iƒm„S ‡iƒNS ‚i‚j†yKLM. ŠU ‚^…a…w„tLM.");
 ModifyForce(182,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚J‚C^ ‚^a^ „C„kM.");
 end
 SetSceneID(0,3);
talk(3,"ŠPƒR‚S‰tM! ~SS ‰HˆyPM!!",
 54,"„T†oS ‰HˆyPM!");
 SetSceneID(0,3);
talk(126,"‚K‚J, ƒa‚PŠiG ~SS, v‡SŠ_ƒW „T†oS ‰HˆyPKLM.*‰HŠ_ ‚ISƒm„S ‰Bn^ ƒa‚r ‚J‚vS bƒPa‚V‚CZ.");
 NextEvent(412); --goto 412
 end,
 [404]=function()
 PlayBGM(11);
talk(176,"nI†GD ‚G‚P‚h ‡iB‰M q ‚a†y‚wƒv. „y‚fu G ƒG‚}f ‚G‚P‚Tf ‡g‚Da‚b ƒuG¡­¡­.",
 177,"n„qŠi, ƒ[ I‡H ˆ|Š[G‡ILY! ‚G‚P ‚i‚n‚b d^ ƒq‚S ƒsG†yKLM.",
 176,"‚M, ‡mƒv¡­¡­",
 126,"‚K‚J, ƒLG ƒOu ‚TS ƒsƒd ‰j…[ ƒ]S ŒO„kS‚C ‚Z‹{LM. ŠU EƒDB ƒs‚V‚b ƒuD Šo†yKLM.");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [405]=function()
 if WarMeet(128,178) then
 WarAction(1,128,178);
talk(128,"vv‚b G†w ˆE‚K‚h ‹XŠgm. ‚Cƒg ‡g‚DaA ƒc…~ƒb w‹T q „Om.",
 178,"aaa! ~SS ƒQoMA „p Nƒ}ƒm„S Šf„hn ƒsn‚f. OG ƒv†sŠm?!",
 128,"I‡H muŠm! ƒ[ ˆ| Šk‚C …X‚f!");
 WarAction(6,128,178);
 if fight(128,178)==1 then
talk(178,"I, I‡JG! G†GƒW‚b¡­¡­.",
 128,"ƒ_ …X‚C‡f ‹FS …Hn‚f!");
 WarAction(8,128,178);
talk(178,"nGƒd, ƒv‚b Gd ŒG„~M.");
 WarAction(17,178);
talk(128,"…M, ƒnmu„QŠB …x„S‚T.");
 WarLvUp(GetWarID(128));
 else
 WarAction(4,178,128);
talk(128,"nGƒd, ƒv‚b Gd ŒG„~M.");
 WarAction(17,128);
 WarLvUp(GetWarID(178));
 end
 end
 if (not GetFlag(1042)) and War.Turn==2 then
 WarModifyAI(293,1);
 WarModifyAI(275,1);
 WarModifyAI(336,1);
 SetFlag(1042,1);
 end
 if (not GetFlag(77)) and WarCheckArea(-1,5,0,10,12) then
talk(177,"ˆED~, …bFX „UM.",
 1,"„i?");
 WarShowArmy(177);
 WarShowArmy(332);
 WarShowArmy(333);
 WarShowArmy(340);
 DrawStrBoxCenter("ƒLƒP ‡O M‡M ‚^‚_^ ƒv…@ŠgM!");
talk(178,"‚rƒ_ƒRn! ‚G‚P …f…x‚h ŠP …Gb‚f.",
 177,"n„qŠi! ‚S‹cKLY? d ‚BƒHG ‚S‹XWLY?",
 176,"‚M¡­¡­ †|†}a‚wƒv¡­¡­");
 SetFlag(77,1);
 end
 if WarMeet(1,176) then
 WarAction(1,1,176);
talk(1,"‚GD, „l ‰j„ED t„[ƒb ‚am. ‚S‹cm, ‡g‚Da‚V[!",
 176,"k, „a†yKLM. G ˆmS ƒU„Q†yKLM.");
 DrawMulitStrBox("‚GD^ ‡g‚Daƒd ‚G‚P‚TG ~SS ‡F‚YPM.");
 SetFlag(1043,1);
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 DrawMulitStrBox("‚G‚P‚TG ~SS ‡F‚YPM.");
 NextEvent();
 end
 WarLocationItem(6,0,65,165); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¶ÓÊé ¸ÄÎª Ôô±øÊÄÑÔ
 end,
 [406]=function()
 PlayBGM(7);
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°£°S …V„kM!");
 if GetFlag(1043) then
 WarGetExp();
 end
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [407]=function()
 SetSceneID(0,3);
talk(3,"ŠPƒR‚S‰tM! ISS Z„]„~M!",
 54,"„T†oS ‰HˆyPM!");
 SetSceneID(0,3);
talk(126,"‚K‚J, ƒa‚PŠiG ISS, v‡SŠ_ƒW „T†oS ‰HˆyPKLM.*‰HŠ_ ‚ISƒm„S ‰Bn^ ƒa‚r ‚J‚vS bƒPa‚V‚CZ.");
 NextEvent(412); --goto 412
 end,
 [408]=function()
 PlayBGM(11);
talk(179,"nI†GD ‚G‚P‚TS ‡iB‰M q ‚aƒmL „y‚fu ‡g‚Da‚b ƒuG¡­¡­.",
 180,"‚K‚J, ƒ[ I‡H ˆ|Š[G‡ILY!",
 152,"ƒ[ŠQKLM! ‚G‚P ‚i‚n‚b d^ ƒq‚S ƒsG†yKLM!",
 179,"‚M¡­¡­ ‡mƒv¡­¡­",
 126,"‚K‚J, ƒLG ƒOu ‚TS ƒsƒd ‰j…[ ƒ]S ŒO„kS‚C ‚Z‹{LM. EƒDaA ‰jƒO‚C ‚kƒdD G†r q „OKLM.");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [409]=function()
 if WarMeet(117,152) then
 WarAction(1,117,152);
talk(117,"ƒLƒaƒb ‚SƒZ „O†sŠm! ‚G‡WG D‚BoM!",
 152,"ƒd‡Co ŒN. ‚G‚P‚Tƒb ƒOJ‚_‚C …X‚f! ƒ_^ C‚_a…X!");
 WarAction(6,117,152);
 if fight(117,152)==1 then
talk(152,"…iŒoG „OM!");
 WarAction(5,152,117);
 WarAction(8,117,152);
talk(152,"‹[GM, ‹[G…E¡­¡­ ƒv‚b ‹[ŠgM¡­¡­");
 WarAction(18,152);
talk(117,"ŠoM, ƒLƒaS ƒq„kM!");
 WarLvUp(GetWarID(117));
 else
talk(152,"…iŒoG „OM!");
 WarAction(4,152,117);
talk(117,"‚_†Ma‚wƒv!");
 WarAction(17,117);
 WarLvUp(GetWarID(152));
 end
 end
 if WarMeet(1,179) then
 WarAction(1,1,179);
talk(1,"v‚m, „l ‰j„ED t„[ƒb ‚am. ‚S‹cm, ‡g‚Da‚V[!",
 179,"k, „a†yKLM. G ˆmS ƒU„Q†yKLM.");
 PlayBGM(7);
 DrawMulitStrBox("v‚mG ‡g‚Daƒd ‚G‚P‚TG „T†oS ‡F‚YPM.");
 SetFlag(1043,1);
 NextEvent();
 end
 if (not GetFlag(142)) and WarCheckArea(-1,4,8,9,16) then
 PlayBGM(11);
talk(179,"„i? …fƒuƒb?");
 WarShowArmy(340);
 WarShowArmy(341);
 WarShowArmy(342);
 WarModifyAI(333,1);
 WarModifyAI(275,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 DrawStrBoxCenter("GˆM„RG ƒv…@ŠgM!");
talk(180,"…fƒuƒb? ‚K‚J! ‰RPŠB ƒQ‚TG ŠXKLM. …fƒR{ „@S WŠP ‚G‚P‚h ƒAu„Q‡I‚V[!",
 179,"‚M, ƒ[ŠQ‚T¡­¡­");
 PlayBGM(17);
 SetFlag(142,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("‚G‚P‚TG „T†oS ‡F‚YPM.");
 NextEvent();
 end
 WarLocationItem(7,4,67,166); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º×ÇÁ÷Êé ¸ÄÎª ÒìÎÄ»¯Ó¡
 end,
 [410]=function()
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°£°S …V„kM!");
 if GetFlag(1043) then
 WarGetExp();
 end
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [411]=function()
 SetSceneID(0,3);
talk(3,"ŠPƒR‚S‰tM! ISS Z„]„~M!",
 54,"~SS ‰HˆyPM!");
 SetSceneID(0,3);
talk(126,"‚K‚J, ƒa‚PŠiG ISS, v‡SŠ_ƒW ~SS ‰HˆyB ‚[ ƒ{ ‚Z‚[ „n‚SƒFKLM. ƒ[†{ ‰HŠ_ ‚ISƒm„S ‰Bn^ ƒa‚r ‚J‚vS bƒPa‚V‚CZ.");
 NextEvent(412) --goto 412
 end,
 [412]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(128,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(175,9,15,0);
 AddPerson(117,7,14,0);
 ModifyForce(2,1);
 ModifyForce(3,1);
 ModifyForce(54,1);
 SetSceneID(54,5);
talk(175,"‚K‚J, ƒo ‚TS ‡F‚YaŠVƒmL †~ƒm„S ƒ@‚rhLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÁ¿ËùÊ£³¤É³Ö®ÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [413]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚K‚J, ‰Bn[ŠV‚TZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"d^ ƒvŒUMA ƒ{ aƒvŠeGƒb ‚KŠcL …{ ƒAw ŒMƒ_‡K PS OLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"†D ~‚CƒP †eƒ{ƒRG ‚Z‚[ ‚K‚JƒP ‚XˆoS ƒO…e‚jƒd „OKLM.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"G†w ƒo ‚TS ‡F‚YPƒmL ƒ@‚rhLM.");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"aƒv^ …gƒtKLM. ƒa‚r„V Z„]uA ˆE‚K ‚B†JG ƒOu ƒuG ŒjLM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‚K‚J, ƒo ‚TS ‡F‚YaŠVƒmL ƒ@‚rhLM.",
 1,"‚M, Gd ƒa‚r„V …gƒt‚wƒ`. G‡Eƒb ‚SŠS „Q‚b ƒuG Šo†ym?",
 175,"ƒ[ŠQKLM. …X‚C‡fƒm„S †w_ YVƒb ‚U‡tG‚f‚b IƒaG †eƒs‚s†oƒP ˆd ‹MƒT‡z „V‚^‚^‡iƒP „o†_S ‚C‰CM ƒR„kƒG „U…ZhLM.",
 1,"‚U‡tG‚f aŠbm?",
 175,"‚U‡tƒb G†w k„AG „|„kƒmƒv ŠLƒbGƒRD ‡iBƒ_‚C ˆfWLM.",
 1,"‚M, Fˆ| ƒ[…eo^?",
 126,"‡mƒv G‡ES ‰HˆyaA ˆE‚K ‚B†JG ‚K‚JƒP ƒuG ŒjLM. ‹IƒSS ‚nBƒW‚fD ƒa‚r‚b „Q‚C ‚kS q ‚aKLM.",
 1,"‚M, ƒ[ŠQ‚T. …bFoM!",
 126,"ƒ[†{ ‚K‚JŠ_ƒW‚b …bFS ƒe‚Pa‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×ö³öÕ÷³¤É³µÄ×¼±¸£®>
 NextEvent();
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"„p ‚T ‚e GS ‡F‚YPƒmL Gd ƒa‚r„V …gƒtKLM.");
 end
 end,
 [414]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, G‚W‰` dQ ŠE„} ‚K‡I‚V[. …A…w‚V ‚U‡tS ‚r„S‹Qn [†yKLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"eƒO ˆEŠiG ƒ{S ‚C‰JQ „C‚S ƒW‡SaƒN ‚Z†ohLM. ‰RG „OKLM, …fD ‚i‚f^ ‰jƒO†yKLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚SƒW …bFa‚V‚CZ!");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚K‚J, ‚SƒW …bFa‚V‚CZ!");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"ƒa‚r‚h ‰HˆyaA ˆE‚K ‚B†JG ƒOu ƒuhLM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‚^ƒZ ‚U‡tS ‚EŠZŠW v†da‡I‚V[.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(32,"d3ƒa ƒa‚r ‚B„e","1. or ‚p†U*2. ƒL‚T ‡g‚D",40,0,182);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,2,3,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 -1,2,4,4,0,-1,0,
 -1,3,2,4,0,-1,0,
 -1,1,4,4,0,-1,0,
 -1,1,2,4,0,-1,0,
 -1,4,3,4,0,-1,0,
 -1,3,4,4,0,-1,0,
 -1,2,5,4,0,-1,0,
 -1,5,3,4,0,-1,0,
 -1,2,6,4,0,-1,0,
 });
 DrawSMap();
talk(126,"ƒa‚r„S …bFa†yKLM.");
 JY.Smap={};
 SetSceneID(0,11);
talk(183,"I‡JG? ƒo ‚TG ‰Hˆy„C„kMƒd? …f ƒv‡Co ƒuƒR. ƒ_Q‚b ‚U‡tG „OM. b‰}‚f, ‚U‡t!",
 170,"dQ ŠE„} ‚K‡I‚V[. ƒG‚_‚h …f„qu‚C ‚k†yKLM.");
 SetSceneID(0,3);
talk(1,"ŠoM! ƒa‚rY‚C ‰HˆyaA ˆE‚K ‚B†JG ƒOu ƒuG ˆYM! ƒa‚r„S g_a‚f!");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 182,33,19,2,2,38,2,0,0,-1,0,
 183,18,9,3,2,32,8,0,0,-1,0,
 169,33,14,3,0,33,22,0,0,-1,0,
 126,33,17,2,2,33,15,0,0,-1,0,
 256,18,7,3,2,32,3,0,0,-1,0,
 257,34,13,3,0,30,3,0,0,-1,0,
 274,17,8,3,2,32,6,0,0,-1,0,
 275,27,7,3,0,30,6,0,0,-1,0,
 276,23,15,3,0,30,6,0,0,-1,0,
 277,24,14,3,0,30,6,0,0,-1,0,
 278,31,15,3,0,32,21,0,0,-1,0,
 292,27,9,3,0,32,9,0,0,-1,0,
 293,24,16,3,0,32,9,0,0,-1,0,
 294,22,16,3,0,31,9,0,0,-1,0,
 295,32,16,3,0,31,9,0,0,-1,0,
 336,28,8,3,0,30,15,0,0,-1,0,
 332,16,9,3,2,30,14,0,0,-1,0,
 310,28,6,3,0,30,12,0,0,-1,0,
 296,34,15,3,0,30,9,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [415]=function()
 PlayBGM(11);
talk(183,"‚U‡t, ‚G‚P‚TG ‚S†A‚C ƒv^ o‚W ‰j„E ƒs‚f. ƒv‚b bƒGƒW ‚B‚US †j‰X†yM.",
 170,"k, ŠE„} ‚K‡I‚V[. …A…w‚V ‚K‚JƒP ƒG‚_‚h …f„qu‚C ‚k†yKLM.",
 127,"orfQ ƒNƒo‚h ƒFƒmL …bFa‚C ‚kS q ‚a‚wƒv. ‡mƒv¡­¡­ ‚G‚P‡z‚b ‰jƒOƒd Š]‚C ‚kM. ‚U‡tƒb ‚SŠS …fu orfQ ‡tƒ{a‚b^? orƒb ‚Su„Zƒb ‚KjG†EƒX¡­¡­.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [416]=function()
 WarLocationItem(4,28,59,167); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÓ¢ĞÛÖ®½£
 WarLocationItem(17,20,155,168); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÎèÅ®Àá
 if (not GetFlag(143)) and WarCheckArea(-1,5,12,9,18) then
talk(1,"„i? …f mu‚b I‡JGŠm?",
 184,"I‡JG? ‚IƒAG „|ˆjMƒd¡­¡­ q‚JGŠm? Œf‚SKS! ‚SŠS ƒ_Q ˆ|a‚C ‚kƒt†sŠm?");
 PlayWavE(53);
 WarFireWater(10,4,2);
 WarFireWater(12,4,2);
 WarFireWater(8,5,2);
 WarFireWater(10,5,2);
 WarFireWater(9,6,2);
 WarFireWater(9,7,2);
 WarFireWater(6,8,2);
 WarFireWater(8,8,2);
 WarFireWater(7,9,2);
 WarFireWater(8,9,2);
 WarFireWater(6,10,2);
 WarFireWater(5,11,2);
 WarFireWater(5,12,2);
 WarFireWater(10,7,2);
 WarFireWater(11,7,2);
 WarFireWater(12,7,2);
 WarFireWater(13,7,2);
 WarFireWater(14,7,2);
 WarFireWater(15,7,2);
 WarFireWater(16,7,2);
 WarFireWater(15,6,2);
 WarFireWater(17,6,2);
 WarFireWater(16,5,2);
 WarFireWater(17,5,2);
 WarFireWater(18,4,2);
 WarFireWater(15,8,2);
 WarFireWater(18,8,2);
 WarFireWater(17,9,2);
 WarFireWater(16,10,2);
 WarFireWater(15,11,2);
 WarFireWater(16,12,2);
 DrawStrBoxCenter("ƒLƒP q‚Jf ‚@„~M!");
 WarEnemyWeak(1,1);
talk(184,"ƒv, ƒv‚b¡­¡­ or, G …x^¡­¡­.");
 WarAction(17,184);
 WarAction(17,257);
 WarAction(17,275);
 WarAction(17,333);
talk(1,"d ‚^‚_ƒP `‚rv„y ‰Bƒs‚C ‚kML¡­¡­.",
 183,"aaa¡­¡­ ‚G‚P, MŠTS ‹D ƒsƒt†sŠm!",
 127,"or, GQ I‡H ŒQGŠm! d ‚r†vv„y ‰Bƒs‚C ‚k‚b†M ˆ|GŠm?",
 183,"I‡JG? ƒ_ ƒcƒL„V Gƒ^A ƒ[„VG‚C ŒZ ‚r†v …G‚b ƒuG ‚_qŠm? aaa!");
 WarEnemyWeak(2,2);
 WarFireWater(10,4,3);
 WarFireWater(12,4,3);
 WarFireWater(8,5,3);
 WarFireWater(10,5,3);
 WarFireWater(9,6,3);
 WarFireWater(9,7,3);
 WarFireWater(6,8,3);
 WarFireWater(8,8,3);
 WarFireWater(7,9,3);
 WarFireWater(8,9,3);
 WarFireWater(6,10,3);
 WarFireWater(5,11,3);
 WarFireWater(5,12,3);
 WarFireWater(10,7,3);
 WarFireWater(11,7,3);
 WarFireWater(12,7,3);
 WarFireWater(13,7,3);
 WarFireWater(14,7,3);
 WarFireWater(15,7,3);
 WarFireWater(16,7,3);
 WarFireWater(15,6,3);
 WarFireWater(17,6,3);
 WarFireWater(16,5,3);
 WarFireWater(17,5,3);
 WarFireWater(18,4,3);
 WarFireWater(15,8,3);
 WarFireWater(18,8,3);
 WarFireWater(17,9,3);
 WarFireWater(16,10,3);
 WarFireWater(15,11,3);
 WarFireWater(16,12,3);
 SetFlag(143,1);
 end
 if (not GetFlag(144)) and WarCheckArea(-1,9,24,15,32) then
talk(127,"{…B ‚G‚P‚TG„SM. †~ƒm„S ‚Ia‚wƒv¡­¡­",
 183,"G‹@! ƒL‚TG G†w ƒ{ n†GY‚C ŠXM. ƒOu ‚Tƒb IŒv a†sŠm? ŠP‚f!");
 WarModifyAI(336,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(310,1);
 SetFlag(144,1);
 end
 if WarMeet(1,127) then
 WarAction(1,1,127);
talk(127,"„i? …fƒuƒb¡­¡­ ŠU‹kM, ‚G‚PŠiGƒN^?",
 1,"n? †u‚wZ?",
 127,"‚G‚PŠi, …f‚b „v†G ‚G…qƒP ‚^aŠbŠB ‚n…BG‚f WLM. d G…EƒG‚b ƒv‚ef …wuƒd, ‚Cƒgƒb ƒa‚rf …~ƒb B‡tS ‚aŒi…e ^†yKLM. G„V!");
 WarMoveTo(127,33,18);
 WarAction(1,127,183);
talk(183,"I, I‡JG? ‚n…B, G †cƒN…x!",
 127,"G‚b †cƒNG nLM. „p m‚]f ‚_o ƒ{‚q †eƒ{ƒP „iƒsM. …G‚S‚f!");
 WarAction(8,127,183);
talk(183,"ƒm…v!!");
 WarAction(18,183);
talk(126,"‚K‚J, ƒLG ‡g‚Do ‡KWLM.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡orG …Gƒd ‚G‚P‚TG ƒa‚r‚h ‡F‚YPM.");
 SetFlag(1044,1);
 NextEvent();
 end
 if WarMeet(2,170) then
 WarAction(1,2,170);
talk(2,"‚M, …f ƒYƒa¡­¡­ k‚r„B‚C ‚k‚wƒv. ƒYƒa, GŠKS ‚_‚f!",
 170,"G „s‚^…E! I‹~a‚wƒv! ƒv‚b ‚U‡tGM!",
 2,"ƒ[‚_^ ƒU„S ‚U‡tj^? G eƒO^ …I‚_…I„S „}ƒ^†ym.",
 170,"ˆC, ŠR„kMƒd „V„VŠW ƒs‚b ‚Z†oG‚wƒv. ŠLƒbG, „T„[S ŠUˆfPM. …G‚S‚f!");
 WarAction(6,2,170);
 if fight(2,170)==1 then
talk(2,"ŠP‚f!");
 WarAction(5,2,170);
talk(170,"ƒm…v!",
 2,"G‹@? ¡­¡­ˆ|G _S ‰uƒZ`‚wƒv¡­¡­",
 170,"†~ƒm„S ‡SG ‚a‚wƒv. GƒuD ‚Xj^. ‚SƒW ƒv‚h ƒq‚S‚f!");
 WarAction(15,2);
talk(2,"¡­¡­ƒc…~ƒb †jƒ` ‚[†ym. ‚SƒW ˆ|S ƒUa …@ƒd M‚V „}b‚VM.",
 170,"I‡JG? †~ƒm„S ƒdŠOm. ƒ[†{ ˆ|S ƒUa [†ym.");
 WarAction(16,170);
 WarLvUp(GetWarID(2));
talk(183,"‚U‡t! ‡NŠW ƒL{ ƒ_„waŠb†sŠm!",
 170,"„F…[WLM. …f‚b †@ŠH ƒ[‹@ ‚r†vG n‚`LM.",
 183,"ˆvŠP‚f! eƒO‡z …I‚_…I„S „}ƒ^‚b ƒuS ƒsƒtM. eƒO^ H‚h ƒq‚C ‚kƒd Du‚S ‰Bƒ`ƒs„jƒmL GƒuG ƒ_„wƒP ‰d†E^ nLƒd I‡JGŠm?",
 170,"n‚`LM. ƒ[ƒuƒb¡­¡­.",
 183,"‚t‚Xƒb Š^‚C ‚k†yM! ‚SƒW G…xƒP ƒcS ŠP‚f!");
 WarMoveTo(127,33,18);
 WarAction(1,127,183);
talk(127,"or! ‚C‚q ‚JƒLƒb vƒgD ŠInu‚C ‚kƒd ‚U‡tS ƒqƒ` aML, ‚T…xƒP Du^ nLM. aƒXS ‚_ƒNB H‚h ‰ra†yM!",
 183,"n, ‚n…B! ‚n…BS ƒq‚S‚f! ‚SƒW Q nID ‚a†sŠm!");
 WarAction(8,127,183);
talk(183,"n¡­¡­");
 WarAction(18,183);
talk(126,"‚K‚J, ƒLG ‡g‚Do ‡KWLM.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡orG …Gƒd ‚G‚P‚TG ƒa‚r‚h ‡F‚YPM.");
 NextEvent();
 else
 WarAction(4,170,2);
talk(170,"eƒO‚b ƒSˆc‚C …X‚f. G ‚U‡tƒP @†jS …Hn‚f!",
 2,"ƒm…v!");
 WarAction(17,2);
 WarLvUp(GetWarID(170));
 end
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG ƒa‚r‚h ‡F‚YPM.");
 NextEvent();
 end
 end,
 [417]=function()
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°£°S …V„kM!");
 if GetFlag(1044) then
 WarGetExp();
 end
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [418]=function()
 SetSceneID(0,3);
talk(126,"ƒ[†{ ƒa‚rƒ{ƒm„S ƒR‚S^‚V‚CZ.");
 NextEvent();
 end,
 [419]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒa‚r";
 JY.Base["D‚wC"]=17;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,11,16,0);
 AddPerson(127,15,12,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("ƒa‚r ƒP‚r‰R");
talk(127,"‚G‚P ‚K‚J, …f‚b ‚n…BG‚f WLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ºÍÎºÑÓÌ¸»°>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [420]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚U‡tƒb ƒvG^ ‡Aƒmƒv b‚BŠW Ik^ ˆc‚S‹_LM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚U‡t{ „}ƒ^‚C ˆfo ƒuG †~ƒm„S n‡@KLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, G ‚r†vS ‚SŠS ‹n‡La‚V†yKLY?");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"…gƒb ƒa‚rƒP ‚Tƒb ‚G‚PŠiŠ_ ‡g‚DPKLM. Gd‚^ƒh …fD ‚G‚PŠiS ‚nB …Ia†yKLM.",
 126,"‚K‚J, ‡d‚V ƒGMu‡I‚V[.");
 MovePerson(126,0,3);
talk(1,"‚J‚X, I‡H …IG[?",
 126,"G ‚r†vS ‚^a„S †E‚[‚b …h ‡Zƒ{a‚C ‚kKLM.",
 1,"‚SŠSab?",
 126,"G ‚r†vƒb ‚Bf ‚G…q‚h ˆL‹HKLM.",
 127,"¡­¡­ƒ[ŠQKLM.",
 126,"‚G…q^ …G…x orfQ ŒE„kƒd, Gd orG ‚n‚|„B…x ‰bƒU„S Œ^ ‚KjS †cƒNaƒd ‚K‚JŠ_ ‹Z„} ŠXKLM. G‹@ …x^ ˆAd ‡O M‡M GfQ ŒES‚C ‚SŠS „a†yKLY?",
 1,"‡mƒv ‚J‚X, ƒ_Q ‡g‚Daƒ`‚b ‚r†vS ƒAu„QA ‹Iƒm„S nID ‡g‚DB [‚C ‚kS ƒuG[. ƒ[uX q‚b ‚am.",
 126,"¡­¡­„a†yKLM. ƒ[†{ ƒ]‚_„S a‡I‚V[.");
 MovePerson(126,0,2);
talk(1,"‚n…B, …X‚Mf ‚[‚C …X‚V[. ƒ_^ ŠU ‚_a†yƒmL ‹Iƒm„S „@‰l …Ia‚V[.",
 127,"¡­¡­k! k!");
 ModifyForce(127,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚n…BG ‚^a^ „C„kM!");
talk(1,"‚M¡­¡­ ‚SŠS ‚U‡tƒb b‚| ƒsG‚C ‚k‚b^?",
 127,"‚U‡tƒb orG …G„kM‚b m‚yS Š^ƒd „{‰b †Lf ŠcƒA†B ‡YŠiS „Vƒv‚C ‚k‚bM WLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥¹ÙÛ¡»á¼û»ÆÖÒ>
 NextEvent();
 end
 end,
 [421]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ‚U‡tS ‹qn^ ƒs‚V‚CZ. …f‹@ js‚b I„Q ‚kKLM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚U‡t{ „}ƒ^‚C ˆfo ƒuG †~ƒm„S n‡@KLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚JŠ_ƒW ‚n…BS ˆ`N ƒ]G‚fA …f‚b G†TG ‚aKLM.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚U‡tƒb orG …G„kM‚b m‚yS Š^ƒd „{‰b †Lf ŠcƒA†B ‡YŠiS „Vƒv‚C ‚k‚bM WLM.");
 end
 end,
 [422]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒa‚r";
 JY.Base["D‚wC"]=17;
 AddPerson(1,5,10,3);
 AddPerson(170,21,12,1);
 SetSceneID(46,2);
 DrawStrBoxCenter("ƒa‚r ‚U‡tƒP †L");
talk(170,"ˆ|a‚C ‚kƒtm. ƒv‚b nID „Vƒv‚C ‚km.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [423]=function()
 if JY.Tid==170 then--»ÆÖÒ
 MovePerson(1,5,3);
 MovePerson(1,2,0);
talk(170,"ˆ|Pcm, †u‚wD „Vƒvƒd Š]‚C ‚kMƒd. ¡­¡­n, aj „G‚C‚b ‚k‚wƒ`.",
 1,"…do ‹qn‡z †w‚oa[. ƒv‚b ‚G‚P‚f a[.",
 170,"I‡JG[? ‚G‚PŠiG‡ILY? du ƒv^ ŠG‚C ˆfB N‹~^ ‡AƒtKLM.",
 1,"‚U‡t, ƒv‚b ƒ[‚_ „Gƒb †q‚@G …YNŠW „sZa[. ‚S‹cm, ƒOu ‚Tf ƒR‚S[‚C ‚k†ym?",
 170,"¡­¡­…GRS ‡iBD …Xˆmo G ˆufQ ˆum ‹qn‡z ˆ|Š[a‚VL¡­¡­ „a†yKLM. G ‚U‡t, ƒGŒMG ‡iƒNS ˆLƒG†yKLM.");
 ModifyForce(170,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚U‡tG ‚^a^ „C„kM!");
talk(1,"†~ƒm„S ŠU‹km. ƒ[†{ ‰HŠ_ ‚ISƒm„S †h‚VM.",
 170,"k.");
 PlayBGM(8);
 DrawMulitStrBox("¡¡Guab …g‚^ „p ‚Tƒb ‚G‚PƒP „o‚~ƒm„S ‚Z‚[ ƒwF„C„kM. ˆE‚K‚b ƒOb‰V…Y ‹[f …Xƒlƒ_ ‚G‚PƒP ~‚C^ „C„kM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [424]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d3ƒa¡¡ˆE‚K ~‚G‡b ‡LŠw";
 DrawStrBoxCenter("d3ƒa¡¡ˆE‚K ~‚G‡b ‡LŠw");
 LoadPic(19,1);
 DrawMulitStrBox("¡¡‚G‚P^ …g‚^ „p ‚TS ‡F‚Yo ‚C Œv…X „C‚C ‚kn ‚GƒG^ ‚~‚rPM. ‚GƒGƒP …G‚Mƒb ‰b ˆE‚K‚h Œfƒj ƒGoG MP‚MS ƒ]PM.*¡¡‡i…BŠW [‚b ˆE‚K …A†IS Z‚wPƒmƒv, ‚J‚Xƒb [ƒP ‚r…x ƒY†fS EƒDB ˆE‚K^ ‚GƒGfƒW ‚G‚PfQ t„T„C„kM‚b ‚rNS …HnƒRGQ PM.");
 --DrawMulitStrBox("¡¡ÕâÑùÏÂÈ¥¾£Öİ½«Åª²»µ½ÊÖÁË£®ÓÚÊÇÖÜè¤ÉèÏÂÃÀÈË¼Æ£¬ÒÔËïÈ¨µÄÃÃÃÃÓÕÆ­Áõ±¸À´Îâ¼Ù½á»é£¬¿Û×¡Áõ±¸£¬Ë÷Òª¾£Öİ£®¿ÉÊÇ£¬ÔÚ¿×Ã÷ºÍÕÔÔÆµÄ²ß¶¯ÏÂ£¬Õâ¸ö¼Æ²ßÒÔ´óÊ§°Ü¶ø¸æÖÕ£¬Áõ±¸È¢µ½ÁËËïÈ¨Ö®ÃÃÎªÆŞ£®*¡¡¿ÉÊÇ£¬ÎâºÍÖÜè¤¶Ô¾£ÖİµÄÒ°ĞÄ»¹Ã»ÓĞÆÆÃğ£®");
 DrawMulitStrBox("¡¡G‚_„S‚b ˆE‚K‚h ‡Yf †pS q ‚aMƒd „v ‚K‚G‚b †wj„T‚h ƒVdM. ‡Y‡bƒP †uG‚h †wŠY„S ‚G‚P‚h [„S …d…eƒRb †EŒQ ‚cjS ‚V‰m ‡D ŒE‹Qn ‚[ƒd ˆE‚K‚h Z‚waƒ` o ƒuGM. ƒ[…eƒv ‚J‚X{ v‡SƒP „T‚uf ‚@ƒ` G „TƒCƒb „^Q NOPƒd, ‚G‚P‚b ‡Y‡bƒP †uG‚h nƒ_„S ŠGƒtM.");
 DrawMulitStrBox("¡¡ƒ[…eƒv [‡z ‚K‚GƒP ˆE‚Kf ‚_o …E†dƒb n„L „_G‚C ‚kƒtM.");
 LoadPic(19,2);
 
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(54,11,16,0);
 AddPerson(175,9,15,0);
 AddPerson(367,15,12,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("‚IS ƒP‚r‰R");
talk(126,"‚K‚J, …Xƒl ŠU [ŠVKLM. ‚^a^ ƒsƒdX …IG „OM WLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚÒéÊÂÌüÉÌÌÖ½ñºó>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [425]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ƒY†fG ‡O ŠXM WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"[ƒv‚fD †~ ‰A‹TƒG‚TZ. n„L ‚cG f ‚q ‚Z†ohLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒ[…eQ ˆ|hLM. ‚K‚G‚b ˆE‚Kf †M†MŠW eƒj ‡KWLM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"ˆE‚K‚b ˆmG ƒGŠK‚Cƒd †eƒ{G ‡AƒmL [^ ~ƒ_‚b ƒuD ‡i…Ba‚CZ.");
 end
 if JY.Tid==367 then--ÎÄ¹Ù
talk(367,"[fƒW ƒY†fG ŠXKLM. ‚SŠSXYZ?");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ƒY†fG ŠXM WLM.",
 1,"‡O ˆE‚K …IG†y‚C. G‚W‰` I‡H ƒ]ƒm„S ŠXSY?",
 126,"dQ „ND^ „OKLM. ƒY†fG ˆE‚K G…EƒG‚h ŒMƒ_†Eˆe ‚K‚JŠ_ƒW‚b ƒO‡I‚V[.",
 1,"…[‚fƒd? …[ƒG„V aA „C†ym?",
 126,"…Zd‚aKLM. ‚K‚JŠ_ƒW ‡d‚V ƒO‚VM^ qKG ‚Sƒ`„E‹T f‚Mf d^ Šoƒb „T‚uS ƒ_†yKLM.");
 NextEvent();
 end
 end,
 [426]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚T‚rŠ_ I‡H Šoƒb „T‚uG „Oƒm‡ILY?");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"[^ ˆE‚K‚h …Vƒmƒ`‚b …X‚MS cQ a‚b ƒuhLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒY†fS ƒR‚f a‚f.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"ˆE‚K‚b ˆmG ƒGŠK‚Cƒd †eƒ{G ‡AƒmL [^ ~ƒ_‚b ƒuD ‡i…Ba‚CZ.");
 end
 if JY.Tid==367 then--ÎÄ¹Ù
talk(1,"ƒY†fS ƒRG‡I‚V[.",
 367,"k.");
 MovePerson(367,10,2);
 DecPerson(367);
 AddPerson(144,-5,2,3);
 MovePerson(144,10,3);
talk(144,"‚G‚PŠi, [ˆs„VhLM.");
 NextEvent();
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚JŠ_ƒW‚b ƒO‚VƒG„V aA ŒjLM. ƒ[†{ ƒY†fS ƒRG‚V‚CZ.");
 end
 end,
 [427]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ƒY†f{ ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ƒY†fG ƒGM„tLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ƒY†f{ ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‚K‚J, ƒY†f{ ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==144 then--Â³Ëà
talk(1,"G‚W‰` ‚Sj …I„S [ŠVm?",
 144,"[, G‚W‰` ƒOu ‚K‚J ‡Y‡bƒP ‡L‚^„S [„S‚C ˆE‚K …I „U…Zf ŠXm. ˆE‚K‚h Œfƒ`ƒe ‚C G‰S…l [†G„C„kƒmL Gd ‰Bƒ`‚KŒs…E‚CZ.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒY†f{ G…EƒG‚h ƒv†u‚V‚CZ.");
 end
 end,
 [428]=function()
 local menu={
 {"¡¡ I‚VoM",nil,1},
 {" ‚Z‡M „foM",nil,1},
 {"¡¡¡¡‡SM",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"¡­¡­",
 144,"‚G‚PŠi, Gd ‡zƒW ƒlgBD m„o‚aKLM.");
 elseif r==2 then
talk(1,"I‡H ˆ|Š[G‚V[?",
 144,"Gd ‡zƒW ƒlgBD m„o‚aKLM. ‚G‚PŠi, †CB ‚K‡I‚V[.");
 elseif r==3 then
talk(1,"ˆUˆUˆU¡­¡­",
 144,"‚G‚PŠi, ‚SŠS ƒ[…e‡ILY?");
 NextEvent();
 end
 end,
 [429]=function()
 local menu={
 {"¡¡ I‚VoM",nil,1},
 {" ‚Z‡M „foM",nil,1},
 {"¡¡¡¡‡SM",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"¡­¡­",
 144,"‚G‚PŠi, Gd ‡zƒW ƒlgBD m„o‚aKLM.");
 NextEvent(428);
 elseif r==2 then
talk(1,"I‡H ˆ|Š[G‚V[?",
 144,"Gd ‡zƒW ƒlgBD m„o‚aKLM. ‚G‚PŠi, †CB ‚K‡I‚V[.");
 NextEvent(428);
 elseif r==3 then
talk(1,"ˆUˆUˆU¡­¡­",
 144,"‚G, ‚G‚PŠi? ƒO‚V‚b OLY? ‚G‚PŠi?");
 NextEvent();
 end
 end,
 [430]=function()
 local menu={
 {"¡¡ I‚VoM",nil,1},
 {" ‚Z‡M „foM",nil,1},
 {"¡¡¡¡‡SM",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"¡­¡­",
 144,"¡­¡­? yLY, ƒO‚b „fhLY? †EŒQˆ|ŠwG‚V‚TZ.");
 NextEvent(428);
 elseif r==2 then
talk(1,"‚M¡­¡­ [ƒX hƒb ƒJƒK‚wƒ`.",
 144,"‚G‚PŠi, g‚CaQ ‚_B ‚K‡I‚V[.");
 NextEvent(428);
 elseif r==3 then
talk(1,"ˆUˆUˆU¡­¡­",
 144,"a‚b q ‚a‚T. G‚h ‚SŠSoM?");
 NextEvent();
 end
 end,
 [431]=function()
 local menu={
 {"¡¡ I‚VoM",nil,1},
 {" ‚Z‡M „foM",nil,1},
 {"¡¡¡¡‡SM",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"¡­¡­",
 144,"¡­¡­? yLY, ƒO‚b „fhLY? †EŒQˆ|ŠwG‚V‚TZ.");
 NextEvent(428);
 elseif r==2 then
talk(1,"‚M¡­¡­. [ƒX hƒb ƒJƒK‚wƒ`.",
 144,"‚G‚PŠi, g‚CaQ ‚_B ‚K‡I‚V[.");
 NextEvent(428);
 elseif r==3 then
talk(1,"ˆUˆUˆU¡­¡­",
 144,"‚G‚PŠi, ‚SŠS ƒ[…e‡ILY? ‚SŠSab ƒO‡ILY?",
 126,"‚K‚JŠ_ƒW ƒO‚V‚b YVƒb d^ E‚X…wu†yKLM.");
 MovePerson(126,1,2);
 MovePerson(126,1,0);
 MovePerson(126,1,2);
talk(144,"‚SŠSab ƒO‚V‚b ƒuG[?",
 126,"‚K‚JŠ_ƒW‚b …S‚K‚h …V‚b ‚_„S ˆE‚K‚h ‰Bƒ`…w„u `‚EGŠVKLM. ‡mƒv …S‚KƒP ‚Gƒaƒb ‚K‚J{ „Gƒb TˆjhLM. TˆjS „Q‚b …IG ‚K‚JŠ_‚b ‡w„SƒOƒN‚C‚f ƒ[u ƒOƒN ƒuhLM.");
talk(1,"ˆUˆUˆU¡­¡­",
 144,"¡­¡­ƒ[ŠQƒGD a†y‚TZ. ‚G‚PŠiƒP †dFƒb ŠU „a†yKLM. ƒ[ŠQMA G‹@ ‚oƒb ‚S‹cKLY?",
 126,"I‡H ‚oG[?",
 144,"‚G‚PŠiŠ_ƒW ‚GƒaS „QƒG ‰W‚da‚VMA …fŠs^ ‚_ƒN …S‚K‚h la†yKLM. M„V¡­¡­",
 126,"I‡JG[?",
 144,"…S‚K‚h „Qƒ`A ‚ISS ‚Cƒv…E WLM. ab ƒOu [‚TG ‚ISS ‚Cƒv‚b ƒuS ‡mˆyB ‚K‚VƒG ƒUŒeLM.",
 126,"„a†ym. ƒOu‚h ‚_ƒNB …S‚K‚h ŠP ƒeMA ‚ISS ‚Cƒv‚b ƒuGG…E ‡i…BŠW ‡mˆya†ym. ˆAdˆe †I~G[.",
 144,"‡N‚rWLM. ‰Bn^ ‚K‚J{ CƒPa†yKLM. ‚G‚PŠi, G„V ƒA…e^†yKLM.");
 MovePerson(144,10,2);
 DecPerson(144);
 MovePerson(126,0,3);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [432]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚T‚r‚b ‚SŠS ƒs‚V[?");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…f‚b ‡G‚W †XƒgWLM. ‚T‚rŠ_ƒW‚b ‚SŠS …gƒP …{S ƒ[u iŒCƒm‡ILY?");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚T‚rŠ_ƒW‚b †~ƒm„S ƒNƒG‡^„[G‡ILM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"[‚TG ƒOu‚h ‚_ƒNB …S‚K‚h ˆjML, ˆ[‚SD „C†yKLY?");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(1,"‚T‚r, G …IS ‚SŠS ƒs‚V[?",
 126,"G‚b ‚K‚GƒP „T‚uhLM.",
 1,"‚K‚GƒP „T‚uG‚f?",
 126,"ƒ[ŠQKLM. ‚K‚G‚b ‚IS „w{ ‡mˆyS …Hƒb ‡D †rS Œfu‚b „fa†B †M…~f ‚ISS Šf„hƒmƒ`‚b ƒuhLM. GƒuG ^D†UiƒP „T‚uhLM.",
 1,"ƒ[ŠQMA ‚SŠSB…E a[?",
 126,"‚K‚G‚h ‚aL Šoƒb ƒG‚}hLM. ƒ[…e‚C ‚kƒmA ƒOu^ …S‚K‚h †R „U ‚K‚G‚b ‚n…Uo jƒAG ŒjLM. ‚K‚J, …bFS ƒe‚Pa‡I‚V[. ƒY†fƒP ƒsƒd‚h …HƒmA ‚K‚G‚b ‰b ˆl„L…I ƒuhLM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [433]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="[";
 JY.Base["D‚wC"]=0;
 AddPerson(142,28,7,1);
 AddPerson(143,29,10,1);
 AddPerson(148,14,9,3);
 AddPerson(149,10,11,3);
 AddPerson(163,6,13,3);
 AddPerson(14,25,15,2);
 AddPerson(145,21,17,2);
 AddPerson(185,17,19,2);
 AddPerson(144,-4,24,0);
 SetSceneID(92,11);
 DrawStrBoxCenter("[ †X‚B");
 MovePerson(144,11,0);
talk(144,"G ƒY†f, ‰BnŠXKLM.",
 142,"‚M, †@{‚b ‚SŠS „C„km?",
 144,"‚G‚P‚b …S‚K‚h …VƒG ‚Bf‚b ˆE‚K‚h ‰Bƒ`‚K‚C ‚k†yM PKLM.",
 142,"I‡JG! ‚G‚P G…x^. ‚GƒG‚b G†w …G„k†EƒX ‚SŠS ‡C…{S ‚C‰J‚C ‚k‚b†M ˆ|GŠm?",
 144,"ƒYa‚V‚b ƒuD ‡i…BWLM. ab d^ ‚G‚PfQ, ‚K‚G D„`G ‚ISS ‚Cƒv ‚_ƒN …S‚K‚h lB ‚K†yMƒd PKLM.",
 143,"‚M, ƒ[†GƒW ‚J‚Xƒb I‚S‚f Pm?",
 144,"‚J‚Xƒb ‚ISS ‚Cƒv‚b ƒuGƒb ‡i…BŠW ‡mˆyoM PKLM.",
 143,"I‡JG! ‚J‚XG ƒ[u ˆ|PMƒd!")
 MovePerson(143,1,1);
 MovePerson(143,1,2);
 MovePerson(143,2,1);
talk(143,"ƒY†f, ‚J‚XG Fˆ|„S ƒOu^ ‚ISS ‚Cƒv‚b ƒuS ‡mˆyPm?",
 144,"k, ‡L‚X ƒ[u ˆ|PKLM.",
 143,"ŠU‹k‚wƒv. G‚W‰` ‚J‚XS …{ŠbDM.",
 142,"‚SŠS ˆY …IG[? ƒv‚b DI‚C ‚Z‚j†y‚wƒ`.")
 MovePerson(143,1,3);
 MovePerson(143,4,0);
 MovePerson(143,0,2);
talk(143,"[, ‚K‚JŠ_ n„L ˆ|Š[…wu‚C ‚kƒt‚TZ. Nƒb G…eWLM, ¡­¡­");
 DrawMulitStrBox("¡¡‚K‚GƒP ^D†Ui‚C„T‚b G†w d‡y„XfQ …y†V„C„kM. ‚K‚G‚b ‚ISS ‚Cƒv …S‚K‚h loM‚b ‚wN„S ‚G‚P^ „N‚Pa‚C ‚kƒb ŒoS …@ †M…~f ‚ISS ‰Hˆyaƒ` o ƒuGM.");
talk(142,"{…B ƒ[ŠQ‚wƒv. ‚G‚P‡z d‡y„XG „T‚vf ‚@ƒ`ƒR„kƒmL †J‚V ‚K‚G‚b ‚C‚vG ˆc‚SƒvDM.",
 143,"ƒ[†{ ‚J‚XG „I„Q…^ƒG ‚Bf ‚SƒW ˆl„LG‚V‚CZ.",
 142,"ƒ[†{ ƒ[‚_„V ˆ[†ym, ‚K‚G.",
 143,"k.");
 
 JY.Smap={};
 SetSceneID(0);
talk(143,"ƒWŠe…e‚f! ‚J‚XfQ `‚EX ŒoS ‚K‚C …X‚f!");
 NextEvent();
 end,
 [434]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(170,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(127,9,15,0);
 SetSceneID(54,12);
 DrawStrBoxCenter("‚IS ƒP‚r‰R");
 DrawMulitStrBox("¡¡ƒ[…eƒv d‡y„Xƒb G†w ‚K‚GƒP „T‚vS …y†Vaƒd ƒe‚Pf ƒR‚S^ „O„kM.");
 MovePerson(126,0,3);
talk(126,"‚K‚J, ƒe‚P‚h …X‡RKLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [435]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"Fˆ| ‚K‚G‡z †@‚BS ‰rG‚b ƒuhLY? …A…w‚V G„}…E‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"[‚T{ ‰jƒO‚b ƒuD aƒvƒP ˆB†EˆlG‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ˆE‚K‚h ‚K‚GfQ „|†r q‚b ‚aKLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"ƒv‚b ƒvG^ ƒR„kƒmƒv †@ŠH ŠLƒbGƒRfQ ‚C‚C ‚km.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"G‚W ‰jˆlf‚b ‚^ƒZ …fD …hƒ`^ ‚K‡I‚V[.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ‚K‚G‚b G†w …bFPS ƒuhLM. †wcS ‚r…x„S ƒs„jƒmL ‚K‚JŠ_ƒWD ƒe‚Pa‚V‚CZ.");
 AddPerson(65,-5,2,3);
 MovePerson(65,10,3);
talk(65,"‚K‚J, ‚K‚G^ G†w ‚J‚of G‚j…e …X‚eS Z‚waƒd „OKLM.",
 3,"a‚b q ‚a‚wƒv. ŠGƒm…e ^…x.",
 126,"ŠoKLM. …bFS ƒe‚Pa‡I‚V[.");
 NextEvent();
 end
 end,
 [436]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"Fˆ| ‚K‚G‡z †@‚BS ‰rG‚b ƒuhLY? …A…w‚V G„}…E‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"[‚T{ ‰jƒO‚b ƒuD aƒvƒP ˆB†EˆlG‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ˆE‚K‚h ‚K‚GfQ „|†r q‚b ‚aKLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"ƒv‚b ƒvG^ ƒR„kƒmƒv †@ŠH ŠLƒbGƒRfQ ‚C‚C ‚km.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"G‚W ‰jˆlf‚b ‚^ƒZ …fD …hƒ`^ ‚K‡I‚V[.");
 end
 if JY.Tid==65 then--ÃÓóÃ
talk(65,"‚K‚J, ‚K‚G^ G†w ‚J‚of G‚j…e …X‚eS Z‚waƒd „OKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"…bFa‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(28,"d3ƒa ‚J‚o ‚B„e","1. ‚K‚G ‚p…D*2. ƒ{…^ „p ‡E ‡F‚Y",40,0,142);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,10,21,4,0,-1,0,
 125,12,20,4,0,-1,0,
 -1,12,21,4,0,-1,0,
 -1,11,19,4,0,-1,0,
 -1,11,22,4,0,-1,0,
 -1,10,18,4,0,-1,0,
 -1,10,20,4,0,-1,0,
 -1,9,19,4,0,-1,0,
 -1,9,21,4,0,-1,0,
 -1,8,20,4,0,-1,0,
 -1,10,23,4,0,-1,0,
 -1,8,22,4,0,-1,0,
 });
 DrawSMap();
talk(126,"‚K‚J, ƒ[†{ ‚J‚oƒm„S ^ ‚K‚G‚h ŠGƒm‚V‚CZ.");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 142,36,10,3,2,44,16,0,0,-1,0,
 161,24,12,3,2,38,3,0,0,-1,0,
 165,26,14,3,2,39,3,0,0,-1,0,
 164,34,12,3,2,38,3,0,0,-1,0,
 147,32,13,3,2,40,14,0,0,-1,0,
 162,30,11,3,2,40,9,0,0,-1,0,
 148,25,13,3,2,41,20,0,0,-1,0,
 173,26,12,3,2,40,25,0,0,-1,0,
 292,28,11,3,2,34,9,0,0,-1,0,
 293,28,12,3,2,35,9,0,0,-1,0,
 294,33,12,3,2,35,9,0,0,-1,0,
 274,31,12,3,2,34,6,0,0,-1,0,
 
 275,25,11,3,2,33,6,0,0,-1,0,
 276,27,13,3,2,33,6,0,0,-1,0,
 277,33,10,3,2,34,6,0,0,-1,0,
 297,35,11,3,2,35,9,0,0,-1,0,
 332,32,11,3,2,33,14,0,0,-1,0,
 184,38,11,3,1,40,6,0,0,-1,1,
 166,37,11,3,1,40,9,0,0,-1,1,
 150,38,12,3,1,41,16,0,0,-1,1,
 295,37,9,3,1,36,9,0,0,-1,1,
 296,37,13,3,1,36,9,0,0,-1,1,
 278,36,12,3,1,34,21,0,0,-1,1,
 336,35,9,3,1,34,15,0,0,-1,1,
 340,39,11,3,1,36,17,0,0,-1,1,
 341,38,10,3,1,36,17,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [437]=function()
 PlayBGM(11);
talk(143,"…M. ƒsn‚f, ‚G‚P …f ‚Su„Zƒb …x^ …X‚eS ƒvŠXM. ‚SŠq‚ru ‚J‚XS …{Šb†sL‚f. ‚G‚P^ ^YG [ƒG ‚Bf‚b ‰H‚^„S ˆl„LG‚C …X‚f. ‡mƒv ^YG [†Eˆe ‡T‚J‚pa‚f. „a†y†sŠm?",
 126,"‚K‚J, ‚K‚G‚b FAƒm„S „Q‚C ‚kS ƒuhLM. G Œof ‚r„NƒP ƒ{…^‚h ‡F‚Ya‚V‚CZ. …Xƒl ‹If |‚OG „OƒmL ƒ[ƒuS ^‚O‡f |n v„oŠW ƒ{…^„S ‹ZƒG‡I‚V[.",
 1,"ƒ[ua‚b ƒuD Šom„V, ‚SŠSab ƒ[…ea[?",
 126,"‚K‚G‚b d „T‚vG „wPM b„} ƒOu^ „N‚Pa‚C ‚k‚b „{ …FLM. ƒ[ „T‚vG G†w …y†V„C„k‚MS „aQ „CA …H‚b ‡t‚p„Vƒm„SD ‰j…[ ƒ]S ŒOS ƒuhLM.",
 1,"„a†ym. ‚r„NƒP ƒ{…^‚h ‡F‚Ya†ym.",
 126,"ƒ[ŠQKLM. M„V ƒOu ‚TƒP ˆl„LRG ƒR‰aƒW‚b ‚o ŒjLM. [‚TfQ _‚E„CA G ‚]‚lƒb IƒP†wB†LLM. ab |‚O ‰Kƒb ‡EY‚C„V ^ƒd „l ƒvn^‚C …X‡I‚V[.");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [438]=function()
 WarLocationItem(7,21,3,200); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¹Ä´µ¾ß
 WarLocationItem(1,14,115,201); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºº£Ğ¥Êé ¸ÄÎª 115¶À½ÅĞı·çÅÚ
 if WarMeet(2,149) then
 WarAction(1,2,149);
talk(2,"ƒv‚b eƒO, …x‚b ‡SƒaGM! †u^ ƒv‚h C‚_a†y†sŠm?",
 149,"eƒO! G b‡~G ƒvŒUM!",
 2,"†iG dˆF „^‚wƒv! ‹FS …Hn‚f!");
 WarAction(6,2,149);
 if fight(2,149)==1 then
talk(2,"G…x‚b „V„V„Q ‚k‚wƒv¡­¡­",
 149,"¡­¡­M‚M‰` ‡NŠW ƒ[…e‚C ˆfau‚f¡­¡­",
 2,"G ‹FS …Hn‚f! ‹laL „O‚C …X‚f.");
 WarAction(4,2,149);
talk(149,"¡­¡­‡iB‰M q ‚a‚wƒv. {…B eƒOM. eƒO, t‚^‚b M‚Mf ^u…x.");
 WarAction(16,149);
talk(2,"…iŒoG †EƒP ‚a‚wƒv. G…x‚b „V„V„Q ‚kM. M‚Mf M‚V ƒs…x.");
 WarLvUp(GetWarID(2));
 else
 WarAction(4,149,2);
talk(2,"G…x‚b „V„V„Q ‚k‚wƒv¡­¡­ M‚Mf M‚V ƒs…x.");
 WarAction(16,2);
 WarLvUp(GetWarID(149));
 end
 end
 if not GetFlag(1045) then
 if WarCheckArea(-1,8,21,17,39) then
 PlayBGM(11);
talk(143,"…M! ‚G‚P‚TG ‚J‚pS ‚VJP†sŠm? ‚J‚X, ‹[ƒ_ …y†V‡iP‚wƒv. t‚^‚b ‚BƒafƒW ^u…x! ‚B‚T, ‚G‚P‚TS ŠP‚f!");
 WarShowArmy(184);
 WarShowArmy(166);
 WarShowArmy(150);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(278);
 WarShowArmy(336);
 WarShowArmy(340);
 WarShowArmy(341);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM!");
talk(185,"‚K‚G D„`, ‹z„kKLM.",
 143,"‡Y‚G^ n†m^? ƒv‚h DƒO…e ŠX‚b^? ƒdŠO„p.",
 185,"ƒQ‚TS Gˆnƒd ŠXKLM. ‰HŠ_ ‚G‚P‚h IH„]uƒd ˆE‚K‚h „C‹q‹Y‚VM!");
 DrawStrBoxCenter("‚K‚G‚TG ‚Jƒo„S ‚B†IPM!");
 PlayBGM(14);
 WarModifyAI(142,3,125);
 WarModifyAI(161,3,0);
 WarModifyAI(165,3,0);
 WarModifyAI(164,3,125);
 WarModifyAI(147,3,125);
 WarModifyAI(162,3,125);
 WarModifyAI(148,1);
 WarModifyAI(173,1);
 WarModifyAI(292,3,0);
 WarModifyAI(293,1);
 WarModifyAI(294,3,125);
 WarModifyAI(297,1);
 WarModifyAI(274,3,125);
 WarModifyAI(275,3,0);
 WarModifyAI(276,1);
 WarModifyAI(277,3,125);
 WarModifyAI(332,1);
 War.WarTarget="1. ‚K‚G ‚p…D";
 WarShowTarget(false);
 SetFlag(1045,1);
 end
 if (not GetFlag(1046)) and War.Turn==3 then
talk(126,"‚K‚J, ‡Y‚G‚h ‚_ƒaƒm„S o ƒLƒP ƒQ‚TG Gu„S [ƒd „OM WLM. ƒ[ ƒQ‚TG ‹fƒmA ‚K‚G^ ‚J‚pf ƒv†bLM. ˆEƒo^ ƒOufQ …duaL ‚SƒW ƒ{…^‚h ‡F‚Ya‡I‚V[!");
 SetFlag(1046,1);
 end
 if (not GetFlag(1047)) and War.Turn==8 then
talk(126,"ƒLƒP ˆl„LRG C‡iŠW ƒE‹{LM. ‡Y‚G^ ‰b ‹fS ƒhGL ƒWŠe…e ˆl„LG‡I‚V[!");
 SetFlag(1047,1);
 end
 if (not GetFlag(1048)) and War.Turn==12 then
talk(126,"‡Y‚G^ ‰b ‹fKLM. ‚K‚J, ƒWŠe…e ˆl„LG‡I‚V[!");
 SetFlag(1048,1);
 end
 if (not GetFlag(1049)) and War.Turn==15 then
 PlayBGM(11);
 WarShowArmy(184);
 WarShowArmy(166);
 WarShowArmy(150);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(278);
 WarShowArmy(336);
 WarShowArmy(340);
 WarShowArmy(341);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM!");
talk(185,"‚K‚G D„`, ‹z„kKLM.",
 143,"‡Y‚G^ n†m^? ƒv‚h DƒO…e ŠX‚b^? ƒdŠO„p.",
 185,"ƒQ‚TS Gˆnƒd ŠXKLM. ‰HŠ_ ‚G‚P‚h IH„]uƒd ˆE‚K‚h „C‹q‹Y‚VM!");
 DrawStrBoxCenter("‚K‚G‚TG ‚Jƒo„S ‚B†IPM!");
 PlayBGM(14);
 WarModifyAI(142,3,125);
 WarModifyAI(161,3,0);
 WarModifyAI(165,3,0);
 WarModifyAI(164,3,125);
 WarModifyAI(147,3,125);
 WarModifyAI(162,3,125);
 WarModifyAI(148,1);
 WarModifyAI(173,1);
 WarModifyAI(292,3,0);
 WarModifyAI(293,1);
 WarModifyAI(294,3,125);
 WarModifyAI(297,1);
 WarModifyAI(274,3,125);
 WarModifyAI(275,3,0);
 WarModifyAI(276,1);
 WarModifyAI(277,3,125);
 WarModifyAI(332,1);
 War.WarTarget="1. ‚K‚G ‚p…D";
 WarShowTarget(false);
 SetFlag(1045,1);
 SetFlag(1049,1);
 end
 if (not GetFlag(34)) and WarCheckLocation(-1,1,25) then
 DrawStrBoxCenter("‚G‚P‚TG ƒW‡k ƒ{…^‚h ‡F‚YPM!");
 SetFlag(34,1);
 end
 if (not GetFlag(35)) and WarCheckLocation(-1,2,37) then
 DrawStrBoxCenter("‚G‚P‚TG ‚l‡k ƒ{…^‚h ‡F‚YPM!");
 SetFlag(35,1);
 end
 if (not GetFlag(36)) and WarCheckLocation(-1,21,17) then
 DrawStrBoxCenter("‚G‚P‚TG ƒW…g ƒ{…^‚h ‡F‚YPM!");
 SetFlag(36,1);
 end
 if (not GetFlag(37)) and WarCheckLocation(-1,21,37) then
 DrawStrBoxCenter("‚G‚P‚TG ‚l…g ƒ{…^‚h ‡F‚YPM!");
 SetFlag(37,1);
 end
 if GetFlag(34) and GetFlag(35) and GetFlag(36) and GetFlag(37) then
 PlayBGM(12);
talk(126,"‚M, ‚Zˆe ƒ{…^‚h ‡F‚YPKLM. ƒ[†{ ‚E ƒ{…^ƒP IƒafQ ‚XB „^Q ‰Hƒ{S ‚C‚jQ a‡I‚V[.");
talk(143,"„i? G mu‚b I‡JGŠm?",
 148,"‚K‚G D„`, nI†GD †a‚nˆY ‡KWLM. ‚r„NfƒW ‰Hƒ{G ƒR„tLM. ‚SŠSXYZ?",
 143,"I‡JG?! ‡O ‚J‚XfQ ƒ_ „T‚vG …y†V‡iP†M ˆ|j^! ƒOj¡­¡­",
 148,"D„`, ‚SŠS ƒ[…e‡ILY? G‹@, ‰X^¡­¡­ *D„`, ‚C‚q‚W C‹n^ ‚p‡Lƒm„S ƒhƒFKLM.",
 143,"ƒ_„qƒ` ‚[‚f. Gk ƒuG¡­¡­",
 148,"D„`, ƒ[ ˆuƒm„S‚b „l ‚C‚gaN q ‚aKLM. ƒA…eƒv‚V‚CZ. ‚T…xƒP ‚Dq‚b ‡I ‰zD ‹z‚C ‚kKLM.",
 143,"‚M¡­¡­ ƒ[†{ ‡N‡}, …C…D‚b …x„pfQ ŠEƒG†y„p. ƒOj¡­¡­",
 148,"‚B‚T …C…D!");
 WarAction(16,143);
 DrawMulitStrBox("¡¡‚K‚G‚TG ƒA…eŠgM.");
 NextEvent();
 end
 end
 if JY.Status==GAME_WARWIN then
talk(143,"‚J‚X, ‚G‚P¡­¡­ „pŒNƒR¡­¡­ ƒOj¡­¡­",
 148,"D„`! ƒJƒKƒm‡ILY!",
 143,"‡LaDM¡­¡­ …C, …C…Da‚f¡­¡­",
 148,"k! ‚B‚T Œa‚V …C…Da‚f!");
 DrawMulitStrBox("¡¡‚K‚G‚TG ƒA…eŠgM.");
 NextEvent();
 end
 end,
 [439]=function()
 PlayBGM(7);
 GetMoney(1100);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£±£°£°S …V„kM!");
 if (not GetFlag(1045)) then
 WarGetExp();
 end
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [440]=function()
 SetSceneID(0,3);
talk(126,"Gd ‚K‚GD ‡NŠW D_a‚C ˆfX ƒuhLM. ƒ[†{ ‚ISƒm„S ‰Bn^‚V‚CZ.");
 NextEvent();
 end,
 [441]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(54,11,16,0);
 AddPerson(175,9,15,0);
 SetSceneID(54,5);
talk(126,"‚K‚J, ‚K‚G^ …G„kKLM. ƒ@a…w„tLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÌÖ½ñºó£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [442]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, G„S‰l ˆE‚K‚b †[‚BŠW ˆEŠiƒP ƒuG „C„kKLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"[D „WˆDS …V„kS ƒhGL ‡i‡L…yƒb ‡NŠW „Q‚C ˆfa†y‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ˆE‚K‚b Gd ‚o†dBD „C†yKLM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"ˆE‚K‚b Gd ‚o†dBD „C†yKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ‚K‚GfQ …X‚C‡f …I‚pS ^aƒd…x ƒWƒNS ƒs„jKLM. ‰b †@{^ ƒvƒi ƒuhLM¡­¡­ †u^ ŠX‚TZ.");
 AddPerson(367,-5,2,3);
 MovePerson(367,10,3);
talk(367,"‚K‚JŠ_ nŠnLM.");
 NextEvent();
 end
 end,
 [443]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒWƒNS ƒs„jMƒd‚b aƒv †@{^ ‚SŠS Š}‚C …xƒV …X‚Mf ‚@u‚b‚wƒ`.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚G‚b vj{ ‰j…[ „U ‚SZf @†jS ŠGƒtKLM. ƒ[ C‹n^ n„L nƒA‚C ‚kƒtM WLM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"ƒO…m ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==367 then--ÎÄ¹Ù
talk(367,"„Nƒg p…xƒP ƒsƒd^ ƒR‚SŠXKLM. ‚K‚G^ …G„kM WLM.");
 NextEvent();
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"†@{^ ‚S‹Xo‚C ƒR‚S ƒs‚V‚CZ.");
 end
 end,
 [444]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"‚K‚G‚b ‚IƒLG„kƒmƒv ‚~„Vƒb GƒG‚C ˆfP‚TZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚K‚G^ …G„kMƒd? ƒ[ŠQMA [ƒv‚fD ‡i‡L…yƒb ŠPƒR‚S[‚C ‚k†y‚wƒv.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚G‚b vj{ ‰j…[ „U ‚SZf @†jS ŠGƒtKLM. ƒ[ C‹n^ n„L nƒA‚C ‚kƒtM WLM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"ƒLƒm„SƒW‚b ‚[ƒ`‡S C‚_Šbm. [‡zƒP e„T‚b ‹Iƒm„S ‚SŠS Š}Y.");
 end
 if JY.Tid==367 then--ÎÄ¹Ù
talk(367,"‚K‚G‚b ‰X‚h ‡AG Uƒ` …G„kM WLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 MovePerson(126,0,3);
talk(126,"kCPŠB …IhLM. ‚K‚J, …f‚b [„S ^ ‚K‚G‚h v…Zaƒd…x WLM.",
 1,"n, ‡mƒv ‚J‚X. ƒ[ ƒWƒN „U…Zf ‚K‚G^ …Gƒb ƒuG[. ƒ[ †rƒb HI ‚n…Ua[. [ƒP IƒaƒRG ‚Z‚[ ƒ[‚_‚h ƒQq„S b†r ƒuG[.",
 126,"I‚rX ƒuhLM. ‚K‚G^ †jn „OS „UD ‚[Šq‚C ‚kƒt†EƒX aƒA†B …Gƒb ‚CƒgG†yKLY. v‡S„V ‰HŠ_ ^A ŒjLM.",
 1,"‡mƒv¡­¡­",
 126,"G …Iƒb …A…w‚V B…E WLM. n„Lƒb [‡z Ml „U^ n‚`LM. ‚K‚G‚b ƒOufQ …vƒP‚h ƒB„kƒmƒv ƒ[ …CRƒb ƒY†f…I ƒuG†B ƒ[‚b …vƒP^ ‚aKLM. G ‡FS G„oB [‡zƒP e„T‚h ‚G‚CB…E aL [„S ^…E WLM.",
 1,"ƒ[ƒuG¡­¡­",
 126,"‡Oo G ƒG‚}f [fƒW js‚h ‹qnƒsƒd…x WLM.",
 1,"js‚h ‹q‚bMƒd?",
 126,"ƒ[ŠQKLM. ‚Cƒg ƒoCfD ‡L‚X js^ „OKLM. ‹qnƒsƒd…x WLM.",
 1,"¡­¡­„a†ym. ƒ[†{ ‚J‚X, ‚^ƒZ ˆuv†da‚V[.",
 126,"k. ‚K‚JŠ_ƒWD d^ ‰Bnƒi „UY‚C js‚h ‹qnƒs‡I‚V[. v‡S, †h‚VM.",
 54,"k.");
 MovePerson(126,2,2);
 MovePerson( 126,3,2,
 54,3,2);
 MovePerson( 126,2,2,
 54,2,0);
 MovePerson( 126,7,2,
 54,7,2);
 DecPerson(126);
 DecPerson(54);
 MovePerson(367,10,2);
 DecPerson(367);
talk(2,"ˆEŠi, ƒ[†{ ‚T‚rƒP ˆ|‚_„S …fD js‚h ‹qnƒs†yKLM.",
 175,"…fD ^†yKLM.",
 1,"ƒ[†{ qƒdƒR B ‚KQ.");
 MovePerson( 2,3,2,
 175,2,2);
 MovePerson( 2,2,1,
 175,2,0);
 MovePerson( 2,8,2,
 175,8,2);
 DecPerson(2);
 DecPerson(175);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚ¾£ÖİÑ°ÕÒÈË²Å>
 NextEvent();
 end
 end,
 [445]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"js‚h ‹qƒm‚V‚CZ. ‡q…h ƒnˆEŠi, js^ ‚SƒZ „OKLY? ‰cJ ^‚b …h^ „OKLY?",
 1,"js‚h ‹qƒm…e ^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==1 then--Áõ±¸
talk(1,"js‚h ‹qƒm…e ^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [446]=function()
 local t=0;
 t=JY.Base["ÊÂ¼ş149"];
 JY.Smap={};
 SetSceneID(0);
 if t<4 then
talk(1,"‚SƒZ„S js‚h ‹qƒm…e ‡yY?");
 local menu={
 {" ‚ISS ‹q‚bM",nil,1},
 {" †o†oS ‹q‚bM",nil,1},
 {" ‚Ia‚h ‹q‚bM",nil,1},
 {" ƒa‚r‚h ‹q‚bM",nil,1},
 {" ƒP‚r‰Rƒm„S ‰Bn…yM",nil,1},
 }
 local r=ShowMenu(menu,5,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==5 then
talk(1,"‚V…yG ‹z„kƒmL ƒP‚r‰Rƒm„S ‰Bn^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(449);
 else
 SetFlag(149,t+1);
 local T1={"‚IS","†o†o","‚Ia","ƒa‚r"};
 local T2={15,18,16,17};
 local T3={377,380,402,400};
 local pid=0;
 local rnd=math.random(10);
 if rnd==10 then
 pid=T3[r];
 elseif rnd==3 or rnd==7 then
 pid=378;
 elseif rnd==1 or rnd==5 then
 pid=379;
 elseif rnd==2 then
 pid=399;
 elseif rnd==6 then
 pid=401;
 end
 SetFlag(150,pid);
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]=T1[r];
 JY.Base["D‚wC"]=T2[r];
 AddPerson(1,25,9,1);
 if pid>0 then
 AddPerson(pid,9,17,0);
 end
 SetSceneID(71,5);
 DrawStrBoxCenter(T1[r]);
 JY.Status=GAME_SMAP_MANUAL;
 if pid==0 then
talk(1,"js^ Š} „Vo ‚r†vƒb ‚a‚b ‡Ka‚wƒv.");
 end
 NextEvent();
 end
 else
talk(1,"‚V…yG ‹z„kƒmL ƒP‚r‰Rƒm„S ‰Bn^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(449);
 end
 end,
 [447]=function()
 local pid=JY.Base["ÊÂ¼ş150"];
 if pid>0 and JY.Tid==pid then--pid
 MovePerson(1,7,1);
 if JY.Person[pid]["¾ıÖ÷"]==1 then
talk(pid,"‹Iƒm„S ŠU ‚^…a…w„tLM. †B†R ‡D ‚ISƒm„S ^†yKLM.");
 else
talk(1,"†O‰HS bŒq‚SD „C†ym?",
 pid,"…f ˆ|hLY? …f‚b "..JY.Person[pid]["ĞÕÃû"].."(G)‚f WLM. ƒ[…e‚V‚b ‡Lƒb?",
 1,"ƒv‚b ‚G‚P‚f a[.",
 pid,"[, ‡iƒNG ƒU„S ‚G‚PŠiG‚V‚TZ. ƒ[‹@ „{D ‚Z‚jƒd N‹~PKLM. …f, ‚G‚PŠi. ƒk†v„C‚C„V o ˆ|Š[ bv†yKLM. d^ ‚^a^ Š} q „O†yKLY? …fD Œv…X…y „P‚Z‚b „OKLM.");
 end
 NextEvent();
 end
 if JY.Tid==1 then--Áõ±¸
 if talkYesNo( 1,"G‡E "..JY.Base["ÏÖÔÚµØ"].."S(‚h) ‹XƒSYZ?") then
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(446);
 end
 end
 end,
 [448]=function()
 local pid=JY.Base["ÊÂ¼ş150"];
 if pid>0 and JY.Tid==pid then--pid
 if JY.Person[pid]["¾ıÖ÷"]==1 then
talk(pid,"‹Iƒm„S ŠU ‚^…a…w„tLM. †B†R ‡D ‚ISƒm„S ^†yKLM.");
 else
talk(pid,"d^ ‡iƒNƒP ‚^a^ Š} q „O†yKLY?");
 if WarDrawStrBoxYesNo("Iƒa "..JY.Person[pid]["ĞÕÃû"].."S(‚h) ‚^a„S |SYZ?",M_White,true) then
talk(pid,"[, ƒ[ŠQMA ‡N‚rWLM. ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 ModifyForce(pid,1);
 PlayWavE(11);
 DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) ‚^a^ „C„kM!");
 else
talk(pid,"ƒ[ŠQKLY? ¡­¡­");
 end
 end
 end
 if JY.Tid==1 then--Áõ±¸
 if talkYesNo( 1,"G‡E "..JY.Base["ÏÖÔÚµØ"].."S(‚h) ‹XƒSYZ?") then
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(446);
 end
 end
 end,
 [449]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(1,25,17,2);
 AddPerson(3,22,10,1);
 AddPerson(64,11,16,0);
 SetSceneID(54,1);
talk(3,"ƒnˆEŠi, „N„wG‚f‚b …x^ ŠXKLM.");
 AddPerson(133,-5,2,3);
 MovePerson(133,10,3);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÈÃÅÓÍ³³ÉÎª²¿ÏÂ>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [450]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"G‹@, …RƒB‚a‚b …x„S‚T. ‚_…r I‡H …I„S ŠXSY?");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ƒO…m ‡YŠi{ ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‹n‚M ‹p†yKLM. …f‚b „N„wG‚f WLM.",
 1,"…I‚^…e ‚@‚MB ‚K‚VL ƒdŠOm. [ƒXƒb I‡H …IG‚V[?",
 133,"ŠZ…Iƒb n‚`LM. G‡Ef …xu‚h ‚wa…e ŠXKLM.",
 1,"(„N„wG‚fA qƒ@ …m`G ˆ|o ‚D‡l¡¤‡W…c ‚e ‡W…c…I ‹|…h¡­¡­)",
 1,"(`[†D‚b ƒGs„S ƒsG‚C ‚k‚b…h Fˆ| ƒ[ ‚r†vj^? ‚J‚X{ †T„{ „Vo ƒ@mdƒoƒP jƒAG‚d ˆ|j^?)");
 NextEvent();
 end
 end,
 [451]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ˆ| ŒEGƒGD Œkƒb …x„S‚TZ. …f…x^ Fˆ| ‚_†Mo jƒAhLY?");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"`‚EŠgm. ˆJ†or r‚Y …xu^ ‚P‚S „Om.");
 NextEvent();
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"…Xˆmo …xu^ ‚aMA G„V ƒA…e^†yKLM.",
 1,"‡d‚V ƒGMƒ` ‚K‚V[.");
 end
 end,
 [452]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ˆ| ŒEGƒGD Œkƒb …x„S‚TZ. …f…x^ Fˆ| ‚_†Mo jƒAhLY?");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"ˆJ†orƒb Jƒb ƒdSG‚f ‚KˆMG ‡A‚C ‚km.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(1,"ˆJ†orf r‚YG ‚P‚S „O‚b…h ƒ[‡Eƒm„S ^‚V†ym?",
 133,"n, ƒ[ŠQKLY? „a†yKLM. ƒ[†{ ‚^Ra…e ^†yKLM.");
 MovePerson(133,10,2);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [453]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(1,25,17,2);
 AddPerson(3,22,10,1);
 AddPerson(64,11,16,0);
 SetSceneID(54);
 DrawMulitStrBox("¡¡ƒ[ ‡D„S †B†RG UŠjM¡­¡­");
 AddPerson(367,-5,2,3);
 MovePerson(367,10,3);
talk(367,"‚K‚JŠ_ nŠnLM. †eƒ{ƒRG ˆJ†or r‚YG …IS a‚C ‚k‚bMƒd „aƒ` ŠXKLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [454]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, …f…x‚b †J‚V „P‚Z‚a‚b …m‚PŠbKLM. d^ ^ƒW ‚cJS ƒ_†yKLM.",
 1,"G[, ƒ{†w^ HI †Pa‚wƒv. ƒv‡z ‰HŠ_ ^…x.",
 3,"ƒ[†{ ‰q…f ˆJ†orƒm„S ^ ƒs†yKLM.");
 MovePerson(3,3,2);
 MovePerson(3,2,1);
 MovePerson(3,8,2);
talk(64,"ƒ[†{ †jaƒs…e ^‚V‚CZ.");
 JY.Smap={};
 SetSceneID(0);
talk(64,"ˆJ†orƒb bƒGƒW ‚l‡k‹Jf „OKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥ñçÑôÏØÊÓ²ìÇé¿ö>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, G …Iƒb o‚W v‚rB ƒs‚V‚b „KG Šo†yKLM.");
 end
 if JY.Tid==367 then--ÎÄ¹Ù
talk(367,"‚K‚JŠ_ nŠnLM. †eƒ{ƒRG ˆJ†or r‚YG …IS a‚C ‚k‚bMƒd „aƒ` ŠXKLM.");
 end
 end,
 [455]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ˆJ†or";
 JY.Base["D‚wC"]=0;
 AddPerson(3,25,7,1);
 AddPerson(64,29,9,1);
 AddPerson(1,25,9,1);
 AddPerson(363,19,11,0);
 SetSceneID(71,1);
 DrawStrBoxCenter("ˆJ†or");
talk(363,"‚G‚PŠi, ˆJ†orf [ƒN ƒuS †I~WLM. ƒa‚PŠiƒP ‡L‚^‚h …Hƒd bƒGƒW ƒGM„~KLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [456]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"eƒQG „N„wƒP …IS dQ ˆ|aƒ` a‚C ‚kKLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‚K‚J, ƒO…m „N„wS ‹qn ƒ[ƒP B‚XS ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==363 then--¹Ù²î
talk(1,"Gƒs‚V[, „N„wƒb ‚SƒZ „Om? †LIa‚b ‡Ef „Om?",
 363,"ƒ[, ƒ[ƒuG¡­¡­",
 1,"ƒ[, ƒ[ƒuG¡­¡­ I‡H ˆ|S aƒ`‚b QŠm?",
 363,"…f, „y…X ˆ|Š[…wuƒG ‚SŠqKLM„V. r‚YŠ_ƒW‚b ‚^R G†G ‚JI‚h aƒvD ‹nua‚C ‚kƒmŠVKLM.",
 3,"I‡JG‚f?!",
 363,"nGƒd! d ˆ~G n‚`LM. QM^ ‚rNG ƒ[…eaL¡­¡­.");
 AddPerson(133,-5,24,0);
talk(133,"bƒGƒW I‡H m‚dGŠm? I‡H …IGŠm?");
 MovePerson(133,13,0);
talk(3,"G…x ‹D ƒs‡I‚V[! ƒnˆEŠi, ‚SŠS ‹kˆe ‚cS ƒ_…E WLM.");
 NextEvent();
 end
 end,
 [457]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"G‡Ef †[ ‚C G‰S…l [†G„C„k‚b…h ‚JI‚h aƒvD ‹nua‚C ‚kƒtML. ƒa‚qG nL[.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"‡zƒW ƒsL eƒQƒP ˆ|G ‚rNG„k‚wƒ`.");
 end
 if JY.Tid==363 then--¹Ù²î
talk(363,"b, b‡pWLM! d^ a‚C ˆfPKLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚G‚PŠiG nL‡ILY? ‚Sj ƒU†vG …d‚S [ŠVKLY?",
 1,"ƒ[‚_^ ‚^Ro ‡D„S ‚JI‚h ‹nua‚C ‚kƒtM ab …I‚^…e †j‰X…e ŠXm.",
 133,"[, ƒ[ …I „U…ZGŠV‚TZ. ŠGKLM. G‡Ef †[ ‡D„S ‚JI‚h ‹nua‚C ‚kƒtKLM.");
 MovePerson(3,2,1);
talk(3,"I‡H muŠm! ƒnˆEŠiG ˆ[ƒd r‚YS ŠEƒGŠV†EƒX ‚SŠS Gu „LI‚h QSua†sŠm?",
 133,"„LI‚h QSuPMƒdZ? G‹@ ‚VŒAƒP ‚rIGƒb ‡iƒaG‚fD ‹nuX q „OKLM. ‚Cƒg ƒsb …wu‚CZ.");
 MovePerson(133,2,1);
talk(363,"r‚YŠi, ‡d‚V ƒGMu‡I‚V[.");
 MovePerson( 133,11,1,
 363,11,1);
 DecPerson(133);
 DecPerson(363);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<µ½ÒéÊÂÌü¿´ÉóÀíÇé¿ö>
 NextEvent();
 end
 end,
 [458]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ƒR‚S^ƒW …f…x^ ‚S†A jƒAj‚C ƒs‚V‚CZ.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"†@{‚h ƒsƒd ƒvƒW ‰rS FBD ‹z‚C ‚kKLM.");
 end
 if JY.Tid==1 then--Áõ±¸
talk(1,"ƒP‚r‰Rƒm„S ^ C‚US †ja‹b‚VM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [459]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ˆJ†or";
 JY.Base["D‚wC"]=0;
 AddPerson(133,25,17,2);
 AddPerson(363,12,16,0);
 AddPerson(355,19,12,3);
 AddPerson(357,15,14,3);
 
 AddPerson(3,31,12,1);
 AddPerson(64,33,13,1);
 AddPerson(1,30,14,1);
 SetSceneID(54,1);
 DrawStrBoxCenter("ˆJ†or ƒP‚r‰R");
 
talk(133,"†EƒG Cj, ƒ[‚_‚b G ˆN‚^‚h …{b †q†w‚h ƒo †c ‰]f ‰Oƒtm.",
 357,"ƒ[‹@ …I ‚aKLM. ŠUˆf ƒRƒmŠV†Eƒv †u‚T^ ‰um…ZS ˆZ ƒuhLM.");
 MovePerson(355,1,1);
talk(355,"I‡H muZ! ƒ[‚_ƒP G‰yG ƒ_Q „aƒ` ƒe ƒuG[. F ƒ[…eA ‰djS …hƒ`[†ym.");
 MovePerson(357,0,0);
talk(357,"I‡JG! J†L ‹Q‚C …X‚V[!",
 133,"F†fa‚f! ‚[ ‚r†v ‚Z‚[ v„oŠW a‚f!");
 MovePerson( 355,1,0);
 MovePerson( 355,0,3,
 357,0,3);
talk(133,"ˆN‚^‚b ‹Iƒm„S ƒv[‚f. „veG r†yM. G †q†w‚h ‰l ƒsƒt†sŠm?",
 355,"n‚`LM, n„L ˆ`‚C ‚kƒtKLM.",
 133,"ƒ[ŠQMA …y†MaM. n„L ˆ`‚C ‚kƒtƒmL G †q†w‚b ‰O‚C ‚kƒb ƒuƒm„S oM. ˆN‚^‚b †q†w‚h CjfQ ‰Bƒ`‚Kƒd, Cjƒb …Hƒb ‡]S ˆN‚^fQ ‰Bƒ`‚K‚f. ƒ[ƒuƒm„S ‹[GM.",
 357,"ƒ[, ƒ[ƒuƒb¡­¡­",
 133,"„l X ˆ|G „O†sŠm?",
 357,"‚a, ‚aKLM¡­¡­",
 133,"ƒ[†{ G wƒb bƒGƒW ‹[GM. ‚[ ‚r†vƒb ‚F†@f ‚i‚j‚f. ƒ[…e‚C ‚kƒmA ‰Wƒa †e ‚_M. ƒA…e^‚f.",
 355,"†~ƒm„S ‡N‚rWLM.",
 357,"¡­¡­");
 MovePerson( 355,12,2,
 357,12,2);
 DecPerson(355);
 DecPerson(357);
talk(3,"†~ƒm„S ‚ruf eƒb ‚F†@G‚TZ.",
 64,"QM^ G„QfD ŠGKLM. G…eA †u‚wD GƒP‚h ˆG‚C ˆfa‚CZ.");
 DrawMulitStrBox("¡¡GŠQQ s‚FG ‰{ˆGn G‚SƒFƒd,*¡¡…fn IŠqf‚b ƒ[‚l‚o ‹hƒ` „OŠB ‚Zˆe ‚rwG …XIu„C„kM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [460]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"G‰S…l ‚VƒQ‚VƒQo s‚Fƒb b‚| „v ƒLG ‚aKLM.");
 end
 if JY.Tid==64 then--ËïÇ¬
talk(64,"†~ƒm„S „DŒe‚wƒv. ‚r†vƒb o‚ZKƒm„S ‚F†MX ƒuG nL„SM.");
 end
 if JY.Tid==363 then--¹Ù²î
talk(363,"G‰S…l ‚GƒMo ‚r†vG „OƒmL OFX ƒuG ‚a†yKLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚G‚PŠi, ‚S‹cKLY?",
 1,"ƒ[‚_‚b †~ƒm„S ‚saf …w…Z ƒGsZ. †@‹~^ ‡Aƒtm. N‹~Pm.",
 133,"ƒJƒKKLM. [, bƒG ƒWƒNG aƒv „OKLM.",
 1,"¡­¡­£¿");
 DrawMulitStrBox("ƒWƒNf‚b GŠQQ ƒL‹u „O„kM.*¡º‚K‚J, „N„wƒb ƒn…IS G‹a ‚r†vG†B ƒ[ s‚K^ …fƒsM ‚A †c‚b ˆc‚S‹_LM. ‚K‚JŠ_ƒW o‚ZKƒm„S ‚r†vS ‚F†Ma‚VA ƒn rjS ŒOQ ŒjLM. ‚^ƒZ „N„wS ‚^a„S †E‚[‡I‚V[.*¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡d‡y„X¡»");
talk(1,"Gƒuƒb ‚J‚XƒP ƒWƒNG n†m^?",
 133,"ƒ[ŠQKLM. ‚J‚XG [f ŠXS „U ƒO…BŠW „VŠgKLM.*ƒ[„U G ƒWƒNS …A…w‚V ‚G‚PŠiŠ_ ‚Ba‚f a„l‚TZ.",
 1,"[BŠb‚wƒ`. ‡q…h ‚SŠS ‹n‚Mf ƒWƒNS ‚K‚C ‚kƒtm? ƒ[pMA¡­¡­");
 AddPerson(126,-3,3,3);
 MovePerson(126,10,3);
talk(126,"‚K‚J, ‚SŠS bƒG „T‡ILY? ‚S‚f, „N„wG n†m^? …x„p‚b ‡O ‚SŠS bƒGf „O‚b^?",
 133,"‚G‚PŠiŠ_ƒW ƒv‚h G‡E r‚Yƒm„S R‚XaŠV„p.",
 126,"G‡E r‚YG‚fƒd? …x„p^ r‚YG‚fA „D ‚V…yG „|ŠPŠg†y‚T. ‚K‚J, ‚SŠS „N„wfQ vƒ[…Xo r‚Y …xu„V ŠEƒGŠVKLY? ƒWƒNƒm„S ‡L‚XŠW ˆ|Š[…wu‚C ‚kƒtKLY?",
 1,"ƒ[ ƒWƒNS „Nƒg …Hƒtm. gJ …HƒtMA G‹@ …Iƒb ‚a„kS ƒuG[.",
 126,"„a†yKLM. M„V „N„wS r‚Yƒm„S ‚[‚b ƒuƒb jsƒP †k‚PhLM.",
 1,"ƒ[ŠQm. ƒ[†{ „N„w, [ƒX‚^ƒh ƒ[‚_‚b ƒvƒP ‚^‚T‚rZ.",
 133,"{‡Lo ˆ|Š[hLM. ƒ[†{ ‚ISƒm„S ‰Bn^‚V‚CZ.");
 ModifyForce(133,1);
 PlayWavE(11);
 DrawStrBoxCenter("„N„wG ‚^a^ „C„kM!");
 PlayBGM(8);
 DrawMulitStrBox("¡¡Guab ‚G‚P‚TƒP g„oƒb o‰F ‚IBƒFM. ‚C‚qƒS qƒ@ …m` ‚r…X‚g^ ‚G‚PfQ ˆ|PŠB ‚D‡l(d‡y„X){ ‡W…c*(„N„w)^ ‚Z‚[ ‚G‚PƒP ‚^a^ ˆY ƒuGM.*¡¡‚G‚P^ ƒn ƒ]S @†R „U^ …Xƒlƒ_ M^ŠXM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [461]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d3ƒa¡¡…S‚K ‚J‚v‚B";
 DrawStrBoxCenter("d3ƒa¡¡…S‚K ‚J‚v‚B");
 LoadPic(20,1);
 --DrawMulitStrBox("¡¡¾ÍÔÚÅÓÍ³³ÉÎªÁõ±¸²¿ÏÂµÄÊ±ºò£¬²Ü²ÙÎªÁËÀ©ÕÅÁìÍÁ£¬¾ö¶¨Õ¼ÁìÎ÷±±µÄ±»³ÆÎªÎ÷Á¹µÄµØ·½£®Îª´Ë£¬Ëû°µÉ±ÁËÍ³ÖÎÕâ¿éÁìÍÁµÄÂíÌÚ£®*¡¡¿ÉÊÇ£¬ÂíÌÚµÄ³¤×ÓÂí³¬Ê®·ÖÇ¿º·£®*¡¡Âí³¬ÎªÁËÌæ¸¸Ç×±¨³ğ£¬´ó¾Ù½ø¹¥²Ü²Ù£¬Á½ÈËÔÚÎ¼Ë®½øĞĞÁË¾öÕ½£®Æğ³õ£¬²Ü²Ù´¦ÓÚÁÓÊÆ£¬¿ÉÊÇºóÀ´ËûÀûÓÃ·´¼ä¼Æ£¬´ÓÄÚ²¿·ÖÁÑÁËÂí³¬¾ü£®*¡¡Âí³¬ÖÕÓÚ±»²Ü²Ù»÷°Ü£¬È«¾ü¸²Ã»£®");
 DrawMulitStrBox("¡¡„N„wG ‚G‚PƒP ‚^a^ Š} IŠq, vv‚b ~‰S‚h ˆ_ŠWƒd…x ƒW‡kƒP ƒW„XG‚f …du‚b ˆmS „y‚CaƒG„S PM. G‚h ‚nB ƒ[ ˆmS Mƒ~uŠB …X…}S ŠN†jPM.*¡¡ƒ[…eƒv …X…}ƒP ƒa…g …Xƒ|‚b ‡GƒO ‚I†_PM.*");
 DrawMulitStrBox("¡¡…Xƒ|‚b n‚PƒP ƒQq‚h ‹yƒd…x ‚_‚TS …Iƒm‰a vv‚h ‡Rƒd, ‚[ ‚r†vƒb ‚nqfƒW †@‚BS ‰rŠbM. ‹n‚M‰` vv^ ‚AƒoŠbƒmƒv G…C …A…y„T„S …Xƒ|‚TS ‚ofƒW ‡L‚A‚V…sM.*¡¡…Xƒ|‚b ‹[ƒ_ vvfQ OB ‚B‚TG IHƒFM.");
 DrawMulitStrBox("¡¡…Xƒ|‚b †@} o‚eƒm„S ˆGnŠgM.*¡¡G„S‰l vv‚b ‡k„NS „w…IPM.");
 LoadPic(20,2);
 LoadPic(21,1);
 DrawMulitStrBox("¡¡ƒW„XƒP †P‚tƒm„S ƒ[ …g‹J o‚eS Mƒ~uŠB ƒa„S‚b vvf ŠGƒWƒd…x d …g‹JƒP …S‚K‚h „y‚Caƒ` PM.*¡¡…S‚K‚b ˆE‚KƒP ƒW‹Jf „Oƒm†B, d‡y„Xƒb …I~G ‚G‚PfQ G ˆmS la‚f gˆAo ƒU „O„kM.");
 DrawMulitStrBox("¡¡o„K …S‚KƒP ‚Gƒaƒb o‚e ƒa„SƒP ‚J‚pS ‡fƒd…x ƒa‡pS ‚r…x„S ƒsƒ_ vvfQ ƒQv‚h ‰RPM. ƒ[…eƒv ƒa‡pƒb vvƒP ƒYbˆlS ‚r ‹K„}ƒvƒd ˆ|ƒtM.*¡¡Gf ƒa‡pƒb ‚G‚PƒP ˆE‚K„S ŠXM.");
 LoadPic(21,2);
 NextEvent();
 end,
 [462]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(126,19,17,2);
 AddPerson(133,25,14,2);
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(54,11,16,0);
 AddPerson(175,9,15,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("‚IS ƒP‚r‰R");
 MovePerson(126,0,3);
talk(126,"‚K‚J, …S‚KfƒW ƒa‡pG ŠXKLM.",
 1,"…S‚KfƒW ŠXMƒd?",
 126,"ƒ[ŠQKLM. ƒa‡p{ G…EƒG‚h ƒv†u‚V‚CZ.");
 MovePerson(126,0,2);
 AddPerson(187,-5,2,3);
 MovePerson(187,10,3);
talk(187,"G‡LG ƒU„S ‚G‚PŠiG‡ILY? …f‚b …S‚KfƒW †[ ƒa‡pG‚f WLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<»á¼ûÕÅËÉ>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [463]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, ƒa‡p{ ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‰q…f ‡YŠiS ŠGƒmŒs…E‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒO…m ƒa‡p{ ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==187 then--ÕÅËÉ
talk(1,"ŠU [ŠVm. ƒv‚b ‚G‚P‚f a[.",
 187,"‚G‚PŠi, [ƒXƒb xŠZŠW ‰RX …IG „O‚S ŠXKLM.",
 1,"ƒ_^ D…[ …IG „O†ym?",
 187,"…fŠs …S‚K‚b ‡{G‚fƒdD …d„tLM. ‚Cƒg …S‚K‚b ƒkƒLf ‚VˆGuƒd „O‚b…h, ƒU„S ‡k‹J o‚eƒP ƒa„ShLM. ƒ[…eƒv …fŠs ‚K‚J ‚GƒaŠ_‚b …S‚K‚h Mƒ~„u ƒMƒ}G ‚aKLM.",
 187,"…f‚b ‚r…x‚h Waƒd vvfQ ^ ƒQv‚h ‰Ra‚b „fa†B Nƒb ‡{S ƒ[fQ ƒU„Qƒ` PKLM. ‡mƒv ^ƒW ƒ[ „v‹TS ƒsƒd‚b ƒv‚f‚h „|†r ƒ]S ‰n„kKLM. vv^ …S‚K‚h Mƒ~ƒjMA †eƒ{ƒb ~~ „KX ƒSG ‚aS ƒuhLM.",
 1,"‚M¡­¡­",
 187,"‰Bn[‚b †rf …ZƒD ‚G‚PŠiG ‹Xƒi‚f GŠQQ ƒRŠjKLM. ‚G‚PŠi, …S‚K‚h ‡iƒNŠ_ ƒU„Qƒd…x aL ‚^ƒZ G ƒ]S …f„qu‚C ˆ|n ‚K‡I‚V[.",
 1,"‚S‡m¡­¡­ ‚SŠS †h…xƒG ƒ[‹@ ˆ|S a‚V[?",
 187,"ƒ[ŠQKLM. ƒ[ƒuG d^ †[ ƒ]hLM. ‰Bn^‚b ‚_„S o‚eƒP ƒa„S‚h C‚_X ‡Lƒm„S ‡iƒNS ‚s†Ea†yKLM. ƒ[…eL ˆum …S‚K„S [‚V‚S ƒ[ Œof G ƒv‚f‚h la‡I‚V[.",
 1,"‡mƒv¡­¡­ „Gƒb Tˆjj ‚GƒaƒP ƒG†nS Šf„h‚b …Iƒb¡­¡­.",
 187,"ƒ[‹@ ƒuƒb ŠInu‚C …X‡I‚V[. ƒn…IS Gƒ^‚b G‚b Jƒb …Y†Kf ‡GG‚C ‚kKLM. …f‚b ‰q…f ‰Bn^ ƒe‚Pa†yKLM.");
 MovePerson(187,10,2);
 DecPerson(187);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÌÖ½ñºó>
 NextEvent();
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"ƒO…m ƒa‡pS „Vƒv ƒs‚V‚CZ.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒa‡p{ ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚K‚J, ‰q…f ‡YŠiS ŠGƒmŒs…E‚CZ.");
 end
 end,
 [464]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"vv‡z „}ƒ^ƒ`A …A…w‚V …S‚K‚h …V‚S…E WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, G‹@ Šoƒb ƒG‚}‚h ‹^„QA HI n‡PKLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ˆE‚KŠF nL‚f …S‚KY‚C …V‚bMA vv‡z ŠGƒWƒGf ‡t‡LWLM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"ˆE‚K‚b {…B ‚~^ƒP Z‚CGƒv ƒkƒLG ƒYuƒGD ‡@KLM. ˆE‚K„Vƒm„S‚b¡­¡­.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ‚SŠS ‰bƒU„S „ia‚C ‚kƒm‡ILY?",
 1,"…S‚K‚h loM BD ˆGu „ND‚b ‚a†ym?",
 126,"‚GƒaƒP ‚^a^ ‰I†yM‚b…h GƒsM Šoƒb ƒG‚}^ ‚SƒZ „O†yKLY?",
 1,"‡mƒv¡­¡­",
 126,"ƒa‡pG ‚K‚JS ‚s†Ea†yM PƒmL …S‚KƒP ‚r…x‚h ƒGMƒ` ƒs‚V‚CZ.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚K‚J, †~ƒm„S Šoƒb …IG n‚`LY? G‹@ ƒG‚}‚b …A…w‚V …HnƒRGŒs…E WLM.");
 end
 end,
 [465]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒ{D";
 JY.Base["D‚wC"]=19;
 AddPerson(189,6,7,3);
 AddPerson(24,19,9,1);
 AddPerson(196,23,11,1);
 AddPerson(200,27,13,1);
 AddPerson(188,9,14,0);
 AddPerson(191,13,16,0);
 AddPerson(192,17,18,0);
 AddPerson(187,37,23,2);
 SetSceneID(56,8);
 DrawStrBoxCenter("ƒ{D †X‚B");
 DrawMulitStrBox("¡¡G‡Eƒb …S‚KƒP ‚KD ƒ{D. …S‚K‚b IŠW ‡{G‚f …dƒjM.*¡¡vvƒP ‚n, ‡Y‡bƒP [, ƒ[uƒd ‡{. G |} F„tƒP ˆEƒo^ ƒU„S d‡y„XƒP ‚B‚v, ‚sa|‡L‚C„TM.*¡¡Gd ƒ[ ‚B‚vG N‚]f ‹Z„}‚Cƒd „O„kM.");
 MovePerson(187,10,2);
talk(187,"G ƒa‡p, ‰BnŠXKLM.",
 189,"‚M, vv‚b I‚S‚f †CP‚b^? o‚eƒP ƒa„S‚h ‡f‚b …h D‡z‚K†yMŠB^?",
 187,"vv‚b ƒOu‚h ‰I‚C ‚kS ƒuhLM. …f‚b G‰yo ˆE‚KƒP ‚G‚P‚h ‚s†EWLM.",
 189,"‚G‚P‚f. ŠU ‰jƒO‚b ‚^aƒRG „OM ƒR„kM. ŠoM, ‚G‚PfQ ƒQ‚TS ‰Ra‚f.",
 187,"‚r…x„S‚b ˆFFG ^ƒa ƒLWWLM.",
 189,"ƒ[†{ ˆFF, ƒ[‚_^ ‚G‚PfQ ^ ƒQ‚TS ‰Ra‚f.",
 188,"k.");
 MovePerson(24,1,1);
 MovePerson(24,0,2);
talk(24,"‚K‚J, ‡d‚V z…c‡I‚V[!",
 189,"I‡H …Ij^, ‚U‡b?",
 24,"‚G‚P‚h …S‚Kf ƒRbƒW‚b ‚o ŒjLM. ƒ[^ [A G ƒv‚f‚b Šc‚C‚kn ƒ[fQ Šf„hŒVLM.",
 187,"ƒ[‹@ …Iƒb ‚aS ƒuG[. ‚G‚P‚b ‚K‚J{ „Gƒb TˆjG[. QM^ ƒQ‚T ‚aG ‚SŠS ƒv‚f‚h ‚C‰J†ym?",
 189,"ƒ[ ˆ|G ŠGM, ‚U‡b. ‚Cƒgƒb ‚G‚PfQ ‰RX q‹wf ‚aM. ˆFF, ƒ[‚_^ ^‚f. ƒv‚b „Yƒ{fƒW ƒGMu†yM.",
 188,"k.",
 24,"‚K‚J¡­¡­");
 MovePerson(188,1,0);
 MovePerson(188,12,3);
 NextEvent();
 end,
 [466]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,22,10,1);
 AddPerson(133,11,16,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("‚IS ƒP‚r‰R");
 AddPerson(188,-5,2,3);
 MovePerson(188,10,3);
talk(188,"‚G‚PŠi, ‹n‚M ‹p†yKLM. …f‚b ˆFFG‚f a†B ƒa‡pƒP ŒzhLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<»á¼û·¨Õı>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [467]=function()
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ˆFF{ ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"ƒa‡pƒP ŒzG‚fA ƒa‡p{ „Gƒb `‚ES ‚C†m ‚r†vG†y‚wƒ`.");
 end
 if JY.Tid==188 then--·¨Õı
talk(188,"ƒa‡pG G†w ˆ|Š[…w„~S „{ …FLM. ‚Gƒaƒb ƒv‡Cab ƒkƒLS ‡f‚C ˆfWLM. ab …fŠs‚b …S‚K‚h ‚G‚PŠiŠ_ ƒU„Qƒd…x WLM.",
 1,"‡mƒv ‚Gƒaƒb ƒv‡z „Gƒb TˆjG[. „y…X ƒ[ ƒG†nS Šf„hS q‚b ‚am.",
 188,"‚GƒaƒP ‡{ƒb Šc‚C‚kn …gfQ Šf„hŒVLM. ƒ[Šl ƒUf‚b ~‚KfQ ƒU„Q‚b „KG ‹o‚CZ. ƒ[uƒd ƒ[ ~‚K^ ƒU„S ‚G‚PŠiG‚f …fŠs‚b ‹bLM. ‚^ƒZ ‚r†oa‚C …X‡I‚V[.",
 1,"¡­¡­„a†ym. ‚J‚X, „N„w{ M‚V CƒPB ƒs†ym. [ƒXƒb ‹z„kƒmL ƒO…m †JefƒW ‹]‚V[.",
 188,"ƒdŠOKLM.");
 MovePerson(126,3,2);
 MovePerson(126,3,1);
 MovePerson(126,1,3);
talk(126,"d^ ‚oƒ_a†yKLM.")
 MovePerson( 126,10,2,
 188,10,2);
 DecPerson(126);
 DecPerson(188);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÌÖ½ñºó>
 NextEvent();
 end
 end,
 [468]=function()
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚K‚J, G‹@ Šoƒb ƒG‚}f ‚SŠS ˆl„LG‚C ‚kƒm‡ILY? ƒa‡p{ ˆFFG G†w ƒ]S e…TƒmL aƒXG ‚KƒN ƒuG‚f bƒG‚C ‚kƒm‡ILY?",
 1,"‚M¡­¡­",
 133,"ˆE‚K‚b ƒX ƒkƒLG ƒYu‚b ˆmGƒv, …S‚K‚b ‚r„NG „[ƒm„S Še…e‰jb vv¡¤‡Y‡b{ …x†]S „}ƒ^ƒGf Šoƒb ‡EhLM.",
 1,"ƒv‚b ƒw` vv‚h ^ƒa †w„EPm. „Gƒb Tˆjj ‚GƒaS ˆjMA vv‡z M‚h ƒU^ ‚a‚C ‚km?",
 133,"‚Cƒgƒb ‚qƒohLM. Tˆj„V ‚i‚CM^‚b †jn…gS q ‚aKLM. ƒ[ `‚Eƒb ‚|ƒwo ‚V‚_fƒv „wWLM. ‚K‚JŠ_‚b oNS „C†j„u ƒn ƒ]G „O‚S…E a†B, G‚h Škƒd Jƒb …Y†Kf ‡GG‚VA ‚^aƒRG ‹Xƒv†hLM.",
 1,"¡­¡­ŒRƒb ˆ|G[. „a†ym. ƒ[ ˆ|S …X‚Mf †DƒG†ym. ƒdŠOm.",
 133,"[, †@†daŠVMA ‚^aƒRS ‚Zƒm‚V‚CZ.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [469]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(126,19,17,2);
 AddPerson(133,25,14,2);
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(175,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(170,9,15,0);
 AddPerson(127,7,14,0);
 SetSceneID(54,12);
talk(133,"‚Z‚[ ‚ZGŠVKLY? ‚}ƒP‚h ‚VJa†yKLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [470]=function()
 if JY.Tid==2 then--¹ØÓğ
talk(2,"…S‚K‚b …UZo ˆmhLM. laƒ`A ‰q…f ‡t‡LŠW ƒe‚PB…E WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, …f‚h …huƒd …S‚K‚h „Q…e ^‚V‚CZ.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‚K‚JƒP ‡L‚^‚h ‚i‚j†yKLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"…S‚KD ‚eZaƒv ˆE‚K ‡Oo ƒ[f ˆf‚C‚kƒmL, ‰jˆlf …S†fo IƒaS …g„} ‚C‰JQ B…E WLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, …f‚b ƒvG^ ƒR„kƒmƒv Ik‚b vƒgD „{‚C ‚kƒtKLM. ‚^ƒZ …f‚h …S‚K„S …hƒ`^ ‚K‡I‚V[.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚^ƒZ …f‚h …m‡Wƒm„S |n ‚K‡I‚V[.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ˆE‚K‚b d^ ‚C‰J†yKLM. ƒ[…eL eƒOŠi, ƒa‚PŠi, v‡SS …g„} ‚K‡I‚V[.",
 1,"Šom. ƒ[†{ eƒO …}ƒb ˆE‚Kf …gƒd GƒL{ …y‡rD …gƒm‚V[. ƒvŠc‚C‚b ƒv‡z ‰HŠ_ …S‚K„S …yM.",
 126,"k. ˆE‚K q‚P‚b dQ ŠEƒG‡I‚V[. Šoƒb m‚yS ƒGMu†yKLM.");
 ModifyForce(2,0);
 ModifyForce(3,0);
 ModifyForce(54,0);
 ModifyForce(126,0);
 ModifyForce(114,0);
 ModifyForce(83,0);
 AddPerson(188,-5,2,3);
 MovePerson(188,10,3);
talk(188,"†@†daŠVKLY? ƒ[†{ „Yƒ{ƒm„S ^‚V‚CZ. ‚GƒaG ƒGMuƒd „OKLM. ‹Iƒm„S …fD ‚G‚PŠiS ‚nB …Ia†yƒmL ŠU ‚^…a…w„tLM.");
 ModifyForce(188,1);
 PlayWavE(11);
 DrawStrBoxCenter("ˆFFG ‚^a^ „C„kM!");
 JY.Smap={};
 SetSceneID(0,3);
talk(188,"ƒ[†{ d^ „Yƒ{ƒm„S ‚oƒ_a†yKLM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"…f‚b ‚K‚J{ ‰HŠ_ …S‚K„S ^†yKLM.");
 end
 end,
 [471]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="„Y";
 JY.Base["D‚wC"]=0;
 AddPerson(189,9,9,3);
 AddPerson(24,20,8,1);
 AddPerson(195,22,9,1);
 AddPerson(194,9,15,0);
 AddPerson(196,11,16,0);
 AddPerson(197,13,17,0);
 AddPerson(1,17,13,2);
 AddPerson(188,21,15,2);
 SetSceneID(49,8);
 DrawStrBoxCenter("„Y ƒP‚r‰R");
talk(188,"‚G‚PŠiS ‚ZŒs ŠXKLM.",
 189,"n, ‚G‚P. [†G ƒGM„~m.");
 MovePerson(188,3,0);
 MovePerson(188,1,2);
 MovePerson(188,0,1);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [472]=function()
 if JY.Tid==189 then--Áõè°
talk(189,"‚G‚PŠi, d ‚^aƒRG G‹@…f‹@ ˆ|S aƒv …f‚b ‡iƒNS ˆ[KLM.",
 1,"ƒ_^ ŠXƒmL ‚o†da‚V[. ƒa„S‚b ƒ_^ C‚_a†ym.",
 189,"†~ƒm„S ‡N‚rWLM. ƒ[†{ ‡k‹J ‚^ƒ{ƒm„S ^‚V‚S ‚~…X‚h F‡]B ‚K‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥¸¢³Ç>
 NextEvent();
 end
 if JY.Tid==24 then--»ÆÈ¨
talk(24,"ƒv‚b ‚U‡bG[. ƒ[‚_‚h ƒsƒd Š]‚C ‚km.");
 end
 if JY.Tid==194 then--Áõ¹ó
talk(194,"G‡EfƒW ˆ|qS …Iƒm‰J‚C ‚k‚b Q ŠoS ƒuG[. ‡{ƒP †eƒ{ƒb „V„V„Q ‚km.");
 end
 if JY.Tid==195 then--Àä°ú
talk(195,"ƒa„S^ ŠPƒR‚S‡zD ƒOu‚b ‚[Šq‚C ‚km. o…XƒZ„S ƒOuƒv‚ff ƒk‚Cjƒb „sZ ‚am.");
 end
 if JY.Tid==196 then--ÕÅÈÎ
talk(196,"‰q †r [‚V†s‚f qƒdPm. ‡q…h ‚SŠSab G‡Ef ŠXm?");
 end
 if JY.Tid==197 then--µËÏÍ
talk(197,"…M! †@} …S‚K‚h ƒYuƒd †[ ƒu nL[?");
 end
 if JY.Tid==188 then--·¨Õı
talk(188,"‚G‚PŠi, ‰q…f …fŠs ‚K‚JŠ_ j‚r‚h ƒiu‚V‚CZ.");
 end
 end,
 [473]=function()
 if JY.Tid==189 then--Áõè°
talk(189,"ƒ[†{ ‡k‹J ‚^ƒ{ƒm„S ^‚V‚S ‚~…X‚h F‡]B ‚K‡I‚V[.",
 1,"ƒ[†{ ƒv‚b ‚^ƒ{ƒm„S ^†ym.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==24 then--»ÆÈ¨
talk(24,"ƒOufQ‚b ƒLG HI ‡AKLM. ‹wƒm„S‚b ƒk†IG, ‚oƒm„S‚b ƒ_…yG¡­¡­.");
 end
 if JY.Tid==194 then--Áõ¹ó
talk(194,"G‡EfƒW ˆ|qS …Iƒm‰J‚C ‚k‚b Q ŠoS ƒuG[. ‡{ƒP †eƒ{ƒb „V„V„Q ‚km.");
 end
 if JY.Tid==195 then--Àä°ú
talk(195,"ƒa„S^ ŠPƒR‚S‡zD ƒOu‚b ‚[Šq‚C ‚km. o…XƒZ„S ƒOuƒv‚ff ƒk‚Cjƒb „sZ ‚am.");
 end
 if JY.Tid==196 then--ÕÅÈÎ
talk(196,"ƒ[†{ ƒa„S‚h „Q…e ^…x.");
 end
 if JY.Tid==197 then--µËÏÍ
talk(197,"…M! †@} …S‚K‚h ƒYuƒd †[ ƒu nL[?");
 end
 if JY.Tid==188 then--·¨Õı
talk(188,"G‡EfƒW‚b ˆl„LGƒG …d„KWLM. ‚SƒW ‚^ƒ{ƒm„S ^‚V‚CZ.",
 1,"ƒ[†{ ƒv‚b ‚^ƒ{ƒm„S ^†ym.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==1 then--Áõ±¸
talk(1,"ƒ[†{ ƒv‚b ‚^ƒ{ƒm„S ^†ym.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [474]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒ{D";
 JY.Base["D‚wC"]=19;
 AddPerson(189,6,7,3);
 AddPerson(24,19,9,1);
 AddPerson(194,23,11,1);
 AddPerson(249,27,13,1);
 AddPerson(195,9,14,0);
 AddPerson(196,13,16,0);
 AddPerson(197,17,18,0);
 AddPerson(187,18,14,2);
 SetSceneID(56,11);
 DrawStrBoxCenter("ƒ{D †X‚B");
 DrawMulitStrBox("¡¡‚G‚P^ ‚^ƒ{f ‹f…x…X…x ƒ[ƒRƒP ‹h‚Z^ ƒ{DƒP ‚GƒafQ _‚E„C„kM.");
talk(189,"ƒa‡p, …GƒG ‚Bf X ˆ|G „O†sŠm?",
 187,"‚SŠSab …f‚h …GGƒ` a‡ILY?",
 189,"n„LD ‚V„Q†w‚h Œl†sŠm! „p^ ƒH[f ˆEfQ ƒv‚f‚h ‚G‚PfQ ƒU‡RMƒd ˆ|Pƒd, „p ˆEG G†w ƒd_PM. ƒ[…eƒdD ‚Z‡MM a†sŠm!",
 187,"¡­¡­! ˆEŠi¡­¡­ d^ ƒ[uo YVS F‡} ‚Z‚j‡ILY?",
 189,"Q „O†sŠm! G †cƒN…xƒP ƒcS ŠP‚f!",
 196,"k!");
 MovePerson( 196,1,0,
 194,1,1);
talk(194,"G †cƒN…x, …G‚S …XˆmaM!",
 187,"…v¡­¡­!");
 ModifyForce(187,0);
 DecPerson(187);
 DrawSMap();
 NextEvent();
 end,
 [475]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚^";
 JY.Base["D‚wC"]=20;
 AddPerson(1,10,17,0);
 AddPerson(133,9,14,0);
 AddPerson(170,10,9,3);
 AddPerson(128,12,8,3);
 AddPerson(127,24,17,2);
 AddPerson(117,26,16,2);
 AddPerson(188,19,12,1);
 SetSceneID(83);
 DrawStrBoxCenter("‚^ƒ{ ƒP‚r‰R");
 DrawMulitStrBox("¡¡ˆFFƒb ƒa‡pG …G„kM‚b m‚yS Š^ƒd ‰bƒU„S ‚G‚PfQ „a„~M.");
talk(188,"‚G‚PŠi, ƒa‡pG ‚GƒafQ …GRS ‡iPKLM.",
 1,"I‡JG[? ƒ[ƒuG ‚rNG[?",
 188,"‚SŒJˆe ƒOu „TƒCG …w…eŠgKLM. ‚SŠSXYZ?");
talk(133,"‚K‚J, ‚SƒW †@†Ma‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÌÖ½ñºó>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [476]=function()
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚JS ‚nBƒW‚fA †e ‚W …G‚SD …XMa‚C ‚k†yKLM!");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚K‚J, ‚r…x^ ŠXKLM.");
 AddPerson(365,43,0,1);
 MovePerson(365,10,1);
talk(365,"‚K‚J, …f‚b ˆE‚KfƒW ŠXƒm†B d‡y ‚T‚rƒP ˆ|Š[S ^ˆkŠXKLM.");
 NextEvent();
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚K‚J, …A…w‚V …S‚K‚h laŒs…E WLM!");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"‚K‚J, …S‚K‚h …VƒmA vv‡z „}‹a „@G `ŒVLM.");
 end
 if JY.Tid==188 then--·¨Õı
talk(188,"‚G‚PŠi, ‚^ƒZ ƒa‡pƒP ƒQq‚h ‹yn ‚K‡I‚V[. ƒa‡pƒP …G‚MS ‰u„CQ X q‚b ‚aKLM!");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚K‚J, G ‚Cƒ@f G‚jŠjƒmL †@†Ma‡I‚V[! …S‚K‚h „Q‚V‚CZ.");
 end
 end,
 [477]=function()
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚T‚rŠ_ I‡H …IG „O‚b ƒu…IY.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"ƒO…m ‚r…xƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(365,"‚J‚XŠ_ƒW ‚Ba‚VƒG‚h, ŠZ…xu„S ƒsn ‚K‚JŠ_ƒW ˆl„LG‚VƒGf Šo‚C ‚kƒmL …bFƒb ƒN‚eŠW a‚V‚f aŠbKLM.");
 NextEvent();
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚T‚r^ ƒsˆZ ‚r…xj^? I‡H …IG[?");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"‚T‚r^ ƒsˆZ ‚r…xj^? I‡H …IG[?");
 end
 if JY.Tid==188 then--·¨Õı
talk(188,"‚G‚PŠi, ‚^ƒZ ƒa‡pƒP ƒQq‚h ‹yn ‚K‡I‚V[. ƒa‡pƒP …G‚MS ‰u„CQ X q‚b ‚aKLM!");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚J‚XG I‡H ˆ|S aƒ`‚b ‚@YZ? ‚K‚J, ‚r…xƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 end,
 [478]=function()
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"ŠZ…xu‚f? ƒv‚b DI‚C ‚Z‚j†ym.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚T‚rŠ_ƒW ƒ[u ˆ|Š[aŠVMA …bFa‚C …X‚V‚CZ.");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(365,"‚T‚rŠ_ƒW‚b …bFS ‡d‚V †wƒ^‚b „KG ‹oM a‡ILM.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"ŠZ…xu^ Fˆ| ƒ[u ‚eZo ƒuhLY?");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"‚T‚rŠ_ƒW ŠZ…xu‚h ƒsN „{ ‚oM‚b ˆ|ƒb ƒR„kKLM.");
 end
 if JY.Tid==188 then--·¨Õı
talk(188,"‚G‚PŠi, ‚^ƒZ ƒa‡pƒP ƒQq‚h ‹yn ‚K‡I‚V[. ƒa‡pƒP …G‚MS ‰u„CQ X q‚b ‚aKLM!");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(1,"‚J‚XG ƒ[u ˆ|PM‚b…h, „N„wƒb ‚SŠS ƒs‚V[?",
 133,"¡­¡­d^ „v ŠZ…xu‚b raƒG‚bU‡} [ŠWƒ` ‚_†rƒP v‰chLM. †KƒP„Q …X‡I‚V[. …IG G ‚Cƒ@f G‡M GC ˆE‚K„S ‰Bn^‚b ƒuƒb a‚uGZ, ƒvn^ „Q‚b ƒuG C‚uhLM.",
 1,"a[ƒv¡­¡­",
 133,"‚K‚J, ƒOu^ bƒGY‚C †[ ƒuG I‡J „U…ZhLY? …S‚K‚h la…e †[ ƒuG n‚`LY?",
 1,"‚M, „a†ym. …bFoM!",
 133,"…Xƒlƒ_ †@†daŠV‚TZ. ‚Gƒa‚TG „Yƒ{f †L†@aƒd „OM WLM. „Yƒ{S „Q‚Vƒ`A ƒe‚P‚h ‹s…c‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×ö³öÕ÷Áõè°¾üµÄ×¼±¸>
 NextEvent();
 end
 end,
 [479]=function()
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"…bFaƒG„S FaŠVMA …f‚b ‚i‚h ŠFhLM.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"…bFa‚V‚CZ.");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(365,"ƒ[†{ ƒA…e^†yKLM.");
 MovePerson(365,10,0);
 DecPerson(365);
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚K‚J, …bFa‚V‚CZ.");
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"…fD ‰jˆlf ƒvƒW†yKLM.");
 end
 if JY.Tid==188 then--·¨Õı
talk(188,"‚G‚PŠi, ‚^ƒZ ƒa‡pƒP ƒQq‚h ‹yn ‚K‡I‚V[. ƒa‡pƒP …G‚MS ‰u„CQ X q‚b ‚aKLM!");
 end
 if JY.Tid==133 then--ÅÓÍ³
 if talkYesNo( 133,"ƒe‚P„CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
talk(133,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(33,"d3ƒa „YI ‚B„e","1. ‚GˆH ‚p…D",30,0,193);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,5,17,4,0,-1,0,
 132,23,17,4,0,-1,0,
 -1,22,16,4,0,-1,0,
 -1,7,17,4,0,-1,0,
 -1,6,16,4,0,-1,0,
 -1,22,18,4,0,-1,0,
 -1,23,18,4,0,-1,0,
 -1,6,18,4,0,-1,0,
 -1,5,16,4,0,-1,0,
 -1,4,18,4,0,-1,0,
 -1,4,19,4,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
talk(133,"ƒ[†{ „Yƒ{ƒm„S g_a†yKLM.");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 193,23,3,1,0,40,9,0,0,-1,0,
 194,22,5,1,0,36,3,0,0,-1,0,
 196,20,19,4,1,36,3,0,0,-1,1,
 248,26,17,3,1,37,20,0,0,-1,1,
 199,14,4,3,0,37,6,0,0,-1,0,
 200,7,6,3,1,37,9,0,0,-1,0,
 201,8,7,3,1,37,9,0,0,-1,0,
 
 256,5,7,3,1,33,3,0,0,-1,0,
 257,16,4,3,0,33,3,0,0,-1,0,
 292,19,17,4,1,35,9,0,0,-1,1,
 293,20,17,4,1,35,9,0,0,-1,1,
 274,19,18,4,1,32,6,0,0,-1,1,
 275,26,4,1,0,33,6,0,0,-1,0,
 294,6,8,3,1,34,9,0,0,-1,0,
 277,24,5,1,0,33,6,0,0,-1,0,
 310,22,14,1,1,33,12,0,0,-1,1,
 332,21,15,1,1,33,14,0,0,-1,1,
 333,15,5,3,0,32,14,0,0,-1,0,
 295,15,3,3,0,34,9,0,0,-1,0,
 340,25,3,1,0,33,17,0,0,-1,0,
 195,24,14,1,1,37,6,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [480]=function()
 PlayBGM(11);
talk(194,"‚G‚P^ …Xƒlƒ_ „vƒ{S …w…e„jM. †J‚V …S‚K‚h ƒY„~ŠB ƒuGM.",
 200,"ƒ[ŠQKLM. ƒaRfQ ŠEƒG‚V‚CZ.",
 133,"‚K‚J, „Yƒ{S ‰HˆyaA ƒ{D^ d‚C ‚kKLM. ‚K‚JŠ_ƒW‚b ‚TS Gˆnƒd ‡kCB ƒLƒP ‚Kƒ}S ˆn‚S ‚K‡I‚V[. …f‚b ƒ[ ŒoS …@ ƒLƒP ƒ{S ƒGKa†yKLM. ‚M¡­¡­");
 WarShowTarget(true);
 WarShowArmy(195);
 WarShowArmy(196);
 WarShowArmy(248);
 WarShowArmy(292);
 WarShowArmy(293);
 WarShowArmy(274);
 WarShowArmy(310);
 WarShowArmy(332);
 DrawStrBoxCenter("ƒLƒP ‚D‚~G ƒv…@ŠgM!");
talk(196,"{…B ƒ_ kC‚_„SM. ƒL‚TG Œ{†G „[†rS „|ƒmƒ` a‚b‚wƒv.",
 133,"n¡­¡­ ƒ_ „T‚uG …y†V‡iP‚wƒv.",
 170,"‚^‚T‚r!",
 1,"„N„wG ‚aƒmA …S‚K‚h …VS q ‚aM. ‚B‚Tƒb ‚^‚T‚r‚h ‚wa…e ^‚f!");
 PlayBGM(9);
 NextEvent();
 end,
 [481]=function()
 if JY.Death==133 then
 PlayBGM(2);
talk(133,"ƒv¡­¡­ ƒv‚b bƒGƒW …G‚b ƒuj^? ¡­¡­‚_†nS Gƒ^‚C ˆfaƒd¡­¡­ „IS ‡NS q ‚a‚wƒv¡­¡­");
 WarAction(18,133);
 --DrawStrBoxCenter("ÅÓÍ³Õ½ËÀ£¡");
 SetFlag(38,1);
talk(170,"¡­¡­‚K‚J, ‚^‚T‚rŠ_ƒW ƒA…eƒvŠVKLM. ƒOuD ‚^ƒ{ƒm„S ƒA…eƒv‚V‚CZ.",
 1,"‚M¡­¡­ ƒ[†{ ƒA…eƒv…x. ¡­¡­„N„w, ƒ[‚_‚b ‚SŠS „C„km?¡­¡­");
 DrawMulitStrBox("¡¡‚G‚P^ „Yƒ{ ‚J‚pS †aƒGPM.");
 WarGetExp();
 ModifyForce(133,0);
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if War.Turn==8 then
talk(196,"¡­¡­‚SƒW ƒv‡z‚f!",
 1,"I‡JG!? ƒLG ƒOu ‚T„XS ƒGKPM.",
 170,"‚K‚J, G‚_„SA ƒOu ‚TG ‰Wƒ@f ƒE†LLM. ƒO…m ‚^ƒ{ƒm„S ƒA…eƒv‚V‚CZ.",
 1,"‡m, ƒ[Šl q‹wf ‚a‚wƒv.",
 195,"‚GˆH, ƒLG ƒA…eƒvƒ`‚b ‡Ka[.",
 194,"[, ƒaRƒP ‚[ ‚W[ „T‚uG „wo ‚Z†oG[. ƒaR ƒ[ ˆj‚w, †~ƒm„S ‚_†Ma[!");
 DrawMulitStrBox("¡¡‚G‚P‚Tƒb ‚T„XG MB ƒA…eŠgM.");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(11);
talk(194,"a‚b q ‚aM. ƒ{S IQ ‚C‡Q q‹wf.",
 1,"‚M¡­¡­ ƒLG ƒ{S IQ ‚C‰J‚b‚T.",
 170,"ƒ[…eA „QƒG ‚SŠqKLM. ƒOu ‚T„XD Œv…X …g‚C ‚kƒtƒmL ƒO…m ‚^ƒ{ƒm„S ƒA…eƒv‚V‚CZ.",
 1,"ŠoM, ‚^ƒ{ƒm„S ƒA…e‚qM.");
 DrawMulitStrBox("¡¡‚G‚P‚TG „Yƒ{ ‚J‚pS ‡d‚V z…c„kM.");
 GetMoney(1200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£²£°£°S …V„kM!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [482]=function()
 SetSceneID(0);
talk(170,"ƒ[†{ ‚^ƒ{ƒm„S ‰Bn^…x.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<·µ»Ø¸¢³Ç>
 NextEvent();
 end,
 [483]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚^";
 JY.Base["D‚wC"]=20;
 AddPerson(1,10,17,0);
 AddPerson(170,10,9,3);
 AddPerson(128,12,8,3);
 AddPerson(127,24,17,2);
 AddPerson(117,26,16,2);
 SetSceneID(83,5);
 if GetFlag(38) then
 PlayBGM(2);
talk(1,"„N„wƒb ‚SŠS „C„km? I‚ra†y‚CZ.",
 117,"¡­¡­ƒaRƒP ‚D‚~f ‚@ƒ` †[ˆuf @†jS ŠGƒd …~S †E‚[ŠVKLM¡­¡­",
 1,"I, I‡JG[? ‚G‡W, ƒ[ m‚yG iNa[?",
 117,"k¡­¡­",
 1,"‚SŠS G‹@ …IG! „N„w¡­¡­");
 else
talk(170,"‚K‚J, ‚^‚T‚rŠ_ƒW‚b g‚C‚h †j‰X…e ^‚V‚S G‡Ef [‚V‚C ˆfWLM. xŠZŠW ‚rbƒP ˆ|Š[S ‚BaŠVKLM.",
 1,"ƒ[‹@^. „Nƒgƒb „^Q „D„gm. „N„wfQ „V…IƒP …IG‚fD `‹HMA¡­¡­");
 end
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÌÖ½ñºó>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [484]=function()
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ‚_[‚h F‚PB „Yƒ{S „Q‚V‚CZ.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"ˆ|ƒb ƒ[…eaƒv …S‚KƒP ‚~‚rƒRG `‚EƒsM ‚Ia‚wƒ`.");
 end
 if JY.Tid==128 then--¹ØÆ½
talk(128,"‚K‚J, G …Iƒb ‚J‚X{ CƒPa‚V‚b „KG Šo†yKLM.",
 1,"‚M, ƒ[ ˆ|G ŒRm. ƒ[†{ eƒw, qƒd ‹D B ‚KQ.",
 128,"k, ‰bƒU„S ‹Xƒv†yKLM.",
 1,"‚M¡­¡­ ‚K†gD …hƒ`^Q.");
 AddPerson(155,44,0,1);
 MovePerson(155,10,1);
talk(155,"…f‚h ‚^‚jŠVKLY?",
 1,"ƒ[ŠQ„p. ‚K†g, eƒw{ ‰HŠ_ ‚ISƒm„S ^ ‚J‚XfQ ƒQ‚TS ‰RaQ.",
 155,"k, ‰bƒU„S …b_a†yKLM.",
 128,"ƒ[†{ …fŠs‚b ƒA…e^†yKLM.");
 MovePerson(128,2,0);
 MovePerson(128,3,3);
 MovePerson( 155,10,0,
 128,10,0);
 DecPerson(155);
 DecPerson(128);
 ModifyForce(128,0);
 ModifyForce(155,0);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==117 then--Áõ·â
talk(117,"„Yƒ{ƒb ‰HˆyaƒG ‚SŠqKLM.");
 end
 end,
 [485]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=15;
 AddPerson(126,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(54,11,16,0);
 AddPerson(128,17,12,3);
 AddPerson(155,15,13,3);
 SetSceneID(54,12);
 DrawStrBoxCenter("‚IS ƒP‚r‰R");
talk(128,"¡­¡­‚rFG G…eWLM. ‚T‚r, Šoƒb „N‚uG „Oƒm‡ILY?",
 126,"‰bƒU„S ƒQ‚TS ƒsƒ_†ym. ‚M, eƒOŠi. ƒ[uƒd eƒw{ ‚K†gƒb …gn ˆE‚K‚h ‚C‰J‚V[.",
 2,"„a†ym. ˆE‚K‚b ƒ_Q ŠEƒG‚V[.",
 126,"eƒOŠi, GƒRƒb ‡iƒNƒP ‚^aGL ƒ]‚_„S ‚^u‡I‚V[.");
 AddPerson(34,3,4,3);
 AddPerson(38,1,5,3);
 AddPerson(39,-1,6,3);
 MovePerson( 38,5,3,
 34,5,3,
 39,5,3)
talk(38,"…f‚b ‡eƒshLM. eƒO ƒa‚TƒP ‡L‚^‚h ‚i‚j†yKLM.",
 34,"…f‚b Z@hLM. eƒO ƒa‚T sfƒW …IaQ „C‚S ƒGŒgLM.",
 39,"…f‚b vƒ^‚f WLM. ŠU ‚^…a…w„tLM.",
 2,"‹Iƒm„S ‡AGƒR D‡z‚KQ.");
talk(126,"ƒ[†{ ƒa‚PŠi{ v‡SŠ_ƒW‚b ‚[ ‡y†G„S ƒvx‚S ‡{ƒm„S ƒR‚S^ ‚K‚JS ‚CƒQa‡I‚V[.",
 3,"„a†ym.",
 54,"„a†yKLM.",
 126,"ƒ[†{ ‚SƒW …bFS ƒe‚PB ƒWŠe…e ‚CƒQa…e ^‚V‚CZ.");
 ModifyForce(3,1);
 NextEvent();
 end,
 [486]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚^";
 JY.Base["D‚wC"]=20;
 AddPerson(1,10,17,0);
 if not GetFlag(38) then
 AddPerson(133,9,14,0);
 end
 AddPerson(170,10,9,3);
 AddPerson(127,24,17,2);
 SetSceneID(83);
 DrawStrBoxCenter("‚^ƒ{ ƒP‚r‰R");
 AddPerson(369,43,0,1);
 MovePerson(369,10,1);
talk(369,"‚K‚JŠ_ nŠnLM. ƒa‚PŠiƒP ƒQ‚TG D†WPKLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [487]=function()
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚T‚rŠ_ƒW ‰bƒU„S ‡YS ˆ`ƒN ‚Z†ohLM.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"G‰S…l Wu ‹hƒd ƒR‚S[ML {…B †_ƒa ƒa‚P„S‚TZ.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"ƒe‚PD ‹s…c‚C ‚kƒd I‚ZaQ ˆj ˆ~f G‹@ †@{^ „C„k‚wƒ`.");
 end
 if JY.Tid==369 then--Îä¹Ù
talk(1,"‚SƒW ƒa‚P‚h ‚^‚j‚f.",
 369,"k!");
 MovePerson(369,10,0);
 DecPerson(369);
talk(1,"†~ƒm„S Wu ŠX‚wƒv! ˆE‚KfƒW ‡{f G‚j‚b †rƒc…XM ‡{‚TG ‚C‰Jƒd „O„kS ‹|…h.",
 170,"ƒ[ŠQKLM¡­¡­ n, ‚K‚J. ƒa‚PŠiG [ŠVKLM.");
 AddPerson(3,43,0,1);
 AddPerson(203,45,-1,1);
 MovePerson( 3,12,1,
 203,12,1);
talk(3,"ƒnˆEŠi, ŠXKLM.",
 1,"[, ƒa‚P. ŠU ŠXM! „p ‡Df …m G‚b †u‚wŠm?",
 3,"G‡Lƒb ‡n‚ohLM. [‚b ƒ_ƒ_ †r‹QG^ „C‚S ‚KŠVKLM.");
 NextEvent();
 end
 end,
 [488]=function()
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‡n‚oG‚f aŠbm? ƒsnaL ƒYƒaG‚V‚wƒ`.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚U‡t{ ‡n‚oƒb †~ƒm„S ƒY…SƒaG‚f X „VWLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"ƒa‚PŠiƒb „o†_ŠF nL‚f ‚C‚vD ‹s…cŠVƒmL {…B ‚K‚JƒP ƒPdG‡ILM!");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚T‚rƒP ‚X‚_„S ‚T‚r‡z v‡S, ƒ[uƒd d^ ƒo ‡y†G„S ƒvx‚S ‡{f ƒR‚SŠXKLM. [‚b †rf ƒ{S ‚C‰JŠB ƒYƒa ‡n‚oS EƒDPƒd, ƒ[ ‡D ‡n‚oG †r‹QG‚h B ‚K‚S G‰S…l Wu ‹fƒtKLM.");
if CC.Enhancement then
if not GetFlag(38) then
DrawStrBoxCenter("ƒa‚P^ …~ƒb ‚s‚^ ‚J†dS …V„kM!");
end
end
 NextEvent();
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"‚o‡}a‡ILY. …f‚b ‡n‚oG‚f WLM.");
 end
 end,
 [489]=function()
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‡n‚oG‚f aŠbm? ƒsnaL ƒYƒaG‚V‚wƒ`.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚U‡t{ ‡n‚oƒb †~ƒm„S ƒY…SƒaG‚f X „VWLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"ƒa‚PŠiƒb „o†_ŠF nL‚f ‚C‚vD ‹s…cŠVƒmL {…B ‚K‚JƒP ƒPdG‡ILM! ƒLƒaS EƒDa‚b …Iƒb Iƒ}„Vƒm„S „C‚b ƒuG nL‚CZ.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‡n‚oŠ_ ‡N‚r‚h …qa‚V‚CZ.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(1,"ƒa‚PƒP †r‹QG^ „C‚S ‚KŠVƒmL G ‚G‚P^ xŠZŠW ‡N‚r…wu[.",
 203,"n, ‡i„Q ‚kKLM. {‡Lo ˆ|Š[G‡ILM.",
 1,"‹Iƒm„S „@Šy D‡z‚K‚V[.",
 203,"ƒA‹mhLM. …Hn ‚K‚VL ‡N‚rWLM.");
 ModifyForce(203,1);
 PlayWavE(11);
 DrawStrBoxCenter("‡n‚oG ‚^a^ „C„kM!");
talk(203,"‚G‚P ‚K‚J, …S‚KƒP IƒaƒR, ‰b d ‚lUƒR ‚efD …S‚KƒP ‹IƒSS †Z†da‚b G^ „OKLM. ŠU E‚XaA ˆH„AB ƒi …xD „OS ƒuhLM.",
 1,"†~ƒm„S ŠU‹km. ‡n‚oŠ_ƒW ‡AG D‡z‚K‚V[.",
 203,"k. ƒvG‚b ƒR„kƒmƒv …A…w‚V „@S Ma†yKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×÷³öÕ÷öÃ³ÇµÄ×¼±¸>
 NextEvent();
 end
 end,
 [490]=function()
 if JY.Tid==170 then--»ÆÖÒ
 if talkYesNo( 170,"ƒ[†{ …bFa‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(170,"‚^‚_‚h M‚V „Kƒ{a‚V‚CZ.");
 WarIni();
 DefineWarMap(33,"d3ƒa „YII ‚B„e","1. ‚GˆH ‚p†U",40,0,193);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,18,22,3,0,-1,0,
 -1,16,22,3,0,-1,0,
 -1,17,22,3,0,-1,0,
 -1,19,22,3,0,-1,0,
 -1,18,21,3,0,-1,0,
 -1,20,21,3,0,-1,0,
 -1,19,20,3,0,-1,0,
 -1,17,23,3,0,-1,0,
 -1,19,23,3,0,-1,0,
 53,3,19,4,0,-1,1,
 125,1,20,4,0,-1,1,
 113,2,19,4,0,-1,1,
 82,0,20,4,0,-1,1,
 });
 DrawSMap();
talk(170,"G‚W‰` …A…w‚V „Yƒ{S ‰Hˆya†yM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"ƒQ‚TG ŠXƒmL …bFX „UhLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
 if talkYesNo( 133,"ƒ[†{ …bFa‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(133,"‚^‚_‚h M‚V „Kƒ{a‚V‚CZ.");
 WarIni();
 DefineWarMap(33,"d3ƒa „YII ‚B„e","1. ‚GˆH ‚p†U",40,0,193);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,18,22,3,0,-1,0,
 -1,16,22,3,0,-1,0,
 -1,17,22,3,0,-1,0,
 -1,19,22,3,0,-1,0,
 -1,18,21,3,0,-1,0,
 -1,20,21,3,0,-1,0,
 -1,19,20,3,0,-1,0,
 -1,17,23,3,0,-1,0,
 -1,19,23,3,0,-1,0,
 53,3,19,4,0,-1,1,
 125,1,20,4,0,-1,1,
 113,2,19,4,0,-1,1,
 82,0,20,4,0,-1,1,
 });
 DrawSMap();
talk(133,"G‚W‰` …A…w‚V „Yƒ{S ‰Hˆya†yM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, d^ ŠXKLM. ‚o†da‡I‚V[.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"ƒvG‚b ƒR„kƒmƒv …A…w‚V „@S Ma†yKLM.");
 end
 end,
 [491]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(3,"„Yƒ{G ƒU„S ‹IG‚CZ. ƒnˆEŠi, ‚SƒW ^‚V‚CZ!");
 ModifyForce(126,1);
 ModifyForce(54,1);
 ModifyForce(114,1);
 ModifyForce(83,1);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 193,23,3,1,0,44,9,0,0,-1,0,
 194,22,4,1,0,39,3,0,0,-1,0,
 196,12,16,4,1,39,3,0,0,-1,0,
 195,24,4,1,0,39,6,0,0,-1,0,
 199,6,6,1,0,37,6,0,0,-1,0,
 200,5,8,1,0,37,9,0,0,-1,0,
 201,7,16,4,1,37,9,0,0,-1,0,
 248,10,18,4,1,41,20,0,0,-1,0,
 274,7,7,1,0,33,6,0,0,-1,0,
 275,12,18,4,1,32,6,0,0,-1,0,
 256,21,3,3,0,33,3,0,0,-1,0,
 257,11,19,4,1,33,3,0,0,-1,0,
 292,25,3,1,0,36,9,0,0,-1,0,
 293,5,14,4,1,35,9,0,0,-1,0,
 332,13,17,4,1,35,14,0,0,-1,0,
 333,6,15,4,1,34,14,0,0,-1,0,
 294,11,17,4,1,35,9,0,0,-1,0,
 340,5,6,1,0,35,17,0,0,-1,0,
 341,4,7,1,0,34,17,0,0,-1,0,
 197,14,1,3,1,40,3,0,0,-1,1,
 198,15,2,3,1,40,9,0,0,-1,1,
 253,15,0,3,1,36,6,0,0,-1,1,
 254,16,1,3,1,36,3,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [492]=function()
 PlayBGM(11);
talk(194,"‚G‚P^ OaƒdD ‡O ŠPƒR‚SŠXM. d‚TƒR, ‚Gƒa ‚K‚JS ‚nB „@Šy ‰jƒO‚f!",
 201,"¡­¡­",
 202,"‚GƒaS ‚nBƒW‚fL, ‡m¡­¡­.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [493]=function()
 if WarMeet(3,196) then
 WarAction(1,3,196);
talk(3,"†u^ G ƒa‚P‡z „}ƒ^†y†sŠm? ƒv[H‚f.",
 196,"I‡JG? ƒa‚P‚fƒd? ƒa‚P‚h „_‚bMA ƒOu ‚TƒP ‚rƒG^ „^Q [‚ju‚f. ŠoM ƒa‚P, G ƒaRG C‚_a†yM.",
 3,"ƒaRG‚f? †u‚wˆe ŠoM. [H‚f.");
 WarAction(6,3,196);
 if fight(3,196)==1 then
talk(196,"G‹@ …x^. D…fŠW ‡iB‰M q ‚a‚wƒv.",
 3,"†EƒGƒW ‹laL „O‚C …X‚f!");
 WarAction(4,3,196);
talk(3,"H‚b ƒ_ C‚_^ ˆf ˆYM.",
 196,"¡­¡­I‡JS a‚b QŠm? ‚SƒW ‡zƒW „}ƒ^‚C ‚kƒd?",
 3,"H‚h ƒq‚b ƒuGƒb ‡YƒUˆv ‡D†LƒGM. GƒsQ, ‚GƒaƒP ‚_ƒo‚b G†w ƒG…[„k„p. ‰u„CG ƒc…~S „qu†sL ƒOufQ ‡g‚DaQ.",
 196,"¡­¡­I‡H muŠm? ƒv„l…e ‡g‚Da‚fƒd? nLM! „y‚fu …GS‚CˆAF ‡g‚Da‚C ‚k‚bM.",
 3,"ƒ[‚_‚b †~ƒm„S ‡tƒNG[. ƒ[ …X‚M „a†ym. ƒ[ŠQMA ‚{ q‹wf ‚a‚wƒ`!",
 196,"ƒm…v!",
 3,"¡­¡­…M!");
 WarAction(8,3,196);
talk(196,"ƒv‚h ƒq‚S M[¡­¡­ ƒdŠOm¡­¡­");
 WarAction(18,196);
talk(3,"¡­¡­†~ƒm„S n‡P‚wƒv. G…x‚b gFo IƒaG„kM!");
 WarLvUp(GetWarID(3));
 else
 WarAction(4,196,3);
talk(3,"nGƒd! G‹@ …x^. D…fŠW ‡iB‰M q ‚a‚wƒv.");
 WarAction(17,3);
 WarLvUp(GetWarID(196));
 end
 end
 if (not GetFlag(39)) and WarMeet(1,200) then
 WarAction(1,1,200);
 PlayBGM(11);
talk(1,"[ƒP, ‡n‚o…X…f ƒOufQ ‡g‚DPm. ‚SŠS ‰u„CG ‰X‚h Uuƒ` a[? ‚S‹cm, ‡g‚Da‚C ‚k†ym?",
 200,"¡­¡­„a†y„p. ‚G‚PŠiS ‚nB …Ia†y„p.");
 ModifyForce(200,1);
 PlayWavE(11);
 DrawStrBoxCenter("[ƒP^ ‚^a^ „C„kM!");
talk(200,"M„V ƒv‚b Œ^ ‚lU‡z ‰jƒOƒd Š]‚C ‚km. ‰q…f ƒA…eƒv†ym.");
 WarAction(16,200);
 SetFlag(39,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(40)) and WarMeet(1,201) then
 WarAction(1,1,201);
 PlayBGM(11);
talk(1,"[‚d, †D„S‡S …S‚K‚h ƒoƒOƒd Š]‚C ‚km? ƒOu‡z ‰HŠ_ „@‰l ‹b‚VM.",
 201,"¡­¡­…Iu^ „Om. ‡n‚oD ^†iPM ƒR„kƒmL¡­¡­ Šom, ƒvD ƒ[‚_ƒRfQ ^†ia†ym.");
 ModifyForce(201,1);
 PlayWavE(11);
 DrawStrBoxCenter("[‚dG ‚^a^ „C„kM!");
 SetFlag(40,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(41)) and WarMeet(1,202) then
 WarAction(1,1,202);
 PlayBGM(11);
talk(1,"ˆJ‚l, ƒv‚b G‡ES ƒY‚v‹Ta…e †[ ƒuG nL[. ‚GƒaG ƒv‡CB vv‚h ‡f‚C ˆfaƒGf †[ ƒuG[. ‚S‹cm, ƒv‡z ‰HŠ_ vv‚h ‡f‚C ‚k†ym?",
 202,"‚M, {…B ƒ[ŠQm. ‚Gƒaƒb ˆAd IH‹T‚C ‚Z‚jL „y‚fu¡­¡­ Šom, G ˆJ‚l, [ƒX‚^ƒh ‚G‚PŠiƒP ‚^a^ „C†ym.");
 ModifyForce(202,1);
 PlayWavE(11);
 DrawStrBoxCenter("ˆJ‚lG ‚^a^ „C„kM!");
talk(202,"M„V ƒv‚b „y…X Œ^ Œz{ „}‹a q ‚aƒmL ‰q…f ^†ym.");
 WarAction(16,202);
 SetFlag(41,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(42)) and WarMeet(1,254) then
 WarAction(1,1,254);
 PlayBGM(11);
talk(1,"G‡n, …S‚KƒP †Y„Nƒb G†w FBƒFm. ‰u„CG ƒc…~S „qu†sL „A„AŠW ‡g‚Da‚b „KG ‹om.",
 254,"‚M¡­¡­",
 1,"‚S‹cm, G‡n. ƒv‚h D‡z ‡{S ƒo„E ‹b‚VM.",
 254,"‡{S ƒo‡SMƒdZ? ŠoKLM. ‡g‚Da†yKLM.");
 ModifyForce(254,1);
 PlayWavE(11);
 DrawStrBoxCenter("G‡nG ‚^a^ „C„kM!");
 SetFlag(42,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(43)) and WarMeet(1,255) then
 WarAction(1,1,255);
 PlayBGM(11);
talk(1,"‚Pe, ‡n‚oS ‚P…kB M‡M IƒaƒRD ‚Z‚[ ‡g‚DPm. ƒ[‚_‚b ‡g‚Da†ym?",
 255,"ŒRƒb ˆ|Š[G[. ‡n‚oY‚C ^†iPMA ƒ[^ ‚r†vS ŠUˆf …R u ‚a‚CZ. Šom, ‡g‚Da†ym.");
 ModifyForce(255,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚PeG ‚^a^ „C„kM!");
talk(255,"ƒ[†{ ‰jˆlG ‹[‚q ‡Df ‹b‚VM.");
 WarAction(16,255);
 SetFlag(43,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(1050)) and War.Turn==2 then
talk(1,"Šo‚C ‚k‚wƒv¡­¡­ G‚WfD ƒd‚BG†yM.",
 1,"„h! …fw †u‚wŠm?");
 PlayBGM(12);
 WarShowArmy(54-1);
 WarShowArmy(114-1);
 WarShowArmy(83-1);
 WarShowArmy(126-1);
talk(54,"ƒv‚b v‡SG[, ‚CƒQa…e ŠXm! d‚TƒR, ƒv‚h ‚i‚j‚f!",
 126,"‚K‚J, o_ ‹z„kKLM. ‰bƒU„S ‰jˆlS ‰I†yKLM!",
 1,"[! v‡S, ‚J‚X, GƒL, …y‡r. ‚Z‚[ ŠX‚wƒ`!");
 PlayBGM(9);
 SetFlag(1050,1);
 end
 if (not GetFlag(1051)) and War.Turn==8 then
 SetFlag(161,1);
 SetFlag(1051,1);
 end
 if (not GetFlag(1052)) and (not GetFlag(158)) and War.Turn==13 then
 PlayBGM(11);
talk(54,"…fƒuƒb¡­¡­ ƒLƒP ƒQ‚Tj^?");
 WarShowArmy(197);
 WarShowArmy(198);
 WarShowArmy(253);
 WarShowArmy(254);
talk(198,"‚G‚P‚TG …Xƒlƒ_ ŠXM. d‚TƒR, ‡{S ‚nB „o‡NŠW ‰j„E‚f!",
 199,"„@ƒ_‡I‚V[, …fŠs^ D†WPKLM!",
 254,"¡­¡­G ‰jˆlf I‡H ƒP†w^ „O‚b^.",
 255,"¡­¡­");
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM!");
 WarModifyAI(194,1);
 WarModifyAI(195,1);
 WarModifyAI(199,1);
 WarModifyAI(200,1);
 WarModifyAI(292,1);
 WarModifyAI(256,1);
 WarModifyAI(340,1);
 WarModifyAI(341,1);
 WarModifyAI(274,1);
 PlayBGM(9);
 SetFlag(158,1);
 SetFlag(1052,1);
 end
 if (not GetFlag(158)) and WarCheckArea(-1,3,12,8,19) then
 PlayBGM(11);
talk(54,"…fƒuƒb¡­¡­ ƒLƒP ƒQ‚Tj^?");
 WarShowArmy(197);
 WarShowArmy(198);
 WarShowArmy(253);
 WarShowArmy(254);
talk(198,"‚G‚P‚TG …Xƒlƒ_ ŠXM. d‚TƒR, ‡{S ‚nB „o‡NŠW ‰j„E‚f!",
 199,"„@ƒ_‡I‚V[, …fŠs^ D†WPKLM!",
 254,"¡­¡­G ‰jˆlf I‡H ƒP†w^ „O‚b^.",
 255,"¡­¡­");
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM!");
 WarModifyAI(194,1);
 WarModifyAI(195,1);
 WarModifyAI(292,1);
 WarModifyAI(256,1);
 PlayBGM(9);
 SetFlag(158,1);
 end
 if (not GetFlag(158)) and (not GetFlag(161)) and WarCheckArea(-1,6,20,10,28) then
talk(194,"I‡JG? ƒL …I‚^^ „[†rS „|‚S ƒ{ƒm„S M^ŠXMƒd?",
 196,"‚G‚P G…x^ ‚SŠS ‡O ŠX†M ˆ|j^¡­¡­ ‚M!?");
 WarShowArmy(197);
 WarShowArmy(198);
 WarShowArmy(253);
 WarShowArmy(254);
talk(198,"‚G‚P‚TG …Xƒlƒ_ ŠXM. d‚TƒR, ‡{S ‚nB „o‡NŠW ‰j„E‚f!",
 199,"„@ƒ_‡I‚V[, …fŠs^ D†WPKLM!",
 254,"¡­¡­G ‰jˆlf I‡H ƒP†w^ „O‚b^.",
 255,"¡­¡­");
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM!");
 WarModifyAI(194,1);
 WarModifyAI(195,1);
 WarModifyAI(292,1);
 WarModifyAI(256,1);
 WarModifyAI(199,4,22,4);
 WarModifyAI(253,4,24,6);
 WarModifyAI(254,4,22,6);
 WarModifyAI(197,4,23,7);
 WarModifyAI(198,4,25,7);
 WarModifyAI(274,4,24,4);
 WarModifyAI(340,4,23,4);
 PlayBGM(9);
 SetFlag(158,1);
 end
 if JY.Status==GAME_WARWIN then
talk(1,"ŠoM, ƒ{‚of ƒLG †EƒP ‚aM. d‚TƒR, †M…~f „Yƒ{S ‰Hˆya‚f!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG „Yƒ{S ‡F‚YPM.");
 GetMoney(1200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£²£°£°S …V„kM!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [494]=function()
 SetSceneID(0,3);
talk(126,"‚K‚J, „Yƒ{ƒm„S …wN „UhLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚöÃ³ÇÉÌÌÖ½ñºó>
 NextEvent();
 end,
 [495]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒ{D";
 JY.Base["D‚wC"]=19;
 AddPerson(189,6,7,3);
 AddPerson(24,19,9,1);
 AddPerson(191,9,14,0);
 AddPerson(369,42,26,2);
 SetSceneID(56,11);
 DrawStrBoxCenter("ƒ{D †X‚B");
 MovePerson(369,12,2);
talk(369,"ƒsƒd…w„tLM! ƒOu ‚TG „Yƒ{fƒW „^Q OB ‚KZ ƒaqƒRG ‚Z‚[ ‚B‚rPKLM!",
 189,"I‡JG! ƒaq^ ‚aƒmL ‚SŠSB…E Šo†M ˆ|GŠm?",
 24,"Œiƒ|f d^ ‚G‚P‚h ‡{f ƒRG‚C …X‚V‚f …y‰VŠW n„b„kƒmƒv Š^‚C ‚kƒmŠVKLM. Gd ‡zƒW¡­¡­.",
 189,"‡m¡­¡­ ‚SŠSB…E a‚b^¡­¡­",
 24,"Gd‚b ƒa„SfQ DˆlS ‰RB ‚~ƒ}S ƒsƒ_ ‚G‚PƒP †c…C‚h „QQ a‚b q‹wf ‚aKLM.",
 189,"‡mƒv ƒv‡z ƒa„S‚b ‚_‚_„S ƒQqj…h „ia†y‚b^?",
 24,"ab ƒa„S^ ‚G‚P‚h „_ƒmA ‡{ƒP …Y…AS Œl‚S ‚K†yMƒd d‚oa‚b ƒuhLM. ƒ[uaA ƒa„SD ‚~ƒ}S ƒsƒ_‚C ‚kS q ‚a†y‚CZ.",
 189,"‡m, ƒ[Šl q‹wf ‚a‚wƒv. ‚SƒW ‚r†vS ƒsƒ_‚f! GƒsQ, ‚SƒW MˆQ[Q!",
 369,"k.");
 MovePerson(369,12,3);
 DecPerson(369);
 NextEvent();
 end,
 [496]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="o‚e";
 JY.Base["D‚wC"]=0;
 AddPerson(205,9,16,0);
 AddPerson(206,10,9,3);
 AddPerson(207,12,8,3);
 AddPerson(250,24,16,2);
 AddPerson(25,26,15,2);
 AddPerson(369,19,11,1);
 SetSceneID(52,5);
 DrawStrBoxCenter("o‚e ƒP‚r‰R");
talk(369,"¡­¡­‚rFG G…eaL ƒa„SŠiŠ_ƒW ‚^ƒZ „iB ‚K‡I‚V[.",
 205,"„a†ym. ‹D `‚EB …R ƒhGL ‰q…f ^ƒW ‹]‚V[.",
 369,"„a†yKLM.");
 MovePerson(369,12,0);
 DecPerson(369);
talk(205,"‚SŠSXYZ? ‚GƒafQ ‚S†A ‚|D‚h la‚V†yKLY?",
 206,"k‚Bf ƒOu‡z ‰j‡S …IS ŠkƒmŠVKLY?",
 250,"‚M, ‚Gƒa{ ‚G‚P^ ƒW„S M„eQ oMA „l ƒUŠJ ƒuG ‚a‚C.",
 205,"ƒ[ŠQKLM¡­¡­");
 AddPerson(190,43,-1,1);
 MovePerson(190,12,1);
talk(190,"ƒa„SŠi, ‚GƒaG ‚r†vS ƒsƒ_ ƒQ‚TS ‰RPM‚CZ?",
 205,"ƒ[ŠQm. ‚S‹cQ †CX‚C †Xua‚b ‚eG[.",
 190,"…b‚~aƒNMA ‚^ƒZ …fD ‰HŠ_ ƒvƒWQ B ‚K‡I‚V[.",
 190,"vvfQ OB G‡Ef ƒP…ao …f‚h G‰S…l ˆpgŠW ƒs†ja ‚KŠVƒmL ƒ[ ƒbƒp‚h ‹yƒd…x WLM.",
 205,"‚M¡­¡­ …Xƒ|^ „OƒmL ‚o†dG[. Šom, …b‚~aƒG„S a†ym! …Xƒ|, ƒ[‚_„V ˆ[†ym!",
 190,"[, †~ƒm„S ‡N‚rWLM.");
 JY.Smap={};
 SetSceneID(0);
talk(205,"ŠoM! ƒ[†{ ‡{ƒP }ƒ@f „O‚b ^†_eƒm„S g_a‚f!");
 NextEvent();
 end,
 [497]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="„Y";
 JY.Base["D‚wC"]=20;
 AddPerson(1,9,9,3);
 if not GetFlag(38) then
 AddPerson(133,9,12,3);
 end
 AddPerson(126,15,9,3);
 AddPerson(3,20,9,1);
 AddPerson(170,22,10,1);
 AddPerson(54,9,15,0);
 AddPerson(127,11,16,0);
 SetSceneID(49);
 DrawStrBoxCenter("„Y ƒP‚r‰R");
talk(126,"‚K‚J, „Yƒ{S laƒN ƒuS ƒ@a…w„tLM. ‚r…x^ ŠXKLM.");
 AddPerson(365,41,25,2);
 MovePerson(365,12,2);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [498]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"I‡H …Ij^? G„U I‡H …IG „O†M ˆ|j^?");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"I‡H …Ij‚C ‰cJG ^‚C ‚kKLM. ƒO…m ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"I‡H …IG `‹H†sŠm?");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚K‚J, ‚r…xƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ƒO…m ‚r…xƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚K‚J, ƒO…m ‚r…xƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(365,"‚K‚J, ƒn…IhLM! …S‚K ‡k‹J o‚eƒP ƒa„S^ ‚TS ƒ_‚S ƒOu‚h „Qƒd „OKLM.",
 1,"I‡JG[!",
 365,"ƒa„S‚Tf‚b vvfQ OPŠB ƒW„XƒP …Xƒ|D „OKLM. ƒLG G†w „Yƒ{ ‡k‹JƒP ^†_eS „QƒG ‚VJPKLM!",
 1,"…Xƒ|‚b vv‡z ‰j…[ „U ‡fC‡faŠbM aL „o†_o ƒaqhLM.",
 365,"ƒ[ŠQKLM. ‚K‚J, ‚SŠSXYZ?");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×ö³öÕ÷ÕÅÂ³µÄ×¼±¸£®>
 NextEvent();
 end
 end,
 [499]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…Xƒ|^ ‚_†MaM ƒR„kKLM. ƒnˆEŠi, …A…w‚V …f‚h …hƒ`^‡I‚V[.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚T‚rƒP ƒP†TS ƒA‚Sƒs‚V‚CZ.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚SƒW ‚_‚uS ƒoƒOŒs…E WLM.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‰b ‡{ƒP D‹YS †R †~j…h ‡O ƒ{^ƒN …IG `‹H‚wƒv.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"G‚b ‚GƒaƒP „T‚uhLM. ƒa„S‚h ƒOu †c…Cf ˆn‚SƒRb ‰G‚Jaƒ`‚b ƒuG‚CZ. QM^ …Xƒ|^ „OƒmL ƒOu ‚Tf‚b ‚n‰GhLM. ab ƒa„S‚h ŠGn ‰j„E…E WLM.",
 1,"‚J‚X, …Xƒ|^ Fˆ| ƒ[‰S…l ‚Ia[?",
 126,"ƒ[ŠQKLM. vvD …Xƒ|fQ ‹K„} q…`S …x‚jƒd ‚B†a‚h Œz‚S ŠBƒFM aL ‹B…R q ‚aKLM.",
 1,"‚M¡­¡­ ƒ[†{ ƒQ‚TS ƒsƒ_…E†ym. ‡q…h G‡EfƒW ‚GƒaS ‡fS G‚b †u‚w„S a†ym?",
 126,"ƒ[†{ d^ G‡Ef …g†yKLM. ‚K‚JŠ_ƒW ˆum ‚TS Gˆnƒd ƒa„S‚h C‚_a‡I‚V[. …bFS ƒe‚PB ‚K‡I‚V[.");
 ModifyForce(126,0);
 NextEvent();
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"{…B ŠX‚TZ. „s‚V ‚GƒaG ƒVˆM …I…I ƒuhLM.");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(365,"ƒa„S‚TƒP q^ ƒL‚C ‚kKLM.");
 end
 end,
 [500]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…Xƒ|^ ‚_†MaM ƒR„kKLM. ƒnˆEŠi, …A…w‚V …f‚h …hƒ`^‡I‚V[.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, …bFS ƒe‚Pa‡I‚V[.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"…Xƒ|‚b Ik^ …b‚eaM WLM. ‡mƒv ‚K‚J, …f‚h G†r …x‚b ‚aKLM.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‰b ‡{ƒP D‹YS †R †~j…h ‡O ƒ{^ƒN …IG `‹H‚wƒv.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"‚K‚J, ƒe‚P„CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"‚^‚_‚h FƒfB ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(37,"d3ƒa ^†_eI ‚B„e","1. ƒa„S ‚p…D",30,0,204);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,1,8,4,0,-1,0,
 2,1,9,4,0,-1,0,
 -1,2,7,4,0,-1,0,
 -1,2,9,4,0,-1,0,
 -1,2,10,4,0,-1,0,
 -1,4,7,4,0,-1,0,
 -1,4,8,4,0,-1,0,
 -1,3,8,4,0,-1,0,
 -1,3,9,4,0,-1,0,
 -1,0,7,4,0,-1,0,
 });
 DrawSMap();
talk(126,"ƒ[†{ ƒWŠe…e …b_a…x.");
 JY.Smap={};
 SetSceneID(0,3);
talk(1,"ƒLG ^†_ef „OM WLM. ƒ[†{ ‚SƒW …b_a‚V‚CZ.");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 204,18,9,3,2,45,12,0,0,-1,0,
 205,18,10,3,0,40,6,0,0,-1,0,
 249,17,9,3,0,40,21,0,0,-1,0,
 24,17,6,3,4,39,12,11,3,-1,0,
 22,16,12,3,4,39,6,11,15,-1,0,
 256,17,10,3,0,34,3,0,0,-1,0,
 257,15,7,3,4,34,3,11,3,-1,0,
 258,15,11,3,4,35,3,11,15,-1,0,
 259,16,7,3,4,35,3,11,3,-1,0,
 
 274,17,8,3,4,36,6,11,3,-1,0,
 275,16,11,3,0,35,6,0,0,-1,0,
 276,16,8,3,0,36,6,0,0,-1,0,
 292,16,10,3,4,38,9,11,15,-1,0,
 293,15,9,3,4,39,9,11,15,-1,0,
 189,8,16,2,3,41,9,2,0,-1,1,
 203,8,18,2,1,40,9,0,0,-1,1,
 294,8,15,2,1,39,9,0,0,-1,1,
 295,7,16,2,1,39,9,0,0,-1,1,
 296,9,17,2,1,39,9,0,0,-1,1,
 297,8,19,2,1,39,9,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚K‚J, ƒe‚P‚h ‹s…c‡I‚V[.");
 end
 if JY.Tid==365 then--Ê¹Õß
talk(365,"ƒa„S‚TƒP q^ ƒL‚C ‚kKLM.");
 end
 end,
 [501]=function()
 PlayBGM(11);
talk(205,"…fƒuG ‚G‚P‚TGŠm? ƒ[‚h „_ƒmA …S‚KƒP …Y…AG ƒ_ ƒuG ˆYM. d‚TƒR, ‰B‚pa‚f!",
 1,"ƒa„S‚b †c…C‚h vvfQ †Td‡iaƒd „OƒmL G‡EfƒW ƒAu„QA ‡i‡L…y ˆl„LG‚C ˆfWLM. …x, ƒa„S‚h ^†_efƒW Œ{nƒ_‚V‚CZ!");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [502]=function()
 WarLocationItem(0,14,57,169); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¾ü±¨¸æ
 if (not GetFlag(1053)) and War.Turn==3 then
 WarModifyAI(22,1);
 WarModifyAI(24,1);
 WarModifyAI(257,1);
 WarModifyAI(258,1);
 WarModifyAI(259,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 SetFlag(1053,1);
 end
 if (not GetFlag(170)) and WarCheckArea(-1,1,14,17,17) then
talk(205,"…Xƒ|‚b ‚SŠS n„L [‚C ‚k‚b^? ‚M, …Xƒlƒ_ ŠX‚wƒv.");
 PlayBGM(11);
 WarShowArmy(189);
 WarShowArmy(203);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(297);
 DrawStrBoxCenter("…Xƒ|‚TG ƒv…@ŠgM!");
talk(190,"ƒa„S^ ƒd‚Ba‚b ‚Z†oG‚T. G …Xƒ|ƒP ‹MƒT‚h ‚G‚PfQ „aƒ` ‚K…X! ^…x, ƒv‚h ‚i‚j‚f!",
 1,"„i? …f…x^ …Xƒ|j^? „o†_o ƒaq‚f …SŠW ƒR„kM„V ‚_…r ‚S†A jƒA…IY¡­¡­");
 SetFlag(170,1);
 end
 if WarMeet(3,190) then
 WarAction(1,3,190);
talk(190,"†EƒG „O‚b …x‚b GŠK‚q Iƒaj ‡Ka‚T. ƒv‚b …Xƒ|M, ƒLƒaƒb GŠKS ‚_‚f!",
 3,"ƒv‚b ƒa‚PM! „p^ ƒU„S …Xƒ|Šm?",
 190,"ƒa‚P? ƒR‚S „v ƒL ‚aM. „[ŒA D‚^ƒP GŠK ‚i‚n‚b ƒRƒb ƒU ‚aM.",
 3,"I‡JG?! ‡NŠW I‹~a‚wƒv! ƒ_^ H‚h ƒq†yM!");
 WarAction(6,3,190);
 if fight(3,190)==1 then
talk(3,"G‹@, dˆFG‚wƒv. G…xfQD ‹MƒT^ „OM.",
 190,"dˆF ŠU ‰jƒO‚b‚T. ‡mƒv „oƒa…Iq…l ƒq‚b ŠTG ƒv‚b ˆFG‚C.");
 WarAction(6,3,190);
 WarAction(6,3,190);
 WarAction(10,3,190);
talk(190,"¡­¡­ŠoM, [ƒXƒb bƒGY‚CM. ‚TS †E‰QM!",
 3,"I‡JG? ˆGnƒvƒ`†sŠm?",
 190,"t‚^‚b ‹`ƒS ^u…x!");
 WarLvUp(GetWarID(3));
 WarAction(16,190);
 WarAction(16,203+1);
 WarAction(16,294+1);
 WarAction(16,295+1);
 WarAction(16,296+1);
 WarAction(16,297+1);
 else
talk(3,"G‹@, dˆFG‚wƒv. G…xfQD ‹MƒT^ „OM.",
 190,"dˆF ŠU ‰jƒO‚b‚T. ‡mƒv „oƒa…Iq…l ƒq‚b ŠTG ƒv‚b ˆFG‚C.");
 WarAction(6,3,190);
 WarAction(6,3,190);
 WarAction(10,3,190);
talk(3,"t‚^‚b ‹`ƒS ^u…x!");
 WarAction(16,3);
 WarLvUp(GetWarID(190));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(205,"GƒG‚C ˆfPƒmL ‚TS †E‰QM!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒa„S‚TG ƒA…eŠgM.");
 GetMoney(5000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°£°S …V„kM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [503]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="^†_e";
 JY.Base["D‚wC"]=0;
 AddPerson(1,8,18,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(170,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(127,23,16,2);
 SetSceneID(97,5);
 DrawStrBoxCenter("^†_e g~");
 AddPerson(126,32,6,1);
 MovePerson(126,8,1);
talk(126,"‚K‚J, qƒd ‡AƒmŠVKLM.",
 1,"„i? ‚J‚XG nL[? ‚SŠS bƒGY‚C ŠXm?",
 126,"‚B‚UG …X‚Mf ‚@ƒ` ˆGƒ`ŠXKLM. …Xƒ|ƒP …IS CƒPaƒd…x WLM.");
 ModifyForce(126,1);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÌÖ½ñºó>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [504]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚T‚rŠ_ƒW [ŠVKLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚T‚rŠ_ƒW [ŠVƒmL ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚T‚rŠ_ƒW [ŠVKLM.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚T‚rŠ_ƒW [ŠVKLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚J‚XG ŠX‚wƒ`.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"…Xƒ|‚b ‚m „Gƒb ƒaq‚f ƒR„kKLM.",
 1,"ƒ[ŠQm. ƒLƒm„S „V‚q ƒuG †~ƒm„S n‡Pm.",
 126,"ƒ[ŠQMA d^ ^ƒW ‡g‚DaD…l EƒDa†yKLM.",
 1,"Fˆ|G[! „wa†ym?",
 126,"^ƒMaMƒd ‹bLM. …Xƒ|‚b ƒa„SfQ ˆuS ƒP…aPƒmƒv ƒNRS …V‚C ˆfaƒd „OƒmL, ƒ[ ‡FS G„oaA¡­¡­.",
 1,"„a†ym. ‚J‚X, ƒ{‚JS ‚P[!");
 MovePerson(126,8,0);
 DecPerson(126);
 DrawSMap();
 DrawMulitStrBox("¡¡d‡y„Xƒb …Xƒ|^ oŠt D‚w„S ˆ`Gƒd „O‚MS iŒC‚S ƒsƒd ƒ[‚h EƒDaƒG ‚VJPM.*¡¡‹n‚Mf …Xƒ|‚b ‡g‚Daƒ` a‚C ‚kƒtƒmƒv, gŠa ƒLƒb vv‚f‚b ˆ|f …X‚MG ˆl„LŠbM. …Xƒ|‚b ‚G‚P‚h ‚i‚jƒG„S PM.");
 SetSceneID(97);
 AddPerson(126,32,6,1);
 MovePerson(126,8,1);
talk(126,"‚K‚J, …Xƒ|^ ‡g‚DB ŠXKLM. …Xƒ|, ƒR‚S[‚V[.");
 AddPerson(190,33,7,1);
 AddPerson(204,31,6,1);
 MovePerson( 190,6,1,
 204,6,1);
talk(190,"ƒv‚b …Xƒ|Z. G …Xƒ|‡z FƒP …X‚_, ‰HŠ_ ƒ[‚_ ‚G‚P‚h ˆLƒGƒd…x a[.");
 NextEvent();
 end
 end,
 [505]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"„o†_o ƒaqGL ‚Bƒ}G „^Q ƒX†yKLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"GŠQQ ‚Bƒ}G ‚IB‚CL †~ƒm„S Šoƒb …IhLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"ƒsnaL n„L ŠLƒbG„S‚T. ƒ_^ „l ‚IX ƒuGM.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"ƒvD ‚I…x‚f X „Vaƒv ‚G‚P‚Tf‚b {…B „oƒaG ƒL‚C ‚k‚wƒv.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"…Xƒ|‚b ƒOu ‚TfƒWD …w…Z „o†_o ƒaq^ Š} ƒhGL ‚Bƒ}G „^Q ‚IB†LLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, …Xƒ|^ ‡g‚DB ŠXKLM.");
 end
 if JY.Tid==190 then--Âí³¬
talk(1,"ŠU [ŠVm, …Xƒ|.",
 190,"ƒ[‚_‡z ‰jfŠB …f‚h „oƒWB ‚K‚VL †~ƒm„S ‡N‚rWLM.",
 1,"‹UŠ|„Q …X‚V[. ‚Z‚[ ‚C‚q …IG[. M„V ‹Iƒm„S‚b ‚JS ƒo„E ‚K‚V[.",
 190,"…f‡z …X‚_‚h ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 ModifyForce(190,1);
 ModifyForce(204,1);
 JY.Person[190]["µÀ¾ß1"]=0;
 JY.Person[190]["µÀ¾ß2"]=0;
 JY.Person[204]["µÀ¾ß1"]=0;
 JY.Person[204]["µÀ¾ß2"]=0;
 PlayWavE(11);
 DrawStrBoxCenter("…Xƒ|‡z …X‚_^ ‚^a^ „C„kM!");
talk(190,"‚G‚P ‚K‚J, ˆH„AƒP k„S d^ ^ƒW ‚GƒaS EƒDa†yKLM.",
 1,"‚GƒaS EƒDoMƒd?",
 190,"ƒ[ŠQKLM, dQ ŠEƒG‡I‚V[. ƒa„SD G†w o‚eƒm„S ƒA…eŠgƒd ‚Gƒaƒb „P „Vo ‚^a‚h ŒO„kƒmL …A…w‚V EƒDX q „Oƒmu‚f ‹bLM.",
 1,"‚J‚X, ƒ[‚_‚b ‚SŠS ƒs‚V[?",
 126,"…Xƒ|ƒP ˆ|G ŒRKLM. ‚CƒgGA ‚GƒaS ‰jƒO‚C ‚kƒd ‡g‚D‚V‡Q q „OKLM. M„V Iƒ}ƒm„S †^‚D‚V‰Jƒd…x aŒsD ^ƒMWLM.",
 1,"‚M¡­¡­ ƒ[†{ ‚SŠSXY.");
 NextEvent();
 end
 if JY.Tid==204 then--Âíá·
talk(204,"…f‚b …Xƒ|ƒP ˆj„fƒm„S …X‚_‚f WLM.");
 end
 end,
 [506]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…f‚fA ‰jˆlS …na†yKLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚S†s ‹JS …naN‚C‚b ƒ]‚_„S a‡I‚V[.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"…f‚b ‰jƒOƒd Š]KLM. ‚Tjƒb ‰j„E…E‚CZ.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚K‚JƒP ƒ]S ‚i‚j†yKLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚GƒafQ‚b Gd ‰j…[ „@G ‚aKLM. ‡g‚D‚V‰Jˆe „_ˆe ‚Sƒ`‡S …IG n‚`LM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"…Xƒ|ƒP ˆ|G ŒRKLM. ‚CƒgGA ‚GƒaS ‰jƒO‚C ‚kƒd ‡g‚D‚V‡Q q „OKLM. M„V Iƒ}ƒm„S †^‚D‚V‰Jƒd…x aŒsD ^ƒMWLM.");
 end
 if JY.Tid==190 then--Âí³¬
 if talkYesNo( 190,"†@†daŠVKLY?") then
 RemindSave();
 DrawSMap();
 local menu={
 {"¡¡ …Xƒ|fQ ŠEŒIM",nil,1},
 {"¡¡…Xƒ|fQ ŠEƒG‚C ‚k‚bM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
talk(190,"n! ‡mˆyB ‚K‚VL †~ƒm„S ‡N‚rWLM. ƒ[†{ …fŠs‚b ƒ{D„S ^†yKLM. …X‚_, ^…x.",
 204,"k.");
 MovePerson( 190,6,0,
 204,6,0);
 DecPerson(190);
 DecPerson(204);
 DrawSMap();
 JY.Smap={};
 SetSceneID(0);
talk(126,"ƒ[†{ ‚K‚J, „Yƒ{ƒm„S ‰Bn^‚V‚CZ.");
 JY.Base["ÏÖÔÚµØ"]="„Y";
 DrawMulitStrBox("¡¡…Xƒ|^ ‚GƒaS EƒDa…e ‰tM.*¡¡‚GƒafQ‚b G†w ‰j…[ „@D, „P „Vo ‚^aD ‚a„kM.*¡¡‚Gƒaƒb ‚GˆWS ‰Xaƒd…x …Xƒ|ƒP ‡bƒd‚h …HnƒRb ‡g‚DPM.");
 SetSceneID(0);
talk(190,"‚G‚P ‚K‚J, ƒ@a…w„tLM! ‚GƒaG ‡g‚Df ‚lƒPPKLM.",
 1,"n! †~ƒm„S ŠU‹km.",
 190,"GƒuG ‚GƒaG ‡g‚Do ‰d†EhLM. ^ˆkŠXƒmL …Hn ‚K‡I‚V[.");
 GetItem(1,6);
talk(190,"‚GƒaG ‚Cƒg ƒ{DfƒW ƒGMuƒd „OƒmL ‚SƒW ƒ{D„S ^‚V‚CZ.",
 126,"…Xƒ|, ƒdŠOm. ƒ[†{ ‚K‚J, ‚SƒW ƒ{D„S ^‚V‚CZ.");
 SetSceneID(0,3);
talk(190,"‚GƒaG ƒ{DfƒW ƒGMuL ‚SƒW ^‚V‚CZ.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(512); --goto 512
 elseif r==2 then
talk(190,"ƒ[ŠQKLY¡­¡­ ƒ[†{ …f‚b ‰jˆlƒhfƒW ‚JS ƒoƒO†yKLM.",
 126,"‚GƒaG ƒ{DfƒW ˆNƒ{oM WLM. …bFS ƒe‚Pa‡I‚V[.",
 3,"k. ƒ[†{ ƒnˆEŠi, …fŠs‚b ‰q…f ƒe‚Pa…e ^†yKLM.",
 126,"bƒGƒW ƒe‚PX ƒu ‚aG ‚^ƒ{ƒm„S ^‚V‚CZ.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end
 if JY.Tid==204 then--Âíá·
talk(204,"ƒOu ƒW„X ‚r†vƒb ˆ| ‚nƒP ˆM„Rƒm„S ‚I„RG‚f‚b GˆM„R{ ˆW…Bƒm„S G‚Sˆk „Om.");
 end
 end,
 [507]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚^";
 JY.Base["D‚wC"]=20;
 AddPerson(1,10,17,0);
 AddPerson(126,9,14,0);
 if not GetFlag(38) then
 AddPerson(133,15,17,0);
 end
 AddPerson(190,10,9,3);
 AddPerson(204,24,17,2);
 SetSceneID(83,12);
 DrawStrBoxCenter("‚^ƒ{ ƒP‚r‰R");
talk(126,"‚K‚J, M‡M IƒaƒRƒb G†w …^‚P‚h …X‡RKLM. ‚K‚JŠ_ƒWD ƒe‚Pa‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×ö³öÕ÷³É¶¼µÄ×¼±¸>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [508]=function()
 if JY.Tid==190 then--Âí³¬
talk(190,"‰jˆlƒh‚h †u‚P†B ‚JS ƒoƒO†yKLM.");
 end
 if JY.Tid==204 then--Âíá·
talk(204,"…f‡z …Xƒ|‚h ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚GƒafQ‚b Gd ‰j…[ „@G ‚aƒmL „_‚b …Iƒb ‚SŠq‚C ‚kKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
 WarIni();
 DefineWarMap(34,"d3ƒa ƒ{D ‚B„e","1. ‚Gƒa ‡g‚D",40,0,188);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,26,1,3,0,-1,0,
 -1,24,1,3,0,-1,0,
 -1,25,0,3,0,-1,0,
 -1,25,2,3,0,-1,0,
 -1,25,3,3,0,-1,0,
 -1,26,3,3,0,-1,0,
 -1,27,0,3,0,-1,0,
 -1,27,2,3,0,-1,0,
 -1,27,4,3,0,-1,0,
 });
 DrawSMap();
talk(126,"…bFa†yKLM.");
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"ƒ{D‚b …g‹JƒP ƒn ƒ{hLM. ƒ{D„S g_a‚V‚CZ.");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 188,1,10,4,2,44,3,0,0,-1,0,
 23,11,5,4,2,38,20,0,0,-1,0,
 208,8,16,4,2,36,15,0,0,-1,0,
 34,16,13,4,2,37,17,0,0,-1,0,
 90,18,5,4,2,36,6,0,0,-1,0,
 207,8,15,4,2,37,14,0,0,-1,0,
 190,11,6,4,2,37,3,0,0,-1,0,
 274,2,10,4,0,36,6,0,0,-1,0,
 275,10,4,4,4,36,6,11,4,-1,0,
 276,16,12,4,0,36,6,0,0,-1,0,
 
 292,10,6,4,4,37,9,10,5,-1,0,
 293,15,13,4,0,37,9,0,0,-1,0,
 294,7,14,4,4,37,9,8,14,-1,0,
 295,9,5,4,0,36,9,0,0,-1,0,
 296,7,16,4,0,36,9,0,0,-1,0,
 332,3,9,4,0,34,14,0,0,-1,0,
 333,19,9,4,4,34,14,19,7,-1,0,
 277,6,13,4,4,35,6,7,15,-1,0,
 340,3,11,4,0,36,17,0,0,-1,0,
 341,17,4,4,0,35,17,0,0,-1,0,
 342,21,9,4,0,35,17,0,0,-1,0,
 343,16,14,4,0,36,17,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [509]=function()
 PlayBGM(11);
talk(189,"‚G‚P^ ŠPƒR‚SŠXM! d‚TƒR, ƒv‚h ŠU ‚C‰J‚f.",
 191,"‡m! ‚Gƒaƒb ‹[ƒ_ ƒv‚f‚h ‚C‰J‚C ˆfa‚b‚wƒv!",
 188,"‚G‚PŠi, ƒLgƒP †_ˆGƒb …f‡z ƒa‡pƒP …Yˆjo ŒzhLM. ‚^ƒZ „ND‚h ‹qn ‚wB ‚K‡I‚V[.",
 126,"‚K‚J, ƒLƒb G†w ‰j…[ ƒ]S ŒO„kKLM. G„Q‚h ŠU E‚XaA ƒLƒaD ˆH„AX ƒuhLM.");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [510]=function()
 if (not GetFlag(44)) and WarMeet(1,191) then
 WarAction(1,1,191);
 PlayBGM(11);
talk(191,"‡iƒNG ƒU„S ‚G‚PŠiG‡ILY? …f‚b ƒa‡p{ ˆFFƒP …Yˆjo Œz †_ˆGG‚f WLM. …fD ƒ[ƒR‹n†{ ‡iƒNƒP ‚^a^ „Cƒd…x WLM.");
 ModifyForce(191,1);
 PlayWavE(11);
 DrawStrBoxCenter("†_ˆGG ‚^a^ „C„kM!");
 SetFlag(44,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(45)) and WarMeet(1,24) then
 WarAction(1,1,24);
 PlayBGM(11);
talk(24,"‚GƒaG d ‡tˆAS Š^‚C ‚kn [ƒX G ‚Cƒ@f G‚jŠjKLM. ‚G‚PŠi, …f‚b ‡iƒNG …S‚K‚h ‚wau‚f ˆ[KLM.");
 ModifyForce(24,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚U‡bG ‚^a^ „C„kM!");
 SetFlag(45,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(46)) and WarMeet(1,208) then
 WarAction(1,1,208);
 PlayBGM(11);
talk(208,"‚G‚PŠi, …f‚h ‚^a„S †E‚[‚S ‚K‡I‚V[.");
 ModifyForce(208,1);
 PlayWavE(11);
 DrawStrBoxCenter("‡jƒeG ‚^a^ „C„kM!");
 SetFlag(46,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(47)) and WarMeet(1,91) then
 WarAction(1,1,91);
 PlayBGM(11);
talk(91,"‚G‚PŠi, …f‚b ‡iƒNƒP ‚^a^ „Cƒd…x WLM.");
 ModifyForce(91,1);
 PlayWavE(11);
 DrawStrBoxCenter("[…AG ‚^a^ „C„kM!");
 SetFlag(47,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(48)) and WarMeet(1,209) then
 WarAction(1,1,209);
 PlayBGM(11);
talk(209,"…f‚b G†w ‚GƒafQ ˆ[‚MS ŒO„kKLM. ‚G‚PŠi, …f‚h ‚^a„S †E‚[‚S ‚K‡I‚V[.");
 ModifyForce(209,1);
 PlayWavE(11);
 DrawStrBoxCenter("g‚yG ‚^a^ „C„kM!");
 SetFlag(48,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(49)) and WarMeet(1,35) then
 WarAction(1,1,35);
 PlayBGM(11);
talk(35,"ƒv‚b ‚GƒaG ‡]ƒm„S ƒd„oo ˆuG[. ‡mƒv ‚Gƒaƒb Gd ‡]S „{ q ‚am. ƒ[ŠQMA ‰u„CG …G†sL ƒ[‚_fQ ˆH„Aa†ym.");
 ModifyForce(35,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚r…X^^ ‚^a^ „C„kM!");
 SetFlag(49,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if WarMeet(1,189) then
 WarAction(1,1,189);
talk(189,"‡m¡­¡­ …S‚KƒP IƒaD †eƒ{D ‚Z‚[ ƒv‚h ‹XŠg†M ˆ|j^. a‚b q ‚aM, ‡g‚Da…x¡­¡­.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚GƒaG ‡g‚Daƒd ‚G‚P‚TG ƒ{D‚h ‡F‚YPM.");
 GetMoney(1200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£²£°£°S …V„kM!");
 WarGetExp();
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(189,"‡m¡­¡­ …S‚KƒP IƒaD †eƒ{D ‚Z‚[ ƒv‚h ‹XŠg†M ˆ|j^. a‚b q ‚aM, ‡g‚Da…x¡­¡­.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚GƒaG ‡g‚Daƒd ‚G‚P‚TG ƒ{D‚h ‡F‚YPM.");
 GetMoney(1200);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£²£°£°S …V„kM!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(4,8,70,202); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º·¢Ê¯³µ
 WarLocationItem(17,6,69,203); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º²½±ø³µ
 end,
 [511]=function()
 SetSceneID(0,3);
talk(126,"ƒ[†{ ƒ{D„S ƒR‚S^‚V‚CZ.");
 NextEvent();
 end,
 [512]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒ{D";
 JY.Base["D‚wC"]=19;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 if not GetFlag(38) then
 AddPerson(133,6,11,3);
 end
 AddPerson(3,19,9,1);
 AddPerson(190,23,11,1);
 AddPerson(127,27,13,1);
 AddPerson(54,9,14,0);
 AddPerson(170,13,16,0);
 AddPerson(188,17,18,0);
 AddPerson(189,37,23,2);
 SetSceneID(56,5);
 DrawStrBoxCenter("ƒ{D †X‚B");
 MovePerson(189,11,2);
talk(189,"ƒ[†{ GƒuG …S‚K‚h Mƒ~u‚b ‰d…qj jqZ. …Hn ‚K‚V[.",
 1,"‚M¡­¡­ ‚Gƒa, ƒ_^ Gua‚b ƒuƒb vv‡z ‹[Y‚C ‰j„E oNƒP ‚n‡nS „C†juƒG ‚n‰HG[. ‚^ƒZ ƒv‚h GBB ‚K‚V[.",
 189,"ŠU „a†ym.",
 126,"ƒ[†{ ‚Gƒa, ˆE‚Kf ƒ[‚_^ ŠcƒA ‡ES …XƒxB ‚[„kƒmL ƒ[u„S ^‚V[.",
 189,"„a†yKLM.");
 MovePerson(189,12,3);
talk(1,"Gd‚^ƒh …S‚K‚b G ‚G‚P^ Mƒ~ƒjM. d‚TƒRƒb „l„m „@‰l ƒv‚f‚h ƒo„E ^‚f!");
 PlayBGM(8);
 DrawMulitStrBox("¡¡Guab ‚G‚P‚b …S‚K‚h „y‚CPM.*¡¡…S‚K‡z ˆE‚K‚h ‡Yf †pƒb ‚G‚P‚b ƒvn^ ‚eƒQS D‚Za†B ƒn ƒ]S @‡RM.");
 NextEvent();
 end,
 [513]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d3ƒa¡¡o‚e ‚J„N‚B";
 DrawStrBoxCenter("d3ƒa¡¡o‚e ‚J„N‚B");
 LoadPic(22,1);
 DrawMulitStrBox("¡¡…S‚K‚h …Vƒb ‚G‚Pf ŠGƒWƒd…x vv‚b ‰q…f o‚eS „QƒG„S PM. ‚G‚PƒsM ‹IƒW o‚eS Šf„hn ƒ[‡ES †Z†E‚C„S |n ‚G‚P‚h „Qƒ` o ƒuGM.*¡¡Guab ‚G‚P ‚J‚p „TƒCG N‚]f ‹Z„}ƒFM.");
 LoadPic(22,2);
 NextEvent();
 end,
 [514]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=0;
 AddPerson(383,28,7,1);
 AddPerson(9,29,10,1);
 AddPerson(20,14,9,3);
 AddPerson(103,10,11,3);
 AddPerson(18,25,15,2);
 AddPerson(79,21,17,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("†nƒ{ †X‚B");
talk(9,"ŠDa, …fŠsfQ …b‚pƒP ‚XS ƒ_ƒ` ‚K‡I‚V[.",
 383,"¡­¡­‰cƒb G‚W ‰jˆlS ‡mˆyX q ‚aƒY‚f¡­¡­",
 9,"k? I‚S‚f aŠVKLY?",
 383,"¡­¡­",
 9,"‚G‚P‚b ‡m†gS ƒYuƒd ŠDaƒP ‡tƒNj …f‚h IH„]uƒ` WLM. †JƒLG nLƒd I‡JhLY? Gd ‚TS …Iƒm‰a †JƒLS „Qƒ`‚b…h ‚SŠS ‡h‡ma‚C ‚kƒm‡ILY?",
 383,"‚G‚P‚b ‰cS †Eƒ~‚j‚C ‚k‚bM! ‚G‚P‚b †@ŠH †JƒLG nLM! gŠa †JƒLƒb¡­¡­",
 9,"ŠDa, n„Lƒb „P‚Z^ „Oƒm‡ILM. …f‚h …A‚_a‚b …xƒRfQ †JƒLG‚f‚b [‚XS tƒO‚b …h „P q „O‚CZ. ‡mƒv nG^ Œk‰d ‚q ƒa‚q‡NS ‚SŠS Mƒ^‚b‚C n‡ILY? ‰cJG ^‡ILY?",
 383,"¡­¡­",
 9,"ŠDa, d^ ŠDa‚h Œk‚SaQ „V…w‚b …Iƒb a‚C …X‡I‚V[.",
 383,"¡­¡­ƒ[‚_ ƒ]‚_„S a‚f.",
 9,"aaa!");
 MovePerson(9,1,1);
talk(9,"ƒ[†{ d^ ŠDa‚h ‚_ƒNB ‚B‚Tf …b‚pS ‚Xa†yKLM. v‡_ƒb ‚XS …Hƒm‚f!",
 20,"v‡_, bƒG „OKLM!");
 MovePerson(20,3,3);
 MovePerson(20,0,0);
talk(9,"ƒ[‚_‚h o‚eƒP ‚Kƒaƒm„S |n ‚B‚TS ‚C‚gu aƒd a…C…BS ‚^ƒaƒm„S |‚bM. …A…w‚V †JƒL ‚G‚P‚h ƒq‚S‚f!",
 20,"k! ‚XS …HƒR†yKLM!");
 MovePerson( 20,12,1,
 103,12,1,
 18,12,1,
 79,12,1);
talk(383,"‚U†f¡­¡­ †w‚oa[¡­¡­");
 
 JY.Smap={};
 SetSceneID(0);
talk(20,"ŠoM. o‚efƒW ‚T‚r ‚}ƒP‚h …BM!");
 
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="o‚e";
 JY.Base["D‚wC"]=0;
 AddPerson(20,9,16,0);
 AddPerson(18,10,9,3);
 AddPerson(211,12,8,3);
 AddPerson(210,14,7,3);
 AddPerson(79,24,16,2);
 AddPerson(103,26,15,2);
 AddPerson(252,28,14,2);
 SetSceneID(52);
 DrawStrBoxCenter("o‚e ƒP‚r‰R");
talk(20,"dƒaƒRGb, RI‚h ƒv†u†ym. a…C…Bƒb ‚XS …Hƒm‚f!",
 18,"k!");
 MovePerson(18,3,0);
 MovePerson(18,3,3);
 MovePerson(18,3,1);
talk(20,"a…C…B, ƒ[‚_‚b F‚T„[S ‚C‰J‚f. G „[ƒb ‡{ƒP }ƒ@f „O‚b ‡GƒO ‚eZo ‚T‚r Z‡tGM.",
 18,"„a†yKLM. ƒ[†{ MˆQ[†yKLM.",
 20,"‚M.");
 MovePerson(18,14,0);
talk(20,"a…C‡Vƒb ‚XS …Hƒm‚f!",
 211,"k!");
 MovePerson(211,2,0);
 MovePerson(211,3,3);
 MovePerson(211,3,1);
talk(20,"ƒ[‚_‚b ‚sŒm„[S ‚C‰J‚f. ƒ[‡ED F‚T„[{ …X‡Z^‚C„S }ƒ@ƒP Z‚CM.",
 211,"„a†yKLM!");
 MovePerson(211,14,0);
talk(20,"ƒvŠc‚C‚b k‚P‚_„S G‡Ef …g‚bM. ‚G‚PƒP ‚l†YS ŠU †j‰X†B ˆAdˆe ‰jˆlf ƒvE ƒe‚P‚h a‚f.");
 MovePerson(103,2,0);
 MovePerson(103,3,2);
 MovePerson(103,3,1);
talk(103,"ƒa‚T, ƒOu‚b bƒGƒW ‚B‚U„V ‚C‰aƒs‚b ƒuhLY?",
 20,"ƒ[ŠQKLM.",
 103,"ƒ[ƒuƒb HI mˆpƒLG‚C ‚kKLY?",
 20,"nLM, ‚G‚P‚h ‹B‰}ƒW‚b ‚o ˆYM. bƒGƒW ‚G‚P‚TƒP ‚l†YS †j‰X‚b ƒuGM.",
 103,"¡­¡­ƒ[ŠQMA dQ ‚^‚_‚h aƒv ƒ_‚K‡I‚V[. d^ …m‡WG „C‚S ‚G‚P‚h „Q†yKLM.",
 20,"nL ˆYM! ƒ[uBƒW‚b ‚o ˆYM. ‚eZo ƒuƒb „w„xfƒW Œz‚SƒvQ ˆYM‚b ‡FGM. ‰H‚^„S ˆl„LbƒW‚b ‚o ˆYM.",
 103,"ƒa‚T, ƒ[u ˆ|Š[a‚V‚b ƒuƒb ‚G‚P^ ‚[ƒ`„EƒWhLY?",
 20,"I‡JG! ƒaW, ƒ_ ‹IfƒW I‹~a‚wƒv! ¡­¡­ŠoM, ƒ[u ˆ|oMA ‡mˆya†yM. ‚^‚_‚h aƒv ‚K…X. M„V NOoMA ‚TˆFƒm„S Mƒ~u†yM!",
 103,"aa¡­¡­ ƒ[†{ bƒGƒW ‚G‚PƒP ƒcGƒv ƒGMu‡I‚V[. G„V.");
 MovePerson(103,14,0);
 
 JY.Smap={};
 SetSceneID(0);
talk(18,"…x, F‚T„[ƒm„S g_a‚f!",
 211,"ƒOu‚b ‚sŒm„[ƒm„S …yM! ‚Bga‚f!");
 SetSceneID(0);
talk(103,"…M! ‚G‚PƒP ‚rFƒb k‚B ƒQm sf „OS „U‚^ƒh „aƒd „OM. ‚G‚P‚b ‚[ƒ`…[ ƒuG ‚aM! ƒOu‚b ‡z‚weƒm„S …b‚pB ƒ[‡EfƒW …fƒRS ‚aoM!");
 NextEvent();
 end,
 [515]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒ{D";
 JY.Base["D‚wC"]=19;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 if not GetFlag(38) then
 AddPerson(133,6,11,3);
 end
 AddPerson(3,19,9,1);
 AddPerson(190,23,11,1);
 AddPerson(54,9,14,0);
 AddPerson(170,13,16,0);
 SetSceneID(56,5);
 DrawStrBoxCenter("ƒ{D †X‚B");
talk(126,"‚K‚J, ƒRƒmŠVKLY? vv^ G†w o‚eS ‡F‚YPKLM.",
 1,"‚M. vv^ o‚eS „y‚Co ƒuƒb †@} ‡{S ƒYuƒG „U…ZG[.",
 126,"ƒ[ŠQKLM. {…B ƒ[…ea†B vv‚b G†w ˆl„LŠbKLM¡­¡­ ‚K‚J, ‚r…x^ †[ ‡KWLM.");
 AddPerson(369,37,23,2);
 MovePerson(369,11,2);
talk(369,"‚K‚JŠ_ nŠnLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [516]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"I‡H …Ij^? vv^ ƒOu‚h „Qƒ`‚b ƒuj^?");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ƒO…m ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"„x„LŠW …f‚b vv‚T{ ‹n‚M ‰j„E ƒs‚b‚C‚f o‚W ŒE‚S ƒsƒd Š]KLM.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"k‚Bf …f‚b vv‚TfQ OPKLM. G‚W ‰jˆlfƒW ƒ[ ƒQq‚h ‹yƒd …mˆjƒP oS ‰s†yKLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"…S‚K‚h …Vƒb ‡D ƒOu ‚TƒP ‚rƒG^ ‰EKLM. ‚CƒgG…Eˆ|„S vv‡z ŠGŒES „UhLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒO…m ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==369 then--Îä¹Ù
talk(369,"ƒsƒd…w„tLM. vvƒP ‚^a ƒaWG ‚TS Gˆnƒd ‡z‚weS ƒl‚mPKLM.",
 54,"I‡JG? †[M„lL ƒU„S ŠX†M ˆ|j^?",
 3,"ƒaWG‚fƒdZ? ƒnˆEŠi, …fD ‰HŠ_ ^ƒW ƒ[‚h ˆ{†j ƒ_†yKLM.",
 369,"‰q…f ^†yKLM.");
 MovePerson(369,12,3);
 DecPerson(369);
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×ö³öÕ÷Íß¿Ú¹ØµÄ×¼±¸£®>
 NextEvent();
 end
 end,
 [517]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, dQ ŠEƒG‡I‚V[.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ƒa‚PfQ„V ‚JS „|†r q‚b ‚a‚CZ. …fD ^†yKLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"„x„LŠW …f‚b vv‚T{ ‹n‚M ‰j„E ƒs‚b‚C‚f o‚W ŒE‚S ƒsƒd Š]KLM.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"k‚Bf …f‚b vv‚TfQ OPKLM. G‚W ‰jˆlfƒW ƒ[ ƒQq‚h ‹yƒd …mˆjƒP oS ‰s†yKLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"…S‚K‚h …Vƒb ‡D ƒOu ‚TƒP ‚rƒG^ ‰EKLM. ‚CƒgG…Eˆ|„S vv‡z ŠGŒES „UhLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"…bFa‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"‚~ƒ}{ ƒaq‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(35,"d3ƒa ‡z‚weI ‚B„e","1. ƒaW ‚p…D",40,0,102);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,17,13,3,0,-1,0,
 -1,16,12,3,0,-1,0,
 -1,18,13,3,0,-1,0,
 -1,15,11,3,0,-1,0,
 -1,15,13,3,0,-1,0,
 -1,19,12,3,0,-1,0,
 -1,19,14,3,0,-1,0,
 -1,14,12,3,0,-1,0,
 -1,13,11,3,0,-1,0,
 -1,13,12,3,0,-1,0,
 -1,20,13,3,0,-1,0,
 -1,20,14,3,0,-1,0,
 });
 DrawSMap();
talk(126,"ƒ[†{ ‡z‚weƒm„S g_a†yKLM.");
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"‡z‚weƒb ^†_e ‚l‹Jf „OKLM. ‚SƒW …b_a‚V‚CZ.");
 ModifyForce(103,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 102,16,1,3,0,46,22,0,0,-1,0,
 256,23,17,3,1,40,3,0,0,-1,1,
 257,27,17,3,1,39,3,0,0,-1,1,
 258,15,1,3,0,39,3,0,0,-1,0,
 259,13,1,3,1,40,3,0,0,-1,0,
 260,11,3,3,1,40,3,0,0,-1,0,
 274,20,18,3,1,37,6,0,0,-1,1,
 275,15,16,2,1,36,6,0,0,-1,1,
 276,14,2,3,0,37,6,0,0,-1,0,
 292,7,7,4,1,42,9,0,0,-1,0,
 293,8,6,4,1,42,9,0,0,-1,0,
 294,12,2,3,1,41,9,0,0,-1,0,
 295,25,18,3,1,40,9,0,0,-1,1,
 296,6,8,4,1,41,9,0,0,-1,0,
 332,22,18,3,1,41,14,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [518]=function()
 PlayBGM(11);
talk(103,"ƒG‚SG ŠX‚wƒv, ‚G‚Pb! „p^ †q‚V~~ o‚eS ƒYu‚b „{ „aƒd „O„kM. o_ ‰q…f ƒ_^ „Q†yM. ƒa‚~ƒRGb, ‚G‚P^ ‚SƒZ „O†sŠm. ‚B‚T ‚J‚pa‚f!",
 126,"ƒvŠc‚C ‚^‚_‚b ˆl„LG‚C …X‚f! ‰AƒG „OQ ƒLS ˆn‚SƒRŠbM^ „I‹If ‚ZG†Eˆe ‡G†bQ ŠP‚f! „a†y†sŠm!");
 WarShowTarget(true);
 WarShowArmy(256);
 WarShowArmy(257);
 WarShowArmy(274);
 WarShowArmy(275);
 WarShowArmy(295);
 WarShowArmy(332);
 DrawStrBoxCenter("ƒLƒP ‚D‚~G ƒv…@ŠgM!");
 PlayBGM(19);
 NextEvent();
 end,
 [519]=function()
 if WarMeet(202,103) then
 WarAction(1,202,103);
talk(202,"‚n‚TG ˆNS …Vƒd ‡{Y‚C ƒU‚f‚b‚wƒv. G ˆJ‚lG HŠs‚h IH„]u†yM.",
 103,"†iG „^‚wƒv, ‡NŠW G ƒaW{ „}ƒ^†yMƒd! s†w„O‚T, C‚_B ‚K…X. [H‚f!");
 WarAction(6,202,103);
 if fight(202,103)==1 then
talk(103,"o q, ‚[ q¡­¡­ ‚S‹XŠm?",
 202,"n„L ƒq‚C ˆfP‚wƒv. o ‚W „l ˆjM.");
 WarAction(4,202,103);
talk(103,"…v¡­¡­!",
 103,"G‹@! ‚G‚PƒP ‚Tƒb „V„V„Q ‚k‚wƒv. ‚TS ƒAƒ` ‡z‚weƒm„S ‰Bn^ ƒLS ‡f‚bM.");
 WarLvUp(GetWarID(202));
 WarAction(16,103);
 NextEvent();
 else
talk(103,"o q, ‚[ q¡­¡­ ‚S‹XŠm?",
 202,"n„L ƒq‚C ˆfP‚wƒv. o ‚W „l ˆjM.");
 WarAction(4,103,202);
talk(202,"‚o „C†yM! ‡iB‰M q ‚aM!",
 103,"ƒ[ FD Nƒ}ƒm„S ƒv‚h ƒq†yMƒd? ƒ_ †gS …Hn‚f.");
 WarAction(8,103,202);
talk(202,"ƒm…v!",
 202,"‚_†Ma‚wƒv, ‡iB‰M q ‚aM. ¡­¡­ˆGnƒv…x.");
 WarAction(17,202);
talk(103,"ŠIŠI! ‡{‚Tƒb o „ND ˆf †TƒZ‚b‚T.");
 WarLvUp(GetWarID(103));
 end
 end
 if (not GetFlag(1054)) and War.Turn==3 then
talk(103,"‚G‚P, ‚r„Nƒm„S †a‚n„C„kƒmL Œ_nƒW …GƒG‚h ƒGMƒ`‚f. ƒ_^ „p ƒcS †E‚[†yM! ŠoM! ‚B‚T ‚Bga‚f!");
 WarModifyAI(102,1);
 WarModifyAI(258,1);
 WarModifyAI(276,1);
 SetFlag(1054,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(11);
talk(103,"G‹@! ‚G‚PƒP ‚Tƒb „V„V„Q ‚k‚wƒv. ‚TS ƒAƒ` ‡z‚weƒm„S ‰Bn^ ƒLS ‡f‚bM.");
 NextEvent();
 end
 end,
 [520]=function()
 PlayBGM(7);
talk(126,"‚K‚J, ƒL‚TG ‡z‚weƒm„S ƒA…eŠgKLM. …c‚pa‚V‚CZ!");
bonus_moneyexp_8()
 JY.Status=GAME_WMAP2;
 NextEvent();
 end,
 [521]=function()
change_mode()
 WarIni2();
 DefineWarMap(36,"d3ƒa ‡z‚weII ‚B„e","1. ƒaW ‚p…D",40,0,102);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm2(1,{
 0,23,17,3,0,-1,0,
 -1,23,16,3,0,-1,0,
 -1,21,16,3,0,-1,0,
 -1,21,18,3,0,-1,0,
 -1,24,17,3,0,-1,0,
 -1,24,18,3,0,-1,0,
 -1,20,17,3,0,-1,0,
 -1,20,19,3,0,-1,0,
 -1,22,17,3,0,-1,0,
 -1,25,15,3,0,-1,0,
 -1,25,17,3,0,-1,0,
 -1,26,16,3,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 102,10,2,1,2,48,22,0,0,-1,0,
 129,8,4,1,4,42,3,5,8,-1,0,
 209,12,4,1,4,42,21,12,11,-1,0,
 256,9,2,1,0,41,3,0,0,-1,0,
 257,11,2,1,0,41,3,0,0,-1,0,
 258,8,5,1,4,40,3,4,9,-1,0,
 259,8,3,1,4,38,3,3,10,-1,0,
 260,9,4,1,4,40,3,2,10,-1,0,
 261,12,5,1,4,38,3,11,12,-1,0,
 262,11,4,1,4,39,3,12,12,-1,0,
 263,12,3,1,4,39,3,13,12,-1,0,
 336,10,3,1,0,41,15,0,0,-1,0,
 337,7,4,1,4,40,15,5,10,-1,0,
 338,13,4,1,4,41,15,12,13,-1,0,
 });
 War.Turn=1;
 NextEvent();
WarSave(6)
 end,
 [522]=function()
 PlayBGM(11);
talk(103,"nY‚b d‚_„S ‰jƒO‚C ˆfPƒmƒv G‚W‰` M‚jM. QM^ o‚eƒP v‡_fQ ƒWƒNS ƒsƒ_ ƒQ‚~S ‰RPM. ‚G‚P, ŠPƒR‚S‡z ƒsn‚f!",
 126,"‚K‚J, ‚n‚h ƒs‚VA …fƒuG ‡z‚wehLM. ƒaWS ‡z‚wefƒW Œ{nƒ_…E WLM.");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [523]=function()
 if WarMeet(202,103) then
 WarAction(1,202,103);
talk(202,"‚n‚TG ˆNS …Vƒd ‡{Y‚C ƒU‚f‚b‚wƒv. G ˆJ‚lG HŠs‚h IH„]u†yM.",
 103,"†iG „^‚wƒv, ‡NŠW G ƒaW{ „}ƒ^†yMƒd! s†w„O‚T, C‚_B ‚K…X. [H‚f!");
 WarAction(6,202,103);
 if fight(202,103)==1 then
talk(103,"o q, ‚[ q¡­¡­ ‚S‹XŠm?",
 202,"n„L ƒq‚C ˆfP‚wƒv. o ‚W „l ˆjM.");
 WarAction(4,202,103);
talk(103,"…v¡­¡­!",
 103,"G, G‰S…l ‚G‚P‚TG ‚rƒv…[ „{G…E. …C, …C…Da‚f!");
 WarLvUp(GetWarID(202));
 WarAction(16,103);
 DrawMulitStrBox("¡¡ƒaW‚TG ƒA…eŠgM.");
 NextEvent();
 else
talk(103,"o q, ‚[ q¡­¡­ ‚S‹XŠm?",
 202,"n„L ƒq‚C ˆfP‚wƒv. o ‚W „l ˆjM.");
 WarAction(4,103,202);
talk(202,"‚o „C†yM! ‡iB‰M q ‚aM!",
 103,"ƒ[ FD Nƒ}ƒm„S ƒv‚h ƒq†yMƒd? ƒ_ †gS …Hn‚f.");
 WarAction(8,103,202);
talk(202,"ƒm…v!",
 202,"‚_†Ma‚wƒv, ‡iB‰M q ‚aM. ¡­¡­ˆGnƒv…x.");
 WarAction(17,202);
talk(103,"ŠIŠI! ‡{‚Tƒb o „ND ˆf †TƒZ‚b‚T.");
 WarLvUp(GetWarID(103));
 end
 end
 if (not GetFlag(1055)) and War.Turn==7 then
 PlayBGM(11);
talk(103,"ƒQ‚~G ŠX†sŠm? I‡JG, ƒQ‚~S ƒsƒ_‚C ‚k†yMƒd? ‚SŠSab? ‚KƒaG ‚C‚q‚W MvS ‡a†dƒm„S ƒB„k‚wƒv. n„LD ƒQoS ƒBML! G†GƒW‚b ‰jƒOƒG ‚SŠqM.");
 PlayBGM(19);
 SetFlag(1055,1);
 end
 if JY.Status==GAME_WARWIN then
talk(103,"G, G‰S…l ‚G‚P‚TG ‚rƒv…[ „{G…E. …C, …C…Da‚f!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒaW‚TG ƒA…eŠgM.");
 NextEvent();
 end
 WarLocationItem(11,15,56,171); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÉâÃüÊé
 WarLocationItem(6,3,171,204); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÃÍ»ğÊé ¸ÄÎª Ç¹ÊõÖ¸ÄÏÊé
 end,
 [524]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£³£°£°S …V„kM!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [525]=function()
 SetSceneID(0,3);
talk(126,"ƒaWƒb ƒAu‡Rƒmƒv vv^ „A„AŠW ƒA…eE u ‚aKLM. …A…w‚V ‡O ‚S†A ‚T‚r ‚]‚lf ƒvE ƒuhLM.");
 SetSceneID(0,11);
talk(20,"I‡JG?! ƒaWG ‚G‚PfQ OPMƒd. Œa‚V vvŠiŠ_ ƒsƒda†yM. ƒW‚U, ƒ[‚_‚b …{ŠW ‚sŒm„[ƒm„S ^ a…C‡VfQ Œa‚V ^†_eS „Q‚f ‚Xaƒd, ‚sŒm„[ƒb ƒ[‚_^ ‚_ƒN ‚C‰J‚f.",
 79,"‚XS …HƒR†yKLM. ‰bƒU„S ‚sŒm„[ƒm„S ^†yKLM.");
 SetSceneID(0);
talk(79,"a…C‡V ƒa‚T, v‡_ƒP ‚XhLM. Œa‚V ^†_eS „Q‚f aŠVKLM.",
 211,"‚XS …HƒR†yM. ‚B‚T ^†_eƒm„S g_a‚f.");
 NextEvent();
 end,
 [526]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡z‚we";
 JY.Base["D‚wC"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("‡z‚we g~");
 AddPerson(369,32,6,1);
 MovePerson(369,8,1);
talk(369,"‚G‚PŠi, „Nƒg ^†_efƒW ƒsƒd^ ŠXKLM. vv‚TG ŠPƒR‚S‡z …{ŠW ƒQ‚TS ƒsƒ_ ˆG‚f WLM.",
 54,"vv G…EƒG‚h aL vv^ [‚b‚wƒ`.",
 3,"‡O ŠX‚TZ. n„L f …V‚SŠGƒt†CLY?",
 170,"‚K‚J, ƒ[†{ …bFS ƒe‚Pa‚V‚CZ.");
talk(126,"‚K‚J, „N‚uƒb ŠehLM. aƒv‚b ƒQ‚TS ƒsƒ_‚b ƒuGƒd, aƒv‚b nk F‚T„[S „Q‚b ƒuhLM. ^†_eƒP vv‚Tƒb a…C‡VG ‚C‚gaƒd F‚T„[ƒb a…C…BG ‚CXLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÇëÑ¡ÔñÊÇÏòİçÃÈ¹ØÅÉÔ®¾ü£¬»¹ÊÇ½ø¹¥¶¨¾üÉ½£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [527]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒZ„S ‚~ƒ}S ƒs‰M‚C ‚SƒW Fa‡I‚V[.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"F‚T„[ƒb GŠK ƒ[‚_„S „[ƒo^ …Uo ‚~^„sŠwƒP Z‚ChLM. ‰Hˆyaƒ`A „[‚C ‚B„ef ŠG‚b ‚^‚_‚h ŒA‚f ƒsƒ_Œs…E WLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ‚SƒW Fa‡I‚V[. a…C‡VGˆe a…C…BGˆe d^ ƒcS ƒq‚S ƒU„Q†yKLM.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"k‚Bf d^ ^†_eS ŠP „v ƒU„S‚b ‚C‰JƒG ‡@ƒd „QƒG ‚Sƒ`‡S e…ZhLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"^†_ef‚b a…C‡VG, F‚T„[f‚b a…C…BG „OKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"FaŠVKLY?") then
 RemindSave();
 DrawSMap();
 local menu={
 {"^†_eS ‚CƒQoM",nil,1},
 {"F‚T„[S ˆjM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"„a†yKLM. ƒ[†{ ^†_eS ‚CƒQa†yKLM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --goto 528
 elseif r==2 then
talk(126,"ŠoKLM. ƒ[†{ F‚T„[S „Q†yKLM.");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(79,"I‡JG, ‚G‚P‚TG F‚T„[S „Q…e ‰tMƒd? Œa‚V a…C…BS ‚wƒQa…e ^†yM.");
 SetSceneID(0);
talk(211,"‚SŠS ˆY …IGŠm? ‚G‚P^ ^†_eS ‚wƒQa‚C ‚kƒd Du‚S F‚T„[S ˆjMƒd? ƒ[ƒuG ƒ{‚JaA o‚eG ‚n‚|„BM. ‚B‚T ‚J‚pS z…cƒd …{ŠW ‚sŒm„[ƒm„S ‰Bn^ q‚P‚h I‹u‚f.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(534); --goto 534
 end
 end
 end
 if JY.Tid==369 then--Îä¹Ù
talk(369,"a…C‡VG ^†_e ‹If b…e wƒP ‚D‹Qo gS ‡RKLM. FNf ‚i‚jA ƒ[ ‚of ƒsƒAƒd^ ‡AM WLM.");
 end
 end,
 [528]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(38,"d3ƒa ^†_eII ‚B„e","1. a…C‡V ‚p†U",35,0,210);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,7,9,4,0,-1,0,
 -1,7,8,4,0,-1,0,
 -1,7,10,4,0,-1,0,
 -1,6,7,4,0,-1,0,
 -1,6,9,4,0,-1,0,
 -1,6,11,4,0,-1,0,
 -1,8,6,4,0,-1,0,
 -1,8,8,4,0,-1,0,
 -1,8,10,4,0,-1,0,
 -1,8,12,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 210,33,13,3,2,48,20,0,0,-1,0,
 256,33,12,3,0,43,3,0,0,-1,0,
 257,28,6,3,4,39,3,26,8,-1,0,
 274,32,13,3,0,39,6,0,0,-1,0,
 275,28,5,3,0,43,6,0,0,-1,0,
 276,30,7,3,0,43,6,0,0,-1,0,
 277,29,7,3,4,39,21,27,8,-1,0,
 278,28,12,3,4,41,21,26,12,-1,0,
 279,18,8,3,0,41,6,0,0,-1,0,
 292,32,12,3,0,45,9,0,0,-1,0,
 293,29,6,3,0,45,9,0,0,-1,0,
 294,25,11,3,0,44,9,0,0,-1,0,
 295,21,13,3,4,44,9,19,10,-1,0,
 
 310,27,13,3,4,43,12,25,13,-1,0,
 311,18,9,3,0,42,12,0,0,-1,0,
 280,28,10,3,4,43,21,24,10,-1,0,
 340,21,1,1,1,45,17,0,0,-1,1,
 341,20,18,2,1,44,17,0,0,-1,1,
 336,21,18,2,1,39,15,0,0,-1,1,
 342,24,1,1,1,45,17,0,0,-1,1,
 343,23,18,2,1,44,17,0,0,-1,1,
 337,24,18,2,1,39,15,0,0,-1,1,
 332,27,1,1,1,45,14,0,0,-1,1,
 333,26,18,2,1,44,14,0,0,-1,1,
 338,27,18,2,1,39,15,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [529]=function()
 PlayBGM(11);
talk(211,"‡O ƒQ‚~S ƒs„j†sŠm? ‚_q„B‚C ‚kM. ƒ_^ …fƒRS IH„]u†yM.",
 126,"‚K‚J, g‚p„S …pƒOƒP ‰_S ‚KƒPa‡I‚V[. a…C‡VG ƒ[‡Ef ‚D‚~S ‚[„kS‚C ‚Z‹{LM.");
 WarShowTarget(true);
 SetFlag(902,1); --ÏÄºîµÂ´æ»î£¬Ä¬ÈÏ
 PlayBGM(9);
 NextEvent();
 end,
 [530]=function()
 if (not GetFlag(1056)) and War.Turn==5 then
 WarShowArmy(340);
 WarShowArmy(341);
 WarShowArmy(336);
 DrawStrBoxCenter("ƒLƒP ‚D‚~G ƒv…@ŠgM.");
talk(1,"{…B ‚J‚XƒP kC‚_„SM. ‚Z‚[ ƒl†Waƒd ‡i‚Ua‚C …X‚f. ƒLG o Iu] ƒv[A o Iu] IH„]ƒjM.");
 SetFlag(1056,1);
 end
 if (not GetFlag(1057)) and War.Turn==10 then
 WarShowArmy(342);
 WarShowArmy(343);
 WarShowArmy(337);
 DrawStrBoxCenter("ƒLƒP ‚D‚~G ƒv…@ŠgM.");
talk(1,"‚D‚~G „l „O‚wƒv. a…C‡Vƒb †~ƒm„S „o‚~S n‚b‚T.");
 SetFlag(1057,1);
 end
 if (not GetFlag(1058)) and War.Turn==15 then
 WarShowArmy(332);
 WarShowArmy(333);
 WarShowArmy(338);
 DrawStrBoxCenter("ƒLƒP ‚D‚~G ƒv…@ŠgM.");
talk(1,"‚D‚~G ‡O „O†M ˆ|j^? ‚_…r Œv…Xƒv ‡G‚D‚V‰m ƒuGŠm?");
 SetFlag(1058,1);
 end
 if WarMeet(203,211) then
 WarAction(1,203,211);
talk(203,"[‚b ƒaq^ a…C‡VGŠm? G ‡n‚oG …I‚_…I„S „}ƒ^†yM.",
 211,"G ŠRƒbG^ ‡NŠW ƒOu ˆmS ƒl‚maML, †@ŠH „oƒW„Q ‚k†yM!");
 WarAction(6,203,211);
 if fight(203,211)==1 then
talk(203,"…Hn‚f!");
 WarAction(4,203,211);
talk(211,"ƒmŒF, ƒn…IGM. ‡fn‰M q ‚a‚wƒv.",
 203,"ƒLG …iŒoS ƒsŠbM.");
 WarAction(8,203,211);
talk(211,"n¡­¡­");
 WarAction(18,211);
talk(203,"ƒ_^ ƒLƒa a…C‡VS ƒq„kM.");
 WarLvUp(GetWarID(203));
 PlayBGM(7);
 DrawMulitStrBox("¡¡‡n‚oG a…C‡VS ƒqƒd vv‚TG ƒA…eŠgM.");
 SetFlag(902,0); --ÏÄºîµÂËÀÍö
 NextEvent();
 else
 WarAction(4,211,203);
talk(203,"ƒmŒF, ƒn…IGM. ‡fn‰M q ‚a‚wƒv.");
 WarAction(17,203);
 WarLvUp(GetWarID(211));
 end
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG a…C‡VG Gˆa‚b vv‚TS I‹xŠjM.");
 NextEvent();
 end
 WarLocationItem(5,15,40,53); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºº£Ğ¥Êé
 WarLocationItem(13,20,33,54); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÃ×
 WarLocationItem(5,29,30,55); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÀÏ¾Æ
 WarLocationItem(13,28,25,56); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º½üÎÀîø
 end,
 [531]=function()
 SetFlag(57,1);
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£³£°£°S ƒYƒC.");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [532]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="^†_e";
 JY.Base["D‚wC"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("^†_e g~");
talk(126,"‚K‚J, ƒL‚TS „_‚S ‚rƒG^ [‹{LM. G ƒGƒo‚h …@ †M…~f o‚eS la‚V‚CZ. o‚eƒm„S ^‚b †rf‚b F‚T„[, ‚sŒm„[, oq^ „Oƒm†B ‚Z‚[ ƒLƒaG ‚C‰Jƒd „OKLM.",
 126,"ƒ[†{ F‚T„[S †R‚C ‚sŒm„[S †R‚C ‚K‚JŠ_ƒW ƒd‚j‡I‚V[. F‚T„[ƒb a…C…BG, ‚sŒm„[ƒb ƒW‚UG ‚CXLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÇëÑ¡ÔñÊÇ½ø¹¥¶¨¾üÉ½»¹ÊÇ½ø¹¥Ììµ´É½£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [533]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒZ‚h †R‚C ‚SƒW Fa‡I‚V[.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"F‚T„[{ ‚sŒm„[ƒb ‚Z‚[ …Uƒeo „[GL, „Q‚Vƒ`A „[‚C ‚B„ef ŠG‚b ‚^‚_‚h ŒA‚f ƒsƒ_Œs…E WLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ‚SƒW †@†Ma‡I‚V[. ƒW‚UGˆe a…C…BGˆe d^ ˆ|fƒW ƒq‚S „n‚S„]u†yKLM.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"ƒv‚b ƒW‚U{ „}B „v ƒLG „Om. „V„V„Q ‚kƒb C‚_Z.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚sŒm„[f‚b ƒW‚UG, F‚T„[f‚b a…C…BG „OKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"‚S†s ‹JS „QN‚C FaŠVKLY?") then
 RemindSave();
 DrawSMap();
 local menu={
 {"F‚T„[S ˆjM",nil,1},
 {"‚sŒm„[S ˆjM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"‚XS …HxLM. ƒ[†{ F‚T„[S Š~LM.");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(79,"‡{‚TG F‚T„[S ˆjM. ‚SƒW a…C…BS ‚CƒQa…e ^‚f.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --goto 534
 elseif r==2 then
talk(126,"‚XS …HxLM. ƒ[†{ ‚sŒm„[S Š~LM.");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(18,"‡{‚TG ‚sŒm„[S ˆjM. ‚SƒW ƒW‚US ‚CƒQa…e ^‚f.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(547); --goto 547
 end
 end
 end
 end,
 [534]=function()
 SetSceneID(0);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(39,"d3ƒa F‚T„[ ‚B„e","1. a…C…B ‚p†U",35,0,17);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,6,16,2,0,-1,0,
 -1,5,15,2,0,-1,0,
 -1,7,15,2,0,-1,0,
 -1,7,17,2,0,-1,0,
 -1,6,17,2,0,-1,0,
 -1,5,17,2,0,-1,0,
 -1,5,16,2,0,-1,0,
 -1,9,15,2,0,-1,0,
 -1,8,16,2,0,-1,0,
 -1,9,17,2,0,-1,0,
 -1,4,14,2,0,-1,0,
 -1,4,15,2,0,-1,0,
 -1,4,17,2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 17,30,0,1,4,50,22,33,12,-1,0,
 102,34,1,1,4,49,22,27,14,-1,0,
 209,33,3,1,4,48,21,25,12,-1,0,
 36,14,7,3,0,42,12,0,0,-1,0,
 256,15,6,3,0,41,3,0,0,-1,0,
 257,35,4,1,4,41,3,25,14,-1,0,
 292,16,7,3,0,45,9,0,0,-1,0,
 293,33,1,1,4,45,9,30,8,-1,0,
 294,37,0,1,4,44,9,29,7,-1,0,
 295,32,0,1,4,44,9,31,13,-1,0,
 274,15,8,3,0,39,6,0,0,-1,0,
 340,35,2,1,4,40,17,28,8,-1,0,
 341,34,2,1,4,40,17,29,9,-1,0,
 342,36,1,1,4,40,17,26,13,-1,0,
 
 336,36,3,1,4,43,15,30,15,-1,0,
 299,34,0,1,4,44,9,32,9,-1,0,
 300,31,1,1,4,44,9,29,14,-1,0,
 301,32,3,1,4,45,9,24,14,-1,0,
 78,1,6,4,3,49,9,0,0,-1,1,
 251,4,7,4,1,42,3,0,0,-1,1,
 296,4,5,4,1,45,9,0,0,-1,1,
 297,2,7,4,1,44,9,0,0,-1,1,
 298,0,7,4,1,44,9,0,0,-1,1,
 258,2,5,4,1,39,3,0,0,-1,1,
 275,3,6,4,1,39,6,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [535]=function()
 PlayBGM(11);
talk(18,"‚G‚P^ o‚eS Šf„hQ Še q ‚aM. †[ „@S MB ‚G‚PƒP ‚J‚pS ‡fn‚f.");
 WarShowTarget(true);
 SetFlag(901,1); --ÏÄºîÔ¨´æ»î£¬Ä¬ÈÏ
 PlayBGM(9);
 NextEvent();
 end,
 [536]=function()
 if WarMeet(170,18) then
 WarAction(1,170,18);
talk(170,"[‚b ƒaq‚b a…C…Bj ‡Ka‚T. G ‚U‡tG …I‚_…I„S ‹[ƒaƒ_ ‚K…X!",
 18,"G ‡{ƒP D„]ƒGƒRG ‡NŠW ƒOu ‚I‰S‚h ‚maML, ƒ_ ‚_D‚h …Hn‚f!",
 170,"G ‚U‡tƒP ‹Fƒb n„L …]…j‚C ‚kƒtM. H‚b ƒ_ ‹F n†G ˆHƒNG „C‚S‚f.");
 WarAction(6,170,18);
 if fight(170,18)==1 then
talk(170,"G ‹FS …Hn‚f!");
 WarAction(8,170,18);
talk(18,"ƒn…IGM! ƒmŒF¡­¡­");
 WarAction(18,18);
talk(170,"ƒ_^ ƒLƒa a…C…BS ƒq„kM.");
 WarLvUp(GetWarID(170));
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚U‡tG a…C…BS ƒqƒd,*¡¡‚G‚P‚TG F‚T„[S ‡F‚YPM.");
 SetFlag(901,0); --ÏÄºîÔ¨ËÀÍö
 NextEvent();
 else
 WarAction(4,18,170);
talk(170,"ƒn…IGM! ƒmŒF¡­¡­");
 WarAction(17,170);
 WarLvUp(GetWarID(18));
 end
 end
 if (not GetFlag(1059)) and War.Turn==8 then
talk(1,"‚M, G ‚~‚rƒRƒb¡­¡­?");
 PlayBGM(11);
 WarModifyAI(17,3,0);
 WarModifyAI(102,3,0);
 WarModifyAI(209,3,0);
 WarModifyAI(36,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(295,1);
 WarModifyAI(274,1);
 WarModifyAI(340,1);
 WarModifyAI(341,1);
 WarModifyAI(342,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(336,1);
 WarModifyAI(299,1);
 WarModifyAI(300,1);
 WarModifyAI(301,1);
 WarShowArmy(78);
 WarShowArmy(251);
 WarShowArmy(296);
 WarShowArmy(297);
 WarShowArmy(298);
 WarShowArmy(258);
 WarShowArmy(275);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM.");
talk(79,"a…C…B ƒa‚T, d^ D‡z ‚G‚P‚h F‚T„[fƒW Œ{nƒ_†yKLM.",
 252,"¡­¡­",
 18,"[, ƒW‚UG ŠX‚wƒv. ŠoM, ‚B‚T ‚G‚P‚TS †YB ‰B‚pa‚f! ƒOu ‚TG ‚G‚P‚TS ‰G‚JoM.");
 PlayBGM(9);
 SetFlag(1059,1);
 end
 if (not GetFlag(134)) and WarMeet(1,252) then
 WarAction(1,1,252);
 PlayBGM(11);
talk(252,"‚G‚PŠi, ‚G‚P‚Tf ‡g‚Daƒd…x a[L ‚^ƒZ †E‚[‚S ‚K‡I‚V[.");
 ModifyForce(252,1);
 PlayWavE(11);
 DrawStrBoxCenter("‡eƒwG ‰BnŒUM.");
 SetFlag(134,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG F‚T„[S ‡F‚YPM.");
 NextEvent();
 end
 if (not GetFlag(206)) and WarCheckLocation(-1,12,14) then
 GetMoney(800);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £¸£°£°S …V„kM.");
 SetFlag(206,1);
 end
 WarLocationItem(3,21,2,205); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÇàÄÒÊé
 WarLocationItem(4,23,151,207); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÉ½ºéÊé ¸ÄÎª 151ÎŞµĞÉñÅÆ
 end,
 [537]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£³£°£°S ƒYƒC.");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [538]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"Gd oq„V wHA o‚eS „y‚CX q „Om„V¡­¡­.");
 SetSceneID(0,11);
talk(9,"‚G‚P G Œi‡pG^ ƒ_^ ‚a‚b Œof o‚eS ƒGKaML, †@ŠH „oƒW„Q ‚k†yM!",
 212,"n„qŠi, d^ ‰I†yKLM.",
 9,"[, v†g. ƒLG oq‚h „Q†Eˆe ƒ[u„S ^ ‚CƒQa‚f. ƒv‚b †oƒwefƒW ƒLƒP ‚l‚|‚h †j‰X†yM.",
 212,"k.");
 NextEvent();
 end,
 [539]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="F‚T„[";
 JY.Base["D‚wC"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("F‚T„[ g~");
 if GetFlag(57) then
talk(126,"ƒ[†{ oq‚h „Q‚V‚CZ. oq ‚J‚pS ƒe‚PB ‚K‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×ö½ø¹¥ººË®µÄ×¼±¸£®>
 else
talk(126,"ƒ[†{ ‚sŒm„[S †R‚C oq‚h †R‚C ‚K‚JŠ_ƒW Fa‡I‚V[. oq‚b v‡_G, ‚sŒm„[ƒb a…C‡VG ‚CXLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Çë¾ö¶¨ÊÇ½ø¹¥Ììµ´É½£¬»¹ÊÇ½ø¹¥ººË®£®>
 end
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [540]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW …bFa‚V‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"oq‚b ƒn ‚IG ‚N‚j‚b ƒwƒQG‚f aL ƒG‚lƒ} „O‚b ‚^‚_‚h ‚Zƒm‚b ƒuG Šo†yKLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ‚SƒW …b_a‚V‚CZ.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"ƒv‚b v‡_{ ŒZ „y‹~ „}B ƒsƒtm. ƒ[…x‚b ƒ{†w^ ‚r‹_m.");
 end
 if JY.Tid==133 then--ÅÓÍ³
 if GetFlag(57) then
talk(133,"oq‚b v‡_G ‚CXLM.");
 else
talk(133,"oqf‚b v‡_G, ‚sŒm„[f‚b a…C‡VG ‚C‰Jƒd „OKLM.");
 end
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 DrawSMap();
 local menu={
 {"‚sŒm„[S ˆjM",nil,1},
 {" oq‚h ˆjM",nil,1}
 }
 if GetFlag(57) then
talk(126,"ƒ[†{ oq‚h „Q†yKLM.");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(212,"I‡JG, ‚G‚P^ oq‚h ˆjMƒd? ‚SƒW ƒ[u„S ‚CƒQa…e ^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(554); --goto 554
 else
talk(126,"‚SƒZ‚h †R‚C ŒA‚f ‚K‡I‚V[.");
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"„a†yKLM. ƒ[†{ ‚sŒm„[ƒm„S g_a†yKLM.");
 JY.Smap={};
 SetSceneID(0,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --goto 541
 elseif r==2 then
talk(126,"k, oq‚h Š~LM.");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(212,"I‡JG, ‚G‚P^ oq‚h ˆjMƒd? ‚SƒW ƒ[u„S ‚CƒQa…e ^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(554); --goto 554
 end
 end
 end
 end
 end,
 [541]=function()
 SetSceneID(0);
talk(126,"‚_‚AS ‹s…c‡I‚V[.");
 WarIni();
 DefineWarMap(40,"d3ƒa ‚sŒm„[I ‚B„e","1. a…C‡V ˆL†U",40,0,210);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,4,5,4,0,-1,0,
 -1,5,4,4,0,-1,0,
 -1,5,6,4,0,-1,0,
 -1,5,8,4,0,-1,0,
 -1,3,4,4,0,-1,0,
 -1,3,5,4,0,-1,0,
 -1,3,6,4,0,-1,0,
 -1,3,8,4,0,-1,0,
 -1,6,5,4,0,-1,0,
 -1,6,7,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 210,33,7,3,1,52,20,0,0,-1,0,
 256,33,6,3,1,48,3,0,0,-1,0,
 257,20,13,3,1,44,3,0,0,-1,0,
 274,31,5,3,1,48,6,0,0,-1,0,
 275,23,7,3,1,45,6,0,0,-1,0,
 296,21,5,3,1,48,9,0,0,-1,0,
 297,19,12,3,1,46,9,0,0,-1,0,
 298,20,11,3,1,46,9,0,0,-1,0,
 299,21,14,3,1,45,9,0,0,-1,0,
 292,21,12,3,1,45,9,0,0,-1,0,
 293,22,6,3,1,45,6,0,0,-1,0,
 294,30,6,3,1,48,9,0,0,-1,0,
 295,32,7,3,1,45,9,0,0,-1,0,
 310,31,7,3,1,40,12,0,0,-1,0,
 311,23,5,3,1,43,12,0,0,-1,0,
 300,22,13,3,1,45,9,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [542]=function()
 PlayBGM(11);
talk(211,"‚sŒm„[S ƒLfQ Šf„hƒGA ƒOu ‚T„XG cŒIM! I‡H …IG „O‚SD ‚sŒm„[S ‚C‰a…E oM!",
 1,"ƒLƒP ‚~ƒ}G ‡A‚C ‚kM! †M…~f Œ{nŠP ‰Hˆya‚f!");
 WarShowTarget(true);
 SetFlag(902,1); --ÏÄºîµÂ´æ»î£¬Ä¬ÈÏ
 PlayBGM(9);
 NextEvent();
 end,
 [543]=function()
 if WarMeet(203,211) then
 WarAction(1,203,211);
talk(203,"a…C‡V, G ‡n‚oG …I‚_…I„S „}ƒ^†yM!",
 211,"G ŠRƒbG^ ‡NŠW ƒOu ˆmS ƒl‚maML! ŠP‚f!!");
 WarAction(6,203,211);
 if fight(203,211)==1 then
talk(203,"ŠP‚f!");
 WarAction(4,203,211);
talk(211,"ƒm, ƒmŒF¡­¡­! ƒn¡­¡­ …IGM!",
 203,"ƒc…~S ƒ_‹^n‚f!");
 WarAction(8,203,211);
talk(211,"…v¡­¡­!");
 WarAction(18,211);
talk(203,"ƒLƒa a…C‡V, G ‡n‚oG ƒq„kM!!");
 WarLvUp(GetWarID(203));
 PlayBGM(7);
 DrawMulitStrBox("¡¡‡n‚oG a…C‡VS ƒqƒd vv‚TG ƒA…eŠgM.");
 SetFlag(902,0); --ÏÄºîµÂËÀÍö
 NextEvent();
 else
 WarAction(4,211,203);
talk(203,"ƒm, ƒmŒF¡­¡­! ƒn¡­¡­ …IGM!");
 WarAction(17,203);
 WarLvUp(GetWarID(211));
 end
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG a…C‡VG Gˆa‚b vv‚TS I‹xŠjM.");
 NextEvent();
 end
 WarLocationItem(8,31,54,174); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÖĞÒ©
 end,
 [544]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£³£°£°S …V„kM!");
bonus_moneyexp_4()
 SetFlag(57,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [545]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚sŒm„[";
 JY.Base["D‚wC"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("‚sŒm„[ g~");
talk(126,"oq„V wHA o‚ehLM. oq„S g‚Ta†yKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×¼±¸½ø¾üººË®£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [546]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW …b‚~a‚V‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"oq‚b ƒn ‚IG ‚N‚j‚b ƒwƒQG‚f aL ƒG‚lƒ} „O‚b ‚^‚_‚h ‚Zƒm‚b ƒuG Šo†yKLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ‚SƒW …b‚~a‚V‚CZ.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"ƒv‚b v‡_{ ŒZ „y‹~ „}B ƒsƒtm. ƒ[…x‚b ƒ{†w^ ‚r‹_m.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"oq‚b v‡_G ‚CXLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 DrawSMap();
talk(126,"…b_a‚V‚CZ.");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(212,"I‡JG, ‚G‚P‚TG oqf G‚jŠjMƒd? Œa‚V oq„S …yM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(554); --goto 554
 end
 end
 end,
 [547]=function()
 SetSceneID(0);
talk(126,"‚_‚AS ‹s…c‚S ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(40,"d3ƒa ‚sŒm„[II ‚B„e","1. ƒW‚U ‚p…D",40,0,78);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,4,5,4,0,-1,0,
 -1,5,4,4,0,-1,0,
 -1,5,6,4,0,-1,0,
 -1,5,8,4,0,-1,0,
 -1,3,4,4,0,-1,0,
 -1,3,5,4,0,-1,0,
 -1,3,6,4,0,-1,0,
 -1,3,8,4,0,-1,0,
 -1,6,5,4,0,-1,0,
 -1,6,7,4,0,-1,0,
 -1,2,5,4,0,-1,0,
 -1,4,3,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 78,33,7,3,2,52,9,0,0,-1,0,
 251,21,12,3,4,45,3,19,12,-1,0,
 295,19,12,3,1,46,9,0,0,-1,0,
 296,20,11,3,1,46,9,0,0,-1,0,
 297,29,5,3,4,45,9,23,6,-1,0,
 298,30,6,3,0,45,9,0,0,-1,0,
 292,23,7,3,4,46,9,20,11,-1,0,
 293,22,13,3,4,46,9,20,14,-1,0,
 294,20,13,3,1,46,9,0,0,-1,0,
 256,21,14,3,1,43,3,0,0,-1,0,
 257,32,7,3,0,42,3,0,0,-1,0,
 310,21,5,3,4,41,12,19,11,-1,0,
 311,22,6,3,4,40,12,19,13,-1,0,
 336,31,7,3,0,41,15,0,0,-1,0,
 337,29,7,3,4,40,15,23,7,-1,0,
 
 332,23,5,3,0,46,14,0,0,-1,0,
 274,31,5,3,0,45,6,0,0,-1,0,
 275,33,6,3,0,44,6,0,0,-1,0,
 17,29,18,3,1,50,22,0,0,-1,1,
 102,28,19,3,1,48,22,0,0,-1,1,
 209,27,17,3,1,48,21,0,0,-1,1,
 36,16,1,1,1,42,12,0,0,-1,1,
 258,17,0,1,1,43,3,0,0,-1,1,
 259,28,17,3,1,42,3,0,0,-1,1,
 299,30,19,3,1,46,9,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [548]=function()
 PlayBGM(11);
talk(79,"G‡ES ‚C‰J‚C ˆfaA o‚eD ŒO‚bM! ƒa‚~ƒRGb, I‡H …IG „O‚SD G ‚sŒm„[S ‚C‰a‚f!");
 WarShowTarget(true);
 SetFlag(901,1); --ÏÄºîÔ¨´æ»î,Ä¬ÈÏ
 PlayBGM(9);
 NextEvent();
 end,
 [549]=function()
 WarLocationItem(8,31,54,175); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÖĞÒ©
 if (not GetFlag(134)) and WarMeet(1,252) then
 WarAction(1,1,252);
 PlayBGM(11);
talk(252,"‚G‚U†f, …f‚b ƒW‚UƒP †wˆlS ‚r ‚G‚U†fŠ_ ‡g‚Daƒd…x WLM. ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 ModifyForce(252,1);
 PlayWavE(11);
 DrawStrBoxCenter("‡eƒwG G‹Jƒm„S ‰BnŒUM!");
 SetFlag(134,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(1060)) and War.Turn==8 then
talk(1,"‚M! …fƒuƒb E…X?");
 PlayBGM(11);
 WarShowArmy(17);
 WarShowArmy(102);
 WarShowArmy(209);
 WarShowArmy(36);
 WarShowArmy(258);
 WarShowArmy(259);
 WarShowArmy(299);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM!");
talk(18,"ƒW‚US ‚wa‚f! ‚G‚P‚TS ‚sŒm„[fƒW Œ{nƒ_‚f!",
 103,"nY‚b aƒXG D‡z HŠs^ s†w‚h ƒsƒtM„V G‚W‰` M‚jM! ‚G‚P‚T, …GS ƒe‚Pƒv B‚f!",
 79,"[! a…C…BGM! ŠoM, …b‚pX „U^ ŠXM!! ‚B‚T, ‚G‚P‚TS †YB ‰B‚pa‚f!!");
 WarModifyAI(78,3,0);
 WarModifyAI(251,1,0);
 WarModifyAI(292,3,0);
 WarModifyAI(293,1);
 WarModifyAI(295,1);
 WarModifyAI(296,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 WarModifyAI(336,1);
 WarModifyAI(337,1);
 WarModifyAI(332,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(257,1);
 PlayBGM(9);
 SetFlag(1060,1);
 end
 if WarMeet(170,18) then
 WarAction(1,170,18);
talk(170,"GƒsQ, a…C…B! G ‚U‡tG …I‚_…I„S „}ƒ^†yM!!",
 18,"G D„]ƒGƒRG ‡NŠW ƒOu ˆmS Šf„hƒm…e [ML! ‚SŠS „oƒWa†y†sŠm!",
 170,"aa, G ‚U‡tG ŠR„kM aƒv H „Gƒb ‹A†DŠYfQ ‹T FD‚b nLM.");
 WarAction(6,170,18);
 if fight(170,18)==1 then
talk(170,"‹FS …Hn‚f!");
 WarAction(8,170,18);
talk(18,"…v¡­¡­!!");
 WarAction(18,18);
talk(170,"ƒ_^ ƒLƒa a…C…BS ƒq„kM!");
 WarLvUp(GetWarID(170));
 SetFlag(901,0); --ÏÄºîÔ¨ËÀÍö
 else
 WarAction(4,18,170);
talk(170,"ƒn…IGM! ƒmŒF¡­¡­");
 WarAction(17,170);
 WarLvUp(GetWarID(18));
 end
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG ‚sŒm„[S ‡F‚YPM.");
 NextEvent();
 end
 end,
 [550]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£³£°£°S …V„kM!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [551]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"Gd oq„V wHA o‚eS „y‚CX q „Om„V¡­¡­.");
 SetSceneID(0,11);
talk(9,"‚G‚P G Œi‡pG^ ƒ_^ ‚a‚b Œof o‚eS ƒGKaML, †@ŠH „oƒW„Q ‚k†yM!",
 212,"n„qŠi, d^ ‰I†yKLM.",
 9,"[, v†g. ƒLG oq‚h „Q†Eˆe ƒ[u„S ^ ‚CƒQa‚f. ƒv‚b †oƒwefƒW ƒLƒP ‚l‚|‚h †j‰X†yM.",
 212,"k.");
 NextEvent();
 end,
 [552]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚sŒm„[";
 JY.Base["D‚wC"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("‚sŒm„[ g~");
talk(126,"vv^ …Xƒlƒ_ ƒvŒUKLM. ƒ[†{ ‚K‚J, oq‚h „Q‚V‚CZ. oq‚b v‡_G ‚CXLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×¼±¸½ø¾üººË®£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [553]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW …bFa‚V‚CZ.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"oq‚b ƒn ‚IG ‚N‚j‚b ƒwƒQG‚f aL ƒG‚lƒ} „O‚b ‚^‚_‚h ‚Zƒm‚b ƒuG Šo†yKLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ‚SƒW …b_a‚V‚CZ.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"ƒv‚b v‡_{ ŒZ „y‹~ „}B ƒsƒtm. ƒ[…x‚b ƒ{†w^ ‚r‹_m.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"oq‚b v‡_G ‚CXLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 DrawSMap();
talk(126,"…b_a‚V‚CZ.");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(212,"I‡JG, ‚G‚P^ oq‚h ˆjMƒd? ‚SƒW ƒ[u„S ‚CƒQa…e ^…x.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [554]=function()
 SetSceneID(0);
talk(126,"‚_‚AS ‹s…c‚S ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(41,"d3ƒa oq ‚B„e","1. v‡_ ‚p…D",40,0,19);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,14,22,4,0,-1,0,
 -1,2,16,4,0,-1,0,
 -1,16,19,4,0,-1,0,
 -1,2,13,4,0,-1,0,
 -1,14,20,4,0,-1,0,
 -1,3,14,4,0,-1,0,
 -1,13,21,4,0,-1,0,
 -1,2,15,4,0,-1,0,
 -1,15,21,4,0,-1,0,
 -1,1,16,4,0,-1,0,
 -1,16,21,4,0,-1,0,
 -1,3,17,4,0,-1,0,
 -1,13,23,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 19,28,1,3,0,54,25,0,0,-1,0,
 17,27,3,3,0,52,22,0,0,901,0,--ÏÄºîÔ¨
 210,30,3,3,0,52,20,0,0,902,0,--ÏÄºîµÂ
 256,10,9,3,4,47,3,8,8,-1,0,
 257,23,13,3,4,43,3,21,15,-1,0,
 258,21,11,3,4,43,3,21,14,-1,0,
 259,26,10,3,0,46,3,0,0,-1,0,
 260,28,4,3,0,42,3,0,0,-1,0,
 292,11,9,3,4,50,9,9,9,-1,0,
 293,23,12,3,4,47,9,22,14,-1,0,
 294,25,9,3,0,47,9,0,0,-1,0,
 295,16,1,3,0,50,9,0,0,-1,0,
 274,9,8,3,4,47,6,8,9,-1,0,
 275,24,14,3,4,43,6,20,15,-1,0,
 276,21,12,3,4,43,6,20,14,-1,0,
 277,24,9,3,0,46,6,0,0,-1,0,
 
 301,15,0,3,0,46,9,0,0,-1,0,
 302,23,1,3,0,46,9,0,0,-1,0,
 278,12,11,3,4,50,6,9,10,-1,0,
 279,17,13,4,4,50,6,19,13,-1,0,
 348,13,10,3,4,43,19,10,9,-1,0,
 349,16,14,4,4,42,19,19,14,-1,0,
 211,29,1,3,0,53,22,0,0,-1,1,
 261,26,2,3,0,46,3,0,0,-1,1,
 280,27,4,3,0,45,6,0,0,-1,1,
 296,29,4,3,0,50,9,0,0,-1,1,
 297,29,3,3,0,47,9,0,0,-1,1,
 298,28,2,3,0,50,9,0,0,-1,1,
 299,27,1,3,0,47,9,0,0,-1,1,
 300,24,2,3,0,47,9,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [555]=function()
 PlayBGM(11);
talk(20,"G‡EfƒW ‚G‚P‚TS ‡fn‚f. „Vf aƒv G‡EG ŒCuA o‚eG ‚n‚|„BM! dƒaƒRƒb …A…w‚V G‡ES ‚rqa‚f!");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [556]=function()
 if WarMeet(201,212) then
 WarAction(1,201,212);
talk(201,"ƒv‚b ‡{ƒP ƒaq [‚dGM! †u^ ƒv‡z „}ƒ^†y†sŠm?",
 201,"„p^ ƒv‚h G†r ƒ{Š]ƒmŠm? …yM.");
 WarAction(6,201,212);
 if fight(201,212)==1 then
talk(201,"Gƒuƒb¡­¡­",
 212,"‚SŠS ˆY ƒuGŠm, ‰j…[ ƒ]G ‚a†sŠm? ƒ[ŠQMA G v†gG ƒq‚C‚b ‚k†yM.",
 201,"„p^ v†gGŠm? ƒ[ŠQMA vvƒP nƒRGŠ@M?",
 212,"ƒ[ŠQM.",
 201,"¡­¡­ŠoM, „p ƒcS ƒq‚S ‚JS ƒoƒO†yM! v†g, …Hn‚f!");
 WarAction(8,201,212);
talk(212,"ƒmŒF¡­¡­");
 WarAction(17,212);
talk(201,"…M, HI ‡@Q G‹H‚T. ƒv‡z „}‹a …x^ ‡O ‚a†sŠm?");
 WarLvUp(GetWarID(201));
 else
talk(201,"Gƒuƒb¡­¡­",
 212,"‚SŠS ˆY ƒuGŠm, ‰j…[ ƒ]G ‚a†sŠm? ƒ[ŠQMA G v†gG ƒq‚C‚b ‚k†yM.",
 201,"„p^ v†gGŠm? ƒ[ŠQMA vvƒP nƒRGŠ@M?",
 212,"ƒ[ŠQM.",
 201,"¡­¡­ŠoM, „p ƒcS ƒq‚S ‚JS ƒoƒO†yM! v†g, …Hn‚f!");
 WarAction(5,201,212);
 WarAction(5,201,212);
talk(212,"aaa, ƒ[ FD Nƒ}ƒm„S ƒv‚h GƒG†y†sŠm? G‚W‰` ƒ_ „y‹~M, …Hn‚f!");
 WarAction(8,212,201);
talk(201,"ƒmŒF¡­¡­",
 212,"ƒG^ ‹T„~†sŠm. ƒ_ Nƒ}ƒb n„L M ƒ_‚CD ‚kƒtM.",
 201,"¡­¡­D…fŠW G†r q ‚a†y‚wƒv¡­¡­ ƒLS ‹B„v ƒuG ŠUˆfG„kM. a‚b q ‚aM, ƒA…eƒv…x.");
 WarAction(17,201);
talk(212,"…M, HI ‡@Q G‹H‚T. ƒv‡z „}‹a …x^ ‡O ‚a†sŠm?");
 WarLvUp(GetWarID(212));
 end
 end
 if (not GetFlag(1061)) and War.Turn==10 then
talk(20,"‚G‚P G Œi‡pG, {…B ‚Ia‚wƒv¡­¡­ ‚M?!");
 PlayBGM(11);
 WarShowArmy(211);
 WarShowArmy(261);
 WarShowArmy(280);
 WarShowArmy(296);
 WarShowArmy(297);
 WarShowArmy(298);
 WarShowArmy(299);
 WarShowArmy(300);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG ƒv…@ŠgM!");
talk(212,"‡{‚TG „l ƒSˆcQ Še q ‚aM. ƒ_ ‹MƒT‚h „aQ B ‚K…X!",
 20,"[, v†g ‚J…xŠ_ƒW [ŠVM. …M, ‚G‚P G Œi‡pG. Gd ƒQq‚h ‹y†yM.");
 PlayBGM(9);
 SetFlag(1061,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG v‡_G Gˆa‚b vv‚TS I‹xŠjM.");
 NextEvent();
 end
 WarLocationItem(0,14,66,85); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÎäµÀÖ¸ÄÏÊé
 if (not GetFlag(86)) and WarCheckLocation(-1,14,23) then
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£°£°£°S …V„kM!");
 SetFlag(86,1);
 end
 end,
 [557]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£³£°£°S ƒYƒC!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [558]=function()
 SetSceneID(0,11);
talk(9,"‡m¡­¡­ ƒ[ŠQMA †oƒwefƒW ƒLS ŠGn ‰j‡SM!");
 NextEvent();
 end,
 [559]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="oq";
 JY.Base["D‚wC"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("oq g~");
talk(126,"‚K‚J, vv^ †oƒwef G‡M ‡D„S‚b „l ƒvn^‚C ‚k‚b ‡KWLM. †oƒweƒm„S g‚Ta‚V‚CZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<×¼±¸½ø¾üÑôÆ½¹Ø£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [560]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, †oƒwe„V laA o‚eƒb ƒOu ƒuhLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"G‚Wf †[ vv‚TƒP g„oƒb ‚Bf ‚aG ‚I‚_aL v†dB…E WLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, …fD „P‚Z^ „OKLM. ƒ[„U ^ƒW d ˆd‡CS ‰} ‚K‡I‚V[.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"d ‡Yƒm„S vvƒP ƒcS ƒq†yKLM. ‚K‚J, ‚^ƒZ …f‚h …bF‚V‰a ‚K‡I‚V[.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"†oƒweƒb ‚syƒP Z‚C‚f ‚C‰JƒG ‡@ƒd „QƒG ‚Sƒ`ƒOL Fk‚h ƒsƒ_…E WLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 DrawSMap();
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(42,"d3ƒa †oƒwe ‚B„e","1. vv ‚p…D",45,0,8);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,33,8,3,0,-1,0,
 -1,32,7,3,0,-1,0,
 -1,33,7,3,0,-1,0,
 -1,34,10,3,0,-1,0,
 -1,34,8,3,0,-1,0,
 -1,33,9,3,0,-1,0,
 -1,32,6,3,0,-1,0,
 -1,33,5,3,0,-1,0,
 -1,35,7,3,0,-1,0,
 -1,34,13,3,0,-1,0,
 -1,35,12,3,0,-1,0,
 -1,33,11,3,0,-1,0,
 -1,34,11,3,0,-1,0,
 -1,35,9,3,0,-1,0,
 });
 DrawSMap();
talk(126,"†oƒwefƒW vv‚h ‚p†Va†yKLM!");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 8,2,3,1,2,58,9,0,0,-1,0,
 386,1,3,1,3,57,15,8,0,-1,0,--µäÎ¤S
 17,6,8,4,0,55,22,0,0,901,0,--ÏÄºîÔ¨
 210,2,4,1,0,55,20,0,0,902,0,--ÏÄºîµÂ
 209,1,4,1,0,54,21,0,0,-1,0,--ÏÄºîÉĞ
 78,5,4,1,0,55,9,0,0,-1,0,
 67,3,4,1,0,54,9,0,0,-1,0,
 102,17,13,4,0,55,22,0,0,-1,0,
 16,7,9,4,0,55,9,0,0,-1,0,
 19,4,6,1,0,54,25,0,0,-1,0,
 211,13,13,4,0,54,22,0,0,-1,0,
 250,8,12,4,0,53,19,0,0,-1,0,
 215,18,14,4,0,53,9,0,0,-1,0,
 213,1,5,1,0,53,16,0,0,-1,0,
 274,5,5,1,0,45,6,0,0,-1,0,
 275,2,6,1,0,45,6,0,0,-1,0,
 276,4,4,1,0,48,6,0,0,-1,0,
 277,6,9,4,0,48,6,0,0,-1,0,
 
 278,9,13,4,0,47,6,0,0,-1,0,
 279,18,12,4,0,47,6,0,0,-1,0,
 280,19,13,4,0,47,6,0,0,-1,0,
 293,12,12,4,0,49,9,0,0,-1,0,
 256,3,7,1,0,45,3,0,0,-1,0,
 257,5,3,1,0,45,3,0,0,-1,0,
 258,7,8,4,0,47,3,0,0,-1,0,
 259,20,12,4,0,47,3,0,0,-1,0,
 260,12,14,4,0,47,3,0,0,-1,0,
 292,9,11,4,0,49,9,0,0,-1,0,
 336,3,6,1,0,45,15,0,0,-1,0,
 294,3,3,1,0,48,9,0,0,-1,0,
 281,11,13,4,0,45,6,0,0,-1,0,
 348,2,5,1,0,44,19,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [561]=function()
 PlayBGM(11);
talk(9,"‚_†ia‚wƒv ‚G‚P! ‡NŠW oNS †cƒNaML! G vv^ H‚h ‚s ‡y†G„S z‚S ‚K…X!",
 1,"ˆvŠP‚f! ‚Ud‚h ƒMŒTaƒd oNS ‚ZŒTa†B ƒ[ …xu‚h Šf„hƒmƒ`‚b …x^ ƒU„S HM. „p^ †JƒLGZ, „p^ ‚s ‡y†G„S z„}…E …XˆmaM.");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [562]=function()
 if WarMeet(190,216) then
 if GetFlag(176) then
talk(190,"„N‡V! M‚V o‚W ŠU `‚EB ƒsQ.",
 216,"¡­¡­„l ˆ|a‚C …X‡I‚V[. ‰jŒ|‚VM.");
 else
 WarAction(1,190,216);
talk(190,"„N‡V, …x„p „N‡VG n†m^? †jn „O„k‚wƒv.",
 216,"¡­¡­…Xƒ| ƒa‚T¡­¡­",
 190,"‚SŠSab …x„p^ vv‚Tf „O‚b^?",
 216,"ƒa‚TŠ_ƒW ƒa„S‚h ‹Xƒv ‚G‚PŠiŠ_ ^ƒN ‡D v¡­¡­ v tCŠ_ƒW o‚eS „QŠVKLM¡­¡­",
 190,"v tCG‚fL? …x„p^ ‚SŠS¡­¡­",
 216,"ƒ[ŠQKLM. …f‚b v tCŠ_ ‡g‚DB ‚Cƒgƒb vv‚TƒP …IƒQhLM.",
 190,"I‡JG! ‚SŠS ƒ[u ‚Su„Zƒb^? vvƒP …v‚]S ‚Z‡M†M ˆ|j^?",
 216,"¡­¡­…f‚b ƒa„SfQ ƒP†dS …HƒtKLM. ‡y ‡EG ‚aS „U v tCŠ_ƒW …A†hQ ŠGn ‚K‚Vƒd ‚eRY‚C ŠEƒGŠV‚CZ. ¡­¡­ƒ[ ƒbƒp‚h ‹y‚C ‚k‚bMA d ƒPu‚b ‚SƒZ „O†yKLY?",
 190,"I‡H ‰umƒj^? ‚CƒgG‚fD M‚V ‚VJaQ. ‚S†A^, ƒv‡z ‰HŠ_ ‚G‚U†fS Œr…e ^‚C ‚k†yƒv.",
 216,"¡­¡­…Xƒ| ƒa‚T, k‚Bf‚b ƒa‚TƒP ‚^aŠbƒmƒv ‚Cƒgƒb ƒLhLM. I‡H ˆ|Š[S aŒsD m„o‚aƒmL …f‡z ‰jƒO‚V‚CZ.",
 190,"G ‚Su„Zƒb ƒu!");
 WarAction(6,190,216);
 if fight(190,216)==1 then
talk(190,"„N‡V, M‚V o‚W `‚EB ƒsQ.",
 216,"„l ˆ|a‚C …X‡I‚V[. ¡­¡­…Xƒ| ƒa‚T, ‚o‡}ŠW „T‡I‚V[.",
 190,"„N‡V, ƒGMuQ!");
 --WarAction(16,216);
talk(190,"„N‡V¡­¡­");
 WarLvUp(GetWarID(190));
 SetFlag(176,1);
 else
 WarAction(4,216,190);
talk(190,"„N‡V¡­¡­");
 WarAction(17,190);
 WarLvUp(GetWarID(216));
 end
 end
 end
 if (not GetFlag(145)) and WarCheckArea(-1,6,20,15,25) then
talk(103,"ŠoM, ƒ_^ …m‡WG „C†yM. …A…w‚V v tCƒP ‚[ƒh‡S ƒG‚_‚h …f„qu‚C ‚kƒmu‚f. ‰B‚pa‚f!",
 216,"k.",
 212,"ƒaWfQ ‡D‹n‚C‚C …X‚f. ƒOuD ‹Iƒm„S ‰B‚poM!",
 17,"‰b ‰jˆlG ‚VJˆYM. ‹D „l ‹Iƒm„S ƒvn^ …I~ ‰jˆlf ˆc‚SƒR…x.");
 WarModifyAI(78,4,6,8);
 WarModifyAI(16,4,10,12);
 WarModifyAI(17,4,9,11); --ÏÄºîÔ¨
 WarModifyAI(19,4,6,9);
 WarModifyAI(250,4,13,12);
 WarModifyAI(292,4,13,14);
 WarModifyAI(256,4,7,8);
 WarModifyAI(258,4,9,13);
 WarModifyAI(277,4,11,11);
 WarModifyAI(278,4,13,13);
 WarModifyAI(102,1);
 WarModifyAI(211,1);
 WarModifyAI(215,1);
 WarModifyAI(259,1);
 WarModifyAI(260,1);
 WarModifyAI(279,1);
 WarModifyAI(280,1);
 WarModifyAI(293,1);
 WarModifyAI(281,1);
 SetFlag(145,1);
 end
 if (not GetFlag(146)) and WarCheckArea(-1,6,3,11,8) then
talk(214,"dƒGŠJ, ‚G‚P. …fƒRS †oƒwef „l ‰n†Z‚V‰aƒW‚b ‚o ˆYM. ‚Z‚[ ƒv‚h ‚i‚j‚f!",
 126,"‚K‚J, …f ƒLgf ‚r…XƒP‚f‚b …x^ „O‚b…h s‚K^ C‡iaM WLM. v†daŒs…E WLM.");
 WarModifyAI(67,1);
 WarModifyAI(210,1); --ÏÄºîµÂ
 WarModifyAI(209,1); --ÏÄºîÉĞ
 WarModifyAI(213,1);
 WarModifyAI(257,1);
 WarModifyAI(276,1);
 WarModifyAI(274,4,3,4);
 WarModifyAI(275,4,2,4);
 WarModifyAI(294,1);
 WarModifyAI(348,1);
 WarModifyAI(336,1);
 SetFlag(146,1);
 end
 WarLocationItem(10,14,18,208); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÂíÊõÖ¸ÄÏÊé
 if JY.Status==GAME_WARWIN then
talk(9,"‡m¡­¡­ a‚b q ‚aM, ƒa‚oƒm„S ƒA…e‚qM.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡vv^ o‚eS †aƒGaƒd ‚G‚P^ o‚eS ‡F‚YPM.");
 NextEvent();
 end
 end,
 [563]=function()
 GetMoney(5000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £µ£°£°£°S ƒYƒC!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [564]=function()
 SetSceneID(0,11);
talk(9,"ƒa‚oƒm„S ƒA…e‚qM. ‚G‚P, G‚W …I{ ƒL…WƒP lƒb …A…w‚V ‹yn ‚K…X!");
 SetSceneID(0,3);
talk(126,"‚K‚J, …Xƒlƒ_ o‚eS ‡F‚YaŠVƒmL ƒ@a…w„tLM. ƒ[†{ o‚eƒ{ƒm„S …w‚V‚CZ.");
 NextEvent();
 end,
 [565]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="o‚e";
 JY.Base["D‚wC"]=0;
 AddPerson(1,9,16,0);
 AddPerson(126,9,13,0);
 if not GetFlag(38) then
 AddPerson(133,15,16,0);
 end
 AddPerson(3,10,9,3);
 AddPerson(190,12,8,3);
 AddPerson(54,24,16,2);
 AddPerson(170,26,15,2);
 --AddPerson(369,19,11,1);
 SetSceneID(52,5);
 DrawStrBoxCenter("o‚e ƒP‚r‰R");
talk(126,"‚K‚J, …Xƒlƒ_ o‚eS …VƒmŠVƒmL d ‚sa|‡LƒP ‚B‚vG Gƒ^‚SƒFKLM. G‚b ‚K‚JƒP Nƒ}G …w…e‚q ƒuGƒGD WLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [566]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ƒ@a…w„tLM. …f‚b ƒGŒ~ƒW¡­¡­.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"[†G‚B‚^ƒh ‚K‚JS ‚i„gƒmƒv G‰S…l ƒGk ƒuƒb ‹n‚MhLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, G ŠRƒbGfQ G‰S…l {ƒv‚b …c„FS …g„} ‚K‚VL †~ƒm„S ‡N‚rWLM.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"‚K‚J, vv‚h o‚efƒW Œ{nƒ_ƒN ƒuS ƒ@a…w„tLM. …mˆjƒP oD ‰s„kKLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"G„S‰l ‚n¡¤‡{¡¤[ |} F„tƒP ˆEƒo^ Gƒ^‚SƒFKLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ‚^ƒZ o‚e‡ef [‚j‡I‚V[.",
 1,"I‡JG[? o‚e‡eG‚fL? ¡­¡­nL „C[, ƒ[Šl q‚b ‚am.",
 126,"¡­¡­‚K‚JŠ_ƒW …X‚Mf ‚@u‚V‚b ƒuƒb ‚X‡LG†y‚CZ. ‡mƒv ‡eS Wa‚C ‚kƒmƒNMA …fŠs …ZƒN IƒaƒRƒb †@ŠH t‚DX q ‚aKLM.",
 1,"ƒ[ƒuƒb¡­¡­",
 126,"…fŠs ‚^aƒRƒb [ˆs ƒo‡c ‚K‚JS ‚i‚j†B ‚Cƒg‹n†{ ‚I‚_B‚C‚VƒG‚h ƒU„gKLM. ‡eS Wa‚C ‚kƒm‚V†yM‚b ƒuƒb „l ‚IB‹T ƒ]G ‚aM‚b ˆ|{ „GƒmL, ƒ[ŠQMA …fŠs^ ‚K‚JS ‚i‚j‚b ƒ]G I‡JG†yKLY?",
 1,"¡­¡­",
 126,"QM^ vv^ G†w ƒ~ƒ~„S ‚n‡ef ƒi„gM WLM. vvf ŠGƒWƒd ‚saf ƒ]S ƒsGƒG ‚nBƒW‚fD ‚^ƒZ o‚e‡ef [‚j‡I‚V[.",
 1,"¡­¡­",
 126,"Fa‚V†Eˆe dQ …I…e ‚K‡I‚V[.");
 NextEvent();
 end
 end,
 [567]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠiG o‚efƒW ‡eG „C‚VA Še[ ˆEŠiD ˆE‚KfƒW ƒGŒ~aN ƒuhLM. ƒnˆEŠi, o‚e‡ef [‚j‡I‚V[.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚Z‚[^ ‡e‚nf [‚j‚VƒG‚h ƒUŒeLM. …f ‡Oo kƒk^ n‚`LM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ‚^ƒZ o‚e‡ef [‚j‡I‚V[. ŠRƒb ƒNa‚h ‰u„CG ƒGMuQ a‚C …X‡I‚V[.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"vv^ ‚n‡eS Wo ƒuS gjX q‚b ‚aKLM. ‚K‚JŠ_ƒW o‚e‡ef [‚j‚V‚b ƒuD vvf ŠGƒWƒG ‚n‰HhLM.");
 end
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"‚K‚J, o‚e‡ef [‚jƒNM BD ‚_†Mo …Iƒb n‚`LM. ‚^ƒZ ‚r†oa‚C …X‡I‚V[.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"o‚e‡ef [‚jƒG„S FaŠVKLY?") then
talk(126,"[, t„YaŠV‚TZ!",
 1,"‡m¡­¡­ ƒ_^ o‚e‡eG „C†ym. d‚TƒR, G†GD „C†ym?",
 3,"†u^ …A‚_a†yKLY? n, ‚Z‚[ ‡Zƒ{WLM.",
 54,"‚Z‚[ ‡i…BŠW ‡Zƒ{WLM. o‚e‡eŠ_ƒW ‹Iƒm„SD …fŠs‚h ŠU Gˆn‚S ‚K‡I‚V[.",
 170,"o‚e‡e „Vƒo!",
 190,"ƒ@a…w„tLM. …mˆjŠ_ƒWD ‚w‚sfƒW ƒGŒ~aN ƒuhLM.");
 if not GetFlag(38) then
talk(133,"„l„m ‡t†dƒm„S ‚K‚JS ‚i‚j†yKLM.");
 end
 PlayBGM(8);
 DrawMulitStrBox("¡¡‚G‚P‚b vvƒP ‡YfƒW o‚eS Šf„hƒtM. G„S‰l ˆE‚K¡¤…S‚K¡¤o‚eS nƒO‡M ‚G‚P‚b ‚I‚_o ‡{ƒP ‚KjG „C„kM. ‚J‚XG ‡X‚efƒW ƒ[ƒj ‚n¡¤‡{¡¤[ ‚sa|‡L‚C„T^ Gƒ^‚Sg ƒuGM. G„U‚^ƒh ‚G‚P‚b o‚e‡eG „C„kM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
talk(126,"‚K‚J, ‚^ƒZ †@†Ma‡I‚V[. G‚b ‚K‚J …xƒN„VG nL‚f ‚Z‚[‚h ‚no …IhLM.");
 end
 end
 end,
 [568]=function()
 SetSceneID(-1,11);
 JY.Base["ÕÂ½ÚÃû"]="d3ƒa¡¡‡{o w}";
 DrawStrBoxCenter("d3ƒa¡¡‡{o w}");
 ModifyForce(2,1);
 ModifyForce(128,1);
 ModifyForce(155,1);
 ModifyForce(38,1);
 ModifyForce(34,1);
 ModifyForce(39,1);
 LoadPic(23,1);
 DrawMulitStrBox("¡¡‚G‚P^ ƒ~ƒ~„S o‚e‡ef ƒi„gM‚b m‚yS ƒRƒb vv‚b ‰bƒU„S [‚K ‡Y‡bfQ ‚r…x‚h ƒsƒ_, ‚l[‡z ‰HŠ_ ‚TS ƒ_‚S eƒO^ ‚C‰J‚b ˆE‚K‚h Šf„h…xƒd d‚oPM.*¡¡‡Y‡bƒb G‚h …HnƒRŠbM. GƒuG ‚n[ ‚l†_GM.");
 LoadPic(23,2);
 LoadPic(24,1);
 DrawMulitStrBox("¡¡vvƒP ˆl„LRƒb ‰b ‚J‚XfQ „aƒ`ƒFM. ‚J‚XƒP „TƒCf ‚i‚f eƒO‚b vjG ‚C‰J‚b ‚Wƒ{S ‡RM.*¡¡ƒ[…eƒv eƒO^ ‚Wƒ{S ‰HˆyaƒG „L‚B, ‚l[ƒP b‡~{ †Q‡YG ƒ[ ŒoS …@ ˆE‚K‡z ‚ISS ‡F‚YPM.");
 DrawMulitStrBox("¡¡eƒO‚b ‚ISS „C‹qƒmƒ` Pƒmƒv b‡~{ vjfQ †oAƒm„S ‰G‚J‡iPƒd, †o†o…X…f vjfQ Šf„h‹HM.*¡¡ˆu ŒE…I ‡ES ŒOƒb eƒO‚b †o†o ‚^†Z |ƒ{fƒW ˆpD„S ‚n‚|„S‡S ‹n‚Cf ‹^ŠbM.");
 LoadPic(24,2);
 LvUp(2,10);
 LvUp(128,9);
 LvUp(155,9);
change_mode()
 WarIni();
 DefineWarMap(45,"d3ƒa |ƒ{ ‚B„e","1. ƒL ‚B†U*2. eƒO^ ƒW‹J ƒ{…^ DˆG",50,1,-1);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 1,20,8,3,0,-1,0,
 127,19,8,3,0,-1,0,
 154,20,9,3,0,-1,0,
 33,21,7,3,0,-1,0,
 37,20,7,3,0,-1,0,
 38,22,8,3,0,-1,0,
 });
 ModifyForce(256+1,9);
 ModifyForce(274+1,9);
 ModifyForce(292+1,9);
 ModifyForce(293+1,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 148,3,3,4,0,52,20,0,0,-1,0,
 161,16,13,4,0,48,3,0,0,-1,0,
 162,7,16,4,0,48,9,0,0,-1,0,
 44,7,4,4,0,47,3,0,0,-1,0,
 173,15,12,4,0,47,25,0,0,-1,0,
 150,8,5,4,0,47,16,0,0,-1,0,
 45,6,15,4,0,47,3,0,0,-1,0,
 18,30,7,3,1,52,3,0,0,-1,1,
 83,31,7,3,1,48,21,0,0,-1,1,
 28,27,6,3,1,47,6,0,0,-1,1,
 32,26,7,3,1,47,6,0,0,-1,1,
 78,29,6,3,1,48,9,0,0,-1,1,
 256,30,8,3,1,44,3,0,0,-1,1,
 274,25,5,3,1,45,6,0,0,-1,1,
 292,24,6,3,1,45,9,0,0,-1,1,
 293,28,7,3,1,44,9,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [569]=function()
 PlayBGM(11);
talk(39,"eƒO ƒa‚T, Gd M‡M „ND^ ‚aKLM. ƒ{D„S ƒA…eƒv sƒG‚h D‚Za‚V‚CZ. ƒ[„U ^ƒW ˆE‚K‚h ‰Bƒ`…HƒmA ŒjLM.",
 38,"ƒOu^ ‚Z‚[ …G„l‚fD eƒO ƒa‚T„Vƒb ƒEˆkƒv^Œs…E WLM. ƒW‹J ƒ{…^Y‚C„V ^‚VA I‚rWLM.",
 128,"vv‚TG ‰b ‹Kn…oLM. n„qŠi, ‚SƒW G ‰_S Œz‚Sƒv‚V‚CZ.",
 155,"d^ ƒc…~S ‚@ƒd ‚C‰a …wu†yKLM!",
 2,"‡m¡­¡­ nID …G‚SƒW‚b ‚o ˆYM. ‚Z‚[ †jnƒW G‡ES Œz‚Sƒv…E oM!",
 149,"…fƒRS „[ …^„S ‰_fƒW ƒ_ƒsƒ_ƒW‚b ‚o ˆYM. ƒ[…eA ‡YS „P q ‚aM. ‰_S Œz‚SƒvƒG ‚Bf …A…w‚V ‚aŒi‚f!");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [570]=function()
 if (not GetFlag(1062)) and War.Turn==2 then
talk(2,"‚M! …c‚p‚~G ŠXM!");
 WarShowArmy(18);
 WarShowArmy(83);
 WarShowArmy(28);
 WarShowArmy(32);
 WarShowArmy(78);
 WarShowArmy(256);
 WarShowArmy(274);
 WarShowArmy(292);
 WarShowArmy(293);
 DrawStrBoxCenter("vv‚TG ƒv…@ŠgM!");
talk(19,"[fQ ‚JS Šf„h†r q ‚aM. eƒOƒP ƒcƒb ƒOu^ †E‰QM!",
 149,"ƒ[Šl q‚b ‚aM. eƒOƒP ƒcƒb [^ †E‰QM!");
 SetFlag(1062,1);
 end
 WarLocationItem(14,16,49,209); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¾üÊé
 WarLocationItem(17,9,55,210); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º²è
 WarLocationItem(8,7,49,211); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¾üÊé
 if JY.Status==GAME_WARLOSE then
 PlayBGM(4);
talk(2,"ˆEŠi, DƒQ†@ƒP G†G „{‰b ˆEŠiS ‚i„gKLM. ‡mƒv [ƒX„S d ‚XG Mo ‡KWLM. Gƒ^‚C ˆfo ‹dƒb ˆEŠiŠ_ƒW ‚_ƒN Gƒ^‚S ‚K‡I‚V[. ¡­¡­ˆEŠi, G[. ~ƒQŠW ‚o‡}ŠW!");
 DrawMulitStrBox("¡¡eƒO‚b ‚r„S‹Q‰o ‡D †~q„C„kM.");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarCheckLocation(1,3,0) then
talk(149,"†kOM! eƒO‚h ‹^‡RƒmL …C†IG ‹[‚aƒmu‚f. †@ŠH eƒO‚h ˆGnƒvQ ‚[‚SƒW‚b ‚o ˆYM!");
 PlayBGM(2);
 DrawMulitStrBox("¡¡eƒO^ ‚BƒaS Œz‚SŠgM.");
 SetFlag(58,1);
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(2,"ƒLƒP ƒQ‚TG ‹fƒG ‚Bf ‚SƒW ^‚V‚CZ.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡eƒO^ ‚BƒaS Œz‚SŠgM.");
 SetFlag(58,1);
bonus_moneyexp_8()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [571]=function()
 ModifyForce(2,0);
 ModifyForce(128,0);
 ModifyForce(155,0);
 ModifyForce(38,0);
 ModifyForce(34,0);
 ModifyForce(39,0);
 ModifyForce(256+1,0);
 ModifyForce(274+1,0);
 ModifyForce(292+1,0);
 ModifyForce(293+1,0);
 NextEvent();
 end,
 [572]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=0;
 AddPerson(20,21,13,2);
 AddPerson(94,19,14,2);
 AddPerson(213,17,15,2);
 AddPerson(214,15,16,2);
 AddPerson(387,23,14,2);
 AddPerson(239,21,15,2);
 AddPerson(212,19,16,2);
 AddPerson(242,17,17,2);
 SetSceneID(82,11);
 DrawMulitStrBox("¡¡ƒ[ ‡D vv^ ‚~ƒR„kM‚b m‚yG wu RƒFM. ¡­¡­G‡Eƒb †nƒ{ƒP vv e…fM.");
 DrawStrBoxCenter("†nƒ{ vv e…f");
talk(9,"¡­¡­‚sa‚h „w…IoM‚b ƒuG ‚SŠS ‹]‡S …IG]. G‰S…l ‚I‚_o „@S ‚CLƒdD¡­¡­ ‹[ƒ_ Gƒ^‚C ˆfP‚wƒv.",
 20,"ƒ[ I‡H ˆ|Š[G‡ILY. ƒG‡SS ƒ_‡I‚V[.",
 9,"ƒv‚b Œv…X …g‚C ‚kƒtM. ƒ_^ …G†Eˆe¡­¡­ v‚P^ ƒ_ …xu‚h ‰{‚bM. v‚P, Gu [H‚f.",
 213,"k.");
 MovePerson(213,2,2);
talk(9,"„p^ ƒ_ …xu‚h G‚S‚f. ƒ_^ …GƒmA [‡z ‡{ƒb …A…w‚V ‚^}†R ƒuGM. ƒ[„U †@ŠH ‰H‚^„S ˆl„LG‚C …X‚f. t‚^^ ‡yƒj ‡Df GŒI ‹JS ‚s‚sŠW †E‚[‚S‚f. …A…w‚V ‚X†daƒd ƒ[‚j„Q‚C …X‚f! ƒ[…e‚C ‚kƒmA †Uˆoa‚b ƒuƒb ƒOuM.",
 213,"‚X†da†yKLM. …A…w‚V n„qŠiƒP ƒG‚_‚h …f„qu‚C ‚k†yKLM.",
 9,"¡­¡­ƒ[‚jˆjMA ƒv‚b H‚h „oƒW„Q ‚kƒmu‚f. …ftfƒW‚fD ‰Bn‡z H‚h ‹qn^†yM.",
 213,"k! k!",
 9,"‡m¡­¡­ ƒ[†{ …X‚M ‹^ƒd ^†yM. d‚TƒR, ‚^ƒZ ŠUƒR „Oƒm‚f¡­¡­");
talk(94,"‚K‚J! ˆUˆU¡­¡­",
 214,"¡­¡­");
 MovePerson(213,1,3);
talk(213,"ƒ[†{ [ƒX‚^ƒh ƒv‚f‚b ƒ_^ Mƒ~ƒjM. ƒ[‚_ƒRƒb n„qŠiŠ_ a‡K ƒ_Q ‡tƒ{S Ma‚f.",
 20,"k.");
 LoadPic(25,1);
 DrawMulitStrBox("¡¡G‚S n„q‚C vvƒP …xu‚h Gƒb v‚P‚b ‡ZŠxƒP …E†dS Gƒ^„kM.*¡¡‡qd‚b ŠD‚nˆY ‡D ‚G†c„C„kM. o ‡ev‚b G„S‰l †UˆoPƒd, „p ƒoƒGf ‚@ˆj †J‚rD ‡fS ƒ_„~M.");
 LoadPic(25,2);
 NextEvent();
 end,
 [573]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒ{D";
 JY.Base["D‚wC"]=21;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 AddPerson(3,19,9,1);
 AddPerson(54,9,14,0);
 SetSceneID(56,5);
 DrawStrBoxCenter("ƒ{D †X‚B");--³É¶¼ÒéÊÂÌü
 DrawMulitStrBox("¡¡eƒO^ ‚n†PaM‚b m‚yƒb G†w ‡{ƒP q‚^ ƒ{Df ‚BBˆk „O„kM. ƒ[…eƒv ‚G‚P^ m‚yS Š^ƒdD ‡y‰X‚h ‹Q‚C ˆfo ˆ~f, eƒO^ |ƒ{ƒm„S ‹KƒG‚b †~‚r^ l‚SƒFM.");
 AddPerson(365,37,23,2);
 MovePerson(365,11,2);
 PlayBGM(2);
talk(365,"‚K‚JŠ_ nŠnLM. ‚_ƒo^ Šo‚C ‚kKLM! eƒOŠiG b‡~fQ OaŠVƒd, e ƒa‚TŠ_ƒW B‚h hƒmŠVM WLM.",
 1,"I‡JG‚f!¡­¡­",
 3,"G ƒd‡Co ŒN, ‰umu …X‚f. Še[ ˆEŠiG …GS u ‚aM.",
 365,"a, a[ƒv G‚b ŒG‚O‚a‚b ‚rNhLM¡­¡­");
 MovePerson(3,2,1);
talk(3,"eƒO ˆEŠiG …GS u ‚aM! ƒ[Šl u ‚a‚S, ƒ[Šl u ‚a‚S¡­¡­");
 MovePerson(3,2,2);
talk(3,"ƒnˆEŠiD ƒ[u bƒG‚V‚CZ.",
 1,"¡­¡­",
 3,"ƒnˆEŠi, ƒ[u `‚EaƒNMƒd ˆ|Š[B ‚K‡I‚V[¡­¡­ ‚l[ƒP †K „Gƒb ŒNƒRG ‡NŠW Še[ ˆEŠiS¡­¡­.",
 1,"ƒa‚P¡­¡­ ƒvD H‡z „Gƒb …X‚MGM. ‡mƒv ‚Cƒgƒb ˆIFB…E oM.",
 3,"‚l[ƒP †K „Gƒb ŒNƒR, …A…w‚V ‚_^‚h „Q‚jQ a†yM!",
 1,"I‡JG¡­¡­ eƒO¡­¡­ ‚rN…I u ‚aM¡­¡­",
 365,"ƒ[†{ …f‚b ƒA…e^†yKLM.");
 MovePerson(3,2,3);
 MovePerson(3,2,0);
 MovePerson(3,0,1);
 MovePerson(365,12,3);
 DecPerson(365);
talk(1,"eƒO¡­¡­ ‚SŠS GŠQQ¡­¡­ ƒOu‚b aƒXf †_ƒoa‚C ‚kƒt†sŠm. ‚SŠS Gu Wu ^ „q„~‚b^?¡­¡­");
 AddPerson(369,37,23,2);
 MovePerson(369,11,2);
 PlayBGM(11);
talk(369,"‚K‚J, „Nƒg ‡m†gfƒW ‰BnŠXKLM. ƒn…IS n„b…oLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [574]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‰ct „Gƒb ŒNƒR! ‚l[ƒP †KƒR! ‡Y‡b G …G…I ŒN! ƒnˆEŠi, ˆAd [‚h „Q…e ƒv†bLY? …f‚b …A…w‚V ^†yKLM!");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"ˆE‚K‚h ŒO„kƒmƒv ‚Cƒgƒb ˆIFB…E WLM. HI ‚pB‚C‚C …X‡I‚V[.");
 end
 if JY.Tid==369 then--Îä¹Ù
talk(1,"ƒW‚[‚j‚C …X‚V[. I‡H …IG „O„km?",
 369,"ƒO…m vv^ …Gƒd ƒ[ ƒa…g v‚P^ …xu‚h G„kKLM.",
 1,"I‡JG? vv^ …G„kMƒd?! ¡­¡­‡O I‡H …IG „Om?",
 369,"v‚P‚b …xu‚h Gƒb ‡D ‡qd‚h ŠDaƒd ƒ~ƒ~„S ‚Udf ƒi‚f }†q‚h ¡°‚n¡±„S ƒUƒV„kKLM.",
 1,"I‡JG! ƒ[†{ ‡qdŠ_ƒW‚b ‚SŠS „CŠVm?",
 369,"¡­¡­‡m†gfƒW ‹K„}ƒv ‚U„Xo ‚VŒA„S ‚G†c„C‚S „P„PŠW ‚Cƒ_ƒNM WLM.",
 1,"‚SŠS GŠl q^¡­¡­ ƒ_ ƒw`ƒP ƒc…qj oN ‚^…MG v‚PƒP ‡Yf GŠQQ IHg†M ˆ|j^? ‚Z‚[ ƒ_ „@G ‚Z…x‚d ˆ~G„SM¡­¡­",
 369,"ƒ[†{ …f‚b ƒA…e^†yKLM.");
 MovePerson(369,12,3);
 DecPerson(369);
talk(1,"ƒv‡z eƒO^ ƒw` ~ŠB oN ‚^…MƒP ƒ]ƒb ‹[ƒ_ G‹a q ‚a†M ˆ|j^? ‚SŠS G‹@ …IG.");
 AddPerson(367,37,23,2);
 MovePerson(367,11,2);
talk(367,"‚K‚J, d‡y†ZG ŠXKLM.",
 1,"†u‚w‚fƒd? ŠoM, ƒR‚f a‚f.",
 367,"k.");
 MovePerson(367,12,3);
 DecPerson(367);
talk(3,"‚l[ƒP ‚r…x‚fƒdZ? eƒO ˆEŠiS ƒGKB ‹^ƒd Gd ‡z I‡H Hƒm„S ŠX†CLY? ƒnˆEŠi, ƒq‚S „qu‚V‚CZ.",
 1,"¡­¡­ƒ[Šl q‚b ‚aM. I‡H ˆ|S aƒ`‚b‚C ƒR‚S „v ‡Df ƒq‚SD ‹z‚C ‚kM.",
 3,"dƒGŠJ! ŒPŒPaQD ŠX‚wƒv!");
 AddPerson(146,37,23,2);
 MovePerson(146,11,2);
talk(146,"[ƒv‚f x‚r d‡y†ZG ‹pƒG‚h ‰RWLM.");
 DrawMulitStrBox("¡¡‚Cƒg ƒv…@‚q d‡y†Zƒb d‡y„XƒP ˆEGM. ‚J‚XƒsM ƒvG^ {| ‡Aƒm†B, ‚J‚XG n‚K ‚S„u „U‚^ƒh [ƒv‚f‚h ˆL‹HM.*¡¡‡Y‡bƒb ƒ[‚h ‰KG ƒNRPƒm†B, G‚Wf ‡{ƒm„S ƒsˆZ ƒuG ƒ[ ‰d†EŠbM.");
talk(3,"ŒL! [ƒv‚f †KƒRG ƒOu ‚T‚rƒP ˆEŠiS ‚r…x„S ƒsƒ_ML †~ƒm„S ‚P‚Aa‚wƒv. G…eA ‡YS ˆ`ƒG ‚SŠq‚C ‚kƒb^.",
 126,"¡­¡­ƒO…m d ˆEŠiƒP ˆ|S ƒR‚S ƒs‚V‚CZ.");
 NextEvent();
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‡m†gf I‡H …IG „O„k‚b‚C ‚r…xƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 end,
 [575]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‰ct „Gƒb ‡Y‡b ŒN! ‚r…x‚b I‡Ja…e ƒs„j†M ˆ|GŠm?*‚T‚rƒP ˆEŠi„V nL„kMA gJf ƒq„kS ƒuS.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚K‚J, ‚Cƒgƒb ‡NFS Mƒ~u‚Vƒd ‚r‚r„S‡S Ff ‚gŠeu‚C …X‡I‚V[.");
 end
 if JY.Tid==146 then--Öî¸ğèª
talk(1,"d‡y†Z, ‚Sj …I„S ŠXm?",
 146,"v‚P^ ‚Ud‚h Wo m‚yƒb ‚U†fŠ_ƒWD G†w nN ƒuhLM. …fŠs ‡Oo ƒ[‹@ …Iƒb „o‹_aƒG ‚SŠqKLM. G‚Wf †[ ƒuƒb ‚n‡zƒP †_‡CS †VƒGaƒd ‡{{ ‚l†_S Šhƒd…x ‰HhLM. ‚l†_G Gƒ^‚S‚CA ˆE‚K‚h ‰Bƒ`…w„u `‚EhLM. ‚^ƒZ ‰k„Ro †CS ‚K‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<»Ø´ğÖî¸ğèªµÄ½áÃËÌá°¸>
 NextEvent();
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚K‚J, ƒ[ †dFƒb ŠU …FLM„V ‚^ƒZ d HS ƒsn ˆEŠi„Vƒb ƒq‚C ˆ|n ‚K‡I‚V[.");
 end
 end,
 [576]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"…f ‰umu‚h Š^‚C …X‡I‚V[. Še[ ˆEŠiG ƒ[‰S…l †~zaQ ‰Bn^ŠV‚b…h ‚SŠS Šk†yKLY. ƒnˆEŠi, †@ŠH ‚l†_BƒW‚b ‚o ŒjLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"…f‚b [‡z ‚l†_B…E oMƒd ‹bLM. [‚h „Q‚b ƒuƒb ‚K‚JƒP ‚r‚r„S‡S …IGL ‚saƒP †q„iS …V‚C ˆfWLM.");
 end
 if JY.Tid==146 then--Öî¸ğèª
 if talkYesNo( 146,"FaŠVKLY?") then
 RemindSave();
talk(146,"ƒ[†{ †CS ‚K‡I‚V[.");
 local menu={
 {"¡¡ ‚l†_oM",nil,1},
 {"¡¡‚l†_a‚C ‚k‚bM",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(146,"[, ‡N‚rWLM. ‰bƒU„S […CŠ_ ƒGk m‚yS ‚Ba†yKLM. G‚b [ƒv‚fƒP Jƒb Fƒ{GL …Hn ‚K‡I‚V[.");
 GetItem(1,4);
talk(146,"ƒ[†{ ‰bƒU„S ‰Bn^ …fŠs ‚K‚JŠ_ n„b†yKLM.");
 MovePerson(146,12,3);
 DecPerson(146);
talk(126,"‚K‚J, ŒRƒb †@†MS ƒ_uŠVKLM. ‡mƒv …{ƒm„S‚b Œ[‚V ‡w„SƒO‚V†y‚CZ.",
 1,"¡­¡­[ƒv‚f^ …OƒG‚b aƒv ‚Cƒgƒb [‡z Ml „U^ nL[. ‰q…f v‚P‚h „Qƒd oNS „C†jƒ`…E a[. ƒa‚P, ƒv‚h GBB M[.",
 3,"¡­¡­…f‚b ‚CƒgŠy ƒnˆEŠiS ˆ[„kƒd¡­¡­ ‹Iƒm„SD ƒ[Šl ƒuhLM.",
 1,"ƒa‚P, ƒdŠOM.");
 SetFlag(132,1);
 SetFlag(135,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(592); --goto 592
 elseif r==2 then
 PlayBGM(12);
talk(1,"‰Bn^ ‡Y‡bfQ ‚Ba‚V[. ˆE‚K‚h Šf„hƒd eƒO‚h …Gj ƒQoS ƒv‚b Šk‚C ˆfoMƒd. ‚l†_G‚fL, ‹dD ƒV‚C …X‚V[!",
 146,"Gƒuƒb¡­¡­ ‚G‚PŠi, ‚^ƒZ ƒo ‚W ŠInƒ` ‚K‡I‚V[¡­¡­",
 126,"ƒ[ŠQKLM. ‚Cƒg [‡z ‰jƒOA v‚P„V ƒGŒ~X ŠFhLM. ‚^ƒZ¡­¡­.",
 1,"ƒ[„Va‚V[, ‚J‚X! ƒ[‚_^ ˆEd‚h ŒOƒb †dFS „aƒGƒv a[?",
 126,"¡­¡­",
 1,"‚SƒW ‰Bn^ ‚Ba‚V[. ‡{ƒb ‰jˆlS …nPMƒd. ƒ[‚_^ d‡y ‚T‚rƒP ˆEŠiG nL„kMA †jƒ` ƒsƒ_‚C ‚kƒtS ƒuG[.");
 MovePerson(146,12,3);
 DecPerson(146);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"…f‚b [‡z ‰j„EƒW‚b ‚o ˆYMƒd ‹bLM. [‡z ‰jƒOA GƒDS ƒs‚b ‹Jƒb ‚nhLM. ‚Cƒgƒb ˆE‚K‡z eƒO‚h Škƒd [‡z ‚l†_B…E WLM.");
 end
 end,
 [577]=function()
 if GetFlag(58) then
talk(3,"ƒnˆEŠi, …bFS ‚Xa‡I‚V[.");
 SetFlag(135,1);
 else
talk(3,"†J‚V ƒOu ƒnˆEŠiG‡ILM! ‰bƒU„S ƒe‚Pa…e ^†yKLM.",
 1,"ƒa‚P, HI ƒW‚[‚j‚C …X‚f.",
 3,"G‰S…l [†G ƒGM„~‚b…h „l‚b @ƒa ‚^„u q ‚aKLM. ƒnˆEŠiD ‚SƒW ƒe‚Pa‡I‚V[.");
 MovePerson(3,2,1);
 MovePerson(3,12,3);
 DecPerson(3);
 end
talk(126,"¡­¡­",
 1,"‚J‚X, †w‚oa[. nY‚b ƒ_^ ‚Cƒv‡Rm.",
 126,"ƒJƒKKLM. …ffQD ŠUˆfG „O„kKLM.",
 1,"‚J‚X, [‚b ‚S‹cQ ŠP…E a†ym?",
 126,"‰q…f ƒWSƒ{S ‰Hˆyaƒd ƒ[‡ES †Z†E‚C„S |n g‚TaŒs…E WLM.",
 1,"‚M, ‚J‚Xƒb …gn v‚P‚h ‡fƒm‚V[. v‡S{ …Xƒ|^ ƒ[‚_‚h ‰IQ a†ym.");
 ModifyForce(54,0);
 ModifyForce(126,0);
 ModifyForce(190,0);
 ModifyForce(204,0);
talk(1,"…bFa†yKLM.");
 NextEvent();
 end,
 [578]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(175,"ƒWSƒb ‚ISƒm„S ^‚b †rƒcf „OKLM. ‚SƒW …b_a‚V‚CZ.");
 SetSceneID(0);
 if GetFlag(58) then
talk(1,"eƒOƒP ƒQq‚h ‹yn…E oM. [, ƒa‚P^ ŠX‚wƒv.",
 3,"ƒnˆEŠi, ‹z‚SƒW b‡pWLM. ‰Bn^ ƒe‚P‚h ‹D aM ƒsL ‚V…yG ‚CŠgKLM.",
 1,"ŠoM, Gd M ‚ZŠbM. ƒWSƒm„S g‚ToM!");
 else
talk(1,"eƒOƒP ƒQq‚h ‹yn…E oM¡­¡­ ‚M, …fw […AG n†m^?",
 91,"‚K‚J¡­¡­",
 1,"I‡H …Ij^? ‚oŒYG M†Po…h I‡H …IG „O„k‚b^?");
 PlayBGM(4);
talk(91,"‚K‚JŠ_ nŠnLM. ¡­¡­ƒa‚PŠiG ‚^a ‚m‚I{ ƒaˆGfQ †jB„CŠVKLM.",
 1,"I‡JG! G‚W …b‚~S ^ƒa ƒGŒ~o ƒuG ƒa‚PŠb†EƒX. ‚m‚I{ ƒaˆGƒb ‹Qƒt‚b^?",
 91,"Še M ‚l[„S ˆGnŠgKLM.",
 1,"eƒO, ƒa‚P. ƒ[‚_ƒR ‚Z‚[ ƒv‚h ‹XŠg‚wƒv. ‡mƒv¡­¡­ eƒO, ƒa‚P. ƒv‚b ‚C‚C ‚kS ƒuG†B …A…w‚V ƒ[‚_ƒRƒP ƒQq‚h ‹yƒmu‚f.");
 ModifyForce(3,0);
 end
 RemindSave();
talk(175,"‚K‚J, ‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(43,"d3ƒa ƒWS ‚B„e","1. ‡Y†I ‚p…D",40,0,41);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,11,4,4,0,-1,0,
 -1,12,3,4,0,-1,0,
 -1,10,5,4,0,-1,0,
 -1,11,5,4,0,-1,0,
 -1,12,5,4,0,-1,0,
 -1,9,4,4,0,-1,0,
 -1,13,4,4,0,-1,0,
 -1,14,4,4,0,-1,0,
 -1,9,6,4,0,-1,0,
 252,5,4,4,0,-1,1,
 29,6,3,4,0,-1,1,
 43,7,2,4,0,-1,1,
 });
 ModifyForce(252+1,1);
 ModifyForce(29+1,1);
 ModifyForce(43+1,1);
 SetSceneID(0,3);
talk(1,"ƒWSƒm„S g‚ToM.");
 
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=0;
 AddPerson(151,25,17,2);
 AddPerson(45,22,10,1);
 AddPerson(163,20,9,1);
 AddPerson(166,18,8,1);
 AddPerson(148,11,16,0);
 AddPerson(167,9,15,0);
 AddPerson(165,7,14,0);
 SetSceneID(54,11);
 DrawStrBoxCenter("‚IS ƒP‚r‰R");
 DrawMulitStrBox("¡¡G IŠq ‚l[ƒP D„`G ˆY †Q‡Yƒb ‚ISfƒW IƒaƒRfQ …xƒNƒP ‚B‚vS E‚Xaƒd „O„kM.*¡¡‚l[ƒP †J‚_ D„`ƒb ‚K‚G, ƒY†f, b‡~G„kƒd Gd †Q‡YGM. †Q‡Yƒb b‚| ‰jˆlS ‚C‚go ƒLG ‚a„kƒmL G‚W R‚Xƒb †V‚pƒLj _…aG„kM.");
 DrawMulitStrBox("¡¡eƒO^ ˆE‚K‚h ŒOƒb ‚KˆY YVƒb b‡~G nL‚f †Q‡YG„kM. †Q‡Yƒb eƒO‚h „N†daQ „VƒRƒd ƒ[ Œof ˆE‚K‚h Šf„h‚b „T‚uS b‡~fQ …I…e ‚K„kM. b‡~ƒb †Q‡YƒP …jƒGf „^Q „D‚f ƒ[‚h …CRƒm„S ‚s†EPM.");
 MovePerson(45,3,2);
 MovePerson(45,2,1);
 MovePerson(45,3,3);
talk(45,"‚M, D„`. ƒWSf ƒQ‚TS ƒsƒ_‚C ‚kƒmN JFhLY?",
 151,"ƒWSƒb ‚eZa‚C ‚km. ƒ[‡ES ‚C‰J‚b ‡Y†ID ƒ[ ‡FS „a ƒuG[. ƒWSS „qu‚b ƒuƒb O†c^ nL[.",
 45,"I‡JG[! ƒv‚b ‚lƒPX q ‚am!",
 151,"ƒv‚b […CŠ_ƒW ˆum R‚XaƒN D„`G[. ƒ[‚_‚b ƒ_ ‚XS ‚i‚f…E a†B †@ŠH …bFBƒW‚b ‚o „C[.",
 45,"dƒGŠJ¡­¡­ …G‚MS ‚[ƒ`„Ea‚b OŠwG „GƒmL¡­¡­",
 151,"I‚S‚f Pm?",
 45,"nL[, nI ˆ|D a‚C ‚kƒtm.",
 151,"ƒ[ŠQm? ƒ[„KG Šom. dƒaƒRD ƒ_ ‚XS ‚i‚j‚V[. ƒ_ ˆ|ƒb bƒGY‚CZ.");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 41,18,19,3,0,54,20,0,0,-1,0,
 45,14,11,4,4,50,3,21,9,-1,0,
 108,22,7,2,4,49,6,22,4,-1,0,
 109,18,17,3,0,49,6,0,0,-1,0,
 159,17,19,3,0,49,6,0,0,-1,0,
 160,14,17,3,0,50,3,0,0,-1,0,
 173,12,16,3,4,49,25,14,11,-1,0,
 256,18,10,4,4,45,3,22,9,-1,0,
 274,21,9,4,4,45,6,23,2,-1,0,
 292,20,10,4,4,48,9,24,4,-1,0,
 293,19,9,4,4,48,9,24,3,-1,0,
 294,15,12,4,4,48,9,21,10,-1,0,
 295,13,17,3,0,47,9,0,0,-1,0,
 296,16,18,3,0,47,9,0,0,-1,0,
 
 310,13,10,4,0,45,12,0,0,-1,0,
 311,12,11,4,0,44,12,0,0,-1,0,
 336,22,10,4,4,45,15,23,4,-1,0,
 332,19,18,3,0,46,14,0,0,-1,0,
 297,14,12,4,0,47,9,0,0,-1,0,
 348,14,18,3,0,43,19,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [579]=function()
 PlayBGM(11);
talk(1,"dƒaƒRGb, eƒOƒP ƒQq‚h ‹yƒd ‡Y‡b‚TfQ oS ‹E…x!",
 42,"nGƒd¡­¡­ ‚Z‚[ …A…w‚V ‚C‰a ƒ_†B ƒQ‚TS ƒGMƒ`‚f.");
 WarShowTarget(true);
 PlayBGM(12);
 WarShowArmy(29);
 --talk( 30,"Ö÷¹«£¬ÎÒÀ´³ÙÁË£¬¶Ô²»Æğ£®ÎÒÊÇ¹ØÓğµÄ¶ù×Ó¹ØĞË£®*ÎÒ´Ë´ÎÀ´ÊÇÎªÁË±¨¸¸³ğ£¬ÇëÈÃÎÒ¼ÓÈëÕ½¶·£®");
talk(30,"‚K‚J, ‹z‚SƒW b‡pWLM. …f‚b eƒOƒP nƒR e…MhLM. n„q‚CƒP ƒQq‚h ‹yƒd…x ŠXƒmL ‚^ƒZ ‰jˆlf ŠY„E ‚K‡I‚V[.");
 WarShowArmy(43);
talk(44,"‚SŠS d^ e…MfQ ‡D‚C†yKLY? ‚K‚J, …f‚b ƒa‚PƒP nƒR ƒa†ahLM. G‚W ‰jˆlf …fD †~^a†yKLM.");
 WarShowArmy(252);
talk(253,"n„qŠi, …fD …hƒ`^ ‚K‡I‚V[. M„V ‹F{ @†jƒb †~ I†bKLM.");
 PlayWavE(11);
 DrawStrBoxCenter("‚G…m, ƒa†a, e…MG ‚^a^ „C„kM!");
 PlayBGM(14);
 NextEvent();
 end,
 [580]=function()
 if WarMeet(44,110) then
 WarAction(1,44,110);
talk(44,"ƒLƒaƒb ‚SƒZ „O†sŠm! ƒv‚b ƒa‚PƒP nƒR ƒa†aM!",
 110,"[, „p^ ƒa‚PƒP nƒRGŠm. ƒ_^ ‚cJS ƒ_ ‚K…X!");
 WarAction(6,44,110);
 if fight(44,110)==1 then
talk(44,"ŠP‚f!");
 WarAction(8,44,110);
talk(110,"ƒm…v!");
 WarAction(18,110);
talk(44,"ƒLƒaS ƒq„kM!");
 WarLvUp(GetWarID(44));
 else
 WarAction(4,110,44);
talk(44,"ƒm…v!");
 WarAction(17,44);
 WarLvUp(GetWarID(110));
 end
 end
 if WarMeet(30,109) then
 WarAction(1,30,109);
talk(30,"ƒv‚b eƒOƒP nƒR e…MGM. †u^ ƒv‡z „}ƒ^†y†sŠm!",
 109,"Œi‡pG ŒN, ƒSˆc‚C …X‚f! ƒ_^ …yM!");
 WarAction(6,30,109);
 if fight(30,109)==1 then
talk(109,"„p^ e…MGŠm? n„LD n‚P `‚EŠFG†y‚C.",
 30,"ˆvŠP‚f! Gu [H‚f!",
 109,"…yƒR ‚S‹Xa].");
 WarAction(15,30);
talk(109,"†M‹Ff ‹[ƒ_ ‚K…X¡­¡­");
 WarAction(5,109,30);
 WarAction(8,30,109);
 WarAction(18,109);
talk(30,"G‹@ …x^ ‡NŠW ƒnmu‚h „Q†sŠm?");
 WarLvUp(GetWarID(30));
 else
talk(109,"„p^ e…MGŠm? n„LD n‚P `‚EŠFG†y‚C.",
 30,"ˆvŠP‚f! Gu [H‚f!",
 109,"…yƒR ‚S‹Xa].");
 WarAction(15,30);
talk(109,"†M‹Ff ‹[ƒ_ ‚K…X¡­¡­");
 WarAction(4,109,30);
talk(30,"‚_†Ma‚wƒv!");
 WarAction(17,30);
 WarLvUp(GetWarID(109));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(42,"ƒd‡Co ŒN! ¡­¡­…C…Da‚f!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG ‡Y†I‚TS „^Q I‹xŠjM.");
 GetMoney(1400);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£´£°£°S ƒYƒC!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [581]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(175,"ƒ[†{ ƒWSƒ{ƒm„S ƒR‚S^‚V‚CZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<½øÎ÷Áê³Ç>
 NextEvent();
 end,
 [582]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=0;
 AddPerson(151,25,17,2);
 AddPerson(45,22,10,1);
 AddPerson(163,20,9,1);
 AddPerson(166,18,8,1);
 AddPerson(148,11,16,0);
 AddPerson(167,9,15,0);
 AddPerson(165,7,14,0);
 SetSceneID(54,11);
 AddPerson(369,-5,2,3);
 MovePerson(369,10,3);
talk(369,"‡Y†I‚TG ‚G‚PfQ OB G‹Jƒm„S ƒA…eƒvƒd „OKLM.",
 151,"‡Y†Iƒb ‚SŠS „C„km?",
 369,"I‚ra‡ILM.",
 151,"ƒ[ŠQm? M‚]G[. qƒdPm.",
 369,"ƒA…e^†yKLM.");
 MovePerson(369,12,2);
 DecPerson(369);
 MovePerson(45,3,2);
 MovePerson(45,2,1);
 MovePerson(45,3,3);
talk(45,"I‡JG M‚]G[, ƒOu^ Oo ƒuG nL[!",
 151,"G‚W O†c‚b ƒ_ kC ‚of „O„km. ‰p[, ‚G‚P‚Tƒb ‚rƒG^ ƒi‚f ƒ[ ƒGƒo‚h ‡fS q ‚am. „F‚C„S ŠGƒWA ƒOu ‚TƒP ‡YNG †F ƒuG[.",
 45,"¡­¡­",
 151,"FAƒm„S ŠGƒW†sL ƒ[ ˆl„LRS ‚C‰aƒs‚b „KG ‹om. Šc‚C‚kn …fƒRƒb ‚C†R ƒuG[. ƒ[„U „QA …A…w‚V „_S q „Om.",
 45,"ƒ[ƒuG ˆAdG†yKLY?",
 151,"‚Z‚j[. ‚[ B^ Š} qD, ƒo B^ Š} qD „Om.",
 45,"D„` ‚Ea!",
 151,"aaa, ˆNG[. Šc‚C‚kn ‚G‚P‚Tƒb ƒGMuM ˆfB ‚ISS „Q…e ƒi ƒuG[. ƒ[„U^ ƒU„S ƒOu^ †R „UZ.",
 45,"¡­¡­");
 NextEvent();
 end,
 [583]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒWS";
 JY.Base["D‚wC"]=22;
 AddPerson(1,9,9,3);
 if GetFlag(135) then
 AddPerson(3,9,12,3);
 end
 AddPerson(253,15,9,3);
 AddPerson(175,20,9,1);
 AddPerson(30,22,10,1);
 AddPerson(170,9,15,0);
 AddPerson(44,11,16,0);
 SetSceneID(49,5);
 DrawStrBoxCenter("ƒWS ƒP‚r‰R");
talk(175,"‚K‚J, d‡y†ZG ‹pƒG‚h ‰RWLM.",
 1,"‡O ŠX‚T. ƒR‚f a‚f.",
 175,"k.");
 AddPerson(146,41,25,2);
 MovePerson(146,12,2);
talk(146,"‚G‚PŠi, G d‡y†ZG ‡O ŠXKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<»Ø´ğÖî¸ğèªµÄ½áÃËÌá°¸>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [584]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, †Cƒb G†w FBˆk „O‚C ‚kKLY.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‚K‚J, d‡y†Z{ ˆ|Š[S ƒv†u‚V‚CZ.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"ZŠr ŠLƒbGƒRG AA ƒS†B ‰{ˆGn ‚JS ƒoƒO‚b‚T. ƒ_^ ŠR‚S „P‚Z‚a‚Sg ƒuj^¡­¡­");
 end
 if JY.Tid==253 then--Áõìø
talk(253,"n„qŠi, G‡Eƒb …d„KWLM.");
 end
 if JY.Tid==30 then--¹ØĞË
talk(30,"n‚P‚h …Gj ƒQq‡z‚b o aƒXS Gƒd †j q ‚aKLM. ‚K‚J, G…x‚h ƒqD…l ‡mˆyB ‚K‡I‚V[.",
 1,"nL ˆYM. ƒ[‚b ‚J‚XƒP ˆEŠiGL †~n‚f.");
 end
 if JY.Tid==44 then--ÕÅ°ú
 if GetFlag(135) then
talk(44,"e…MƒP n„q‚C^ ‚l[fQ …G„kƒmL G‚_„S ƒA…eE q ‚aKLM.");
 else
talk(44,"n„q‚C^ ‚l[ƒP ‡Yf ‰Bn^ŠVƒmL †@ŠH …fƒRS „oƒWX q ‚aKLM.");
 end
 end
 if JY.Tid==146 then--Öî¸ğèª
talk(1,"‡O ‚l†_ „U…Zf †[ ƒuG†y‚C.");
 if GetFlag(135) then
talk(146,"…fŠs ‚K‚JŠ_ƒW ‚n‡z ‚l†_o ƒuS Œ[‚V …C‚}a‡ILM. ab ‚n‡z …Y„Waƒd ‡{{ ‚l†_B @ˆja†B ‚[ ƒv‚fƒP ƒOƒP‚h ‚[ƒhG aƒd…x a‡ILM. ‚G‚PŠi, ‚S‹Xa‡ILY?",
 1,"¡­¡­");
 else
talk(146,"ƒ[ŠQKLM. …fŠs ‚K‚JŠ_ƒW‚b ƒa‚PŠiS Bˆj rq‚h ‡{f „|ƒGƒd ˆE‚KD ‰Bƒ`…wuƒd…x a‡ILM. ‡{{ ‚l†_B @ˆja†B ‚[ ƒv‚fƒP ƒOƒP‚h ‚[ƒhG aƒG‚h ƒU‚f‡ILM. ‚G‚PŠi, ‚S‹Xa‡ILY?",
 1,"¡­¡­");
 end
 NextEvent();
 end
 end,
 [585]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, †Cƒb G†w FBˆk „O‚C ‚kKLY.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‚K‚J, ‡Y†IG Gˆa‚b ‡Y‡b‚TS „^Q „_„kƒmL ‚S†s FD‚b oS ‰f ghLM. †EƒGf ƒ[ †JƒLƒRY‚C ‹nˆEoMA ƒQoƒb „l …g‚C ‚kKLM. ab …f‚b [‡z ‚l†_B…E oMƒd ‹bLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"ZŠr ŠLƒbGƒRG AA ƒS†B ‰{ˆGn ‚JS ƒoƒO‚b‚T. ƒ_^ ŠR‚S „P‚Z‚a‚Sg ƒuj^¡­¡­");
 end
 if JY.Tid==253 then--Áõìø
talk(253,"n„qŠi, G‡Eƒb …d„KWLM.");
 end
 if JY.Tid==30 then--¹ØĞË
talk(30,"n‚P‚h …Gj ƒQq‡z‚b o aƒXS Gƒd †j q ‚aKLM. ‚K‚J, G…x‚h ƒqD…l ‡mˆyB ‚K‡I‚V[.",
 1,"nL ˆYM. ƒ[‚b ‚J‚XƒP ˆEŠiGL †~n‚f.");
 end
 if JY.Tid==44 then--ÕÅ°ú
 if GetFlag(135) then
talk(44,"e…MƒP n„q‚C^ ‚l[fQ …G„kƒmL G‚_„S ƒA…eE q ‚aKLM.");
 else
talk(44,"n„q‚C^ ‚l[ƒP ‡Yf ‰Bn^ŠVƒmL †@ŠH …fƒRS „oƒWX q ‚aKLM.");
 end
 end
 if JY.Tid==146 then--Öî¸ğèª
 if talkYesNo( 146,"‚G‚PŠi, FaŠVKLY?") then
 RemindSave();
talk(146,"‚G‚PŠi, ‚S†A †CS ‚K‚V†yKLY?");
 local menu={
 {"¡¡ ‚l†_oM",nil,1},
 {"¡¡‚l†_a‚C ‚k‚bM",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(146,"[, ‡N‚rWLM. ‰bƒU„S […CŠ_ ƒGk m‚yS ‚Ba†yKLM. G‚b [ƒv‚fƒP Jƒb Fƒ{GL …Hn ‚K‡I‚V[.");
 GetItem(1,63);
talk(146,"ƒ[†{ ‰bƒU„S ‰Bn^ …fŠs ‚K‚JŠ_ n„b†yKLM.");
 MovePerson(146,14,3);
 DecPerson(146);
talk(175,"‚K‚J, ŒRƒb †@†MS ƒ_uŠVKLM. ‡mƒv …{ƒm„S‚b Œ[‚V ‡w„SƒO‚V†y‚CZ.",
 1,"¡­¡­[ƒv‚f^ …OƒG‚b aƒv ‚Cƒgƒb eƒO‚h …jRX „}‚hG ‚am. ‚Cƒgƒb v‚P‚h „Qƒd oNS „C†jƒ`…E a[.");
 SetFlag(136,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(592); --goto 592
 elseif r==2 then
 PlayBGM(12);
talk(1,"d‡y†Z, ƒ_ †Cƒb ˆG‚f‚C‚C ‚kƒtm. ƒ[„V ‰Bn^‚V[.",
 146,"‚G‚PŠi, ‚^ƒZ ƒN‚eŠW ŠInƒ` ‚K‡I‚V[.",
 1,"ƒ[ ˆ|„S‚b ƒv‚h EƒDX q ‚am. ‰Bn^‚V[.");
 MovePerson(146,14,3);
 DecPerson(146);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end
 end,
 [586]=function()
talk(175,"‚K‚J, ‚Cƒgƒb …fƒR{ @ˆjaŒs…E WLM.",
 1,"„l ˆ|a‚C …X‚V[. ƒ_ ƒ]ƒb G†w FBƒFm.",
 175,"¡­¡­„a†yKLM. ƒ[†{ ‚J‚pS †Xua‚V‚CZ. [ƒP D„`ƒb †Q‡YG‚f WLM.",
 1,"†Q‡YG‚f? ƒR‚S „v ƒLG ‚a‚wƒ`.",
 175,"GŠKƒb „^‚C ‚kƒmƒv ‚C‚vG ‰Kƒb jƒAG‚f ƒR„kKLM. ‚K‚J, ‹BƒsŒsƒW‚b ‚o ŒjLM.");
talk(175,"‚_‚AS ‹s…c‡I‚V[.");
 WarIni();
 DefineWarMap(44,"d3ƒa GS ‚B„e","1. †Q‡Y ‚p…D",50,0,150);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,4,11,4,0,-1,0,
 -1,5,12,4,0,-1,0,
 -1,6,11,4,0,-1,0,
 -1,6,18,4,0,-1,0,
 -1,7,19,4,0,-1,0,
 -1,6,12,4,0,-1,0,
 -1,8,12,4,0,-1,0,
 -1,9,11,4,0,-1,0,
 -1,5,17,4,0,-1,0,
 -1,5,19,4,0,-1,0,
 -1,2,10,4,0,-1,0,
 -1,3,10,4,0,-1,0,
 -1,2,11,4,0,-1,0,
 -1,3,12,4,0,-1,0,
 -1,3,16,4,0,-1,0,
 53,1,15,4,0,-1,1,--ÕÔÔÆ
 });
talk(1,"…bFa†yKLM.");
 JY.Smap={};
 SetSceneID(0,3);
talk(1,"ƒLƒb ‚ISf „OM. ‚SƒW ‚i‚j‚f!");
 SetSceneID(0,11);
talk(151,"I‡JG! ‚G‚P^ ˆl„LŠbMƒd. [†G ƒGM„~M. ‚CƒgG…Eˆ|„S ‚G‚P‚h IH„]„u …Y†qƒP „UM. ‚B‚T, GSƒm„S g‚Ta‚f!");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 150,29,16,3,0,56,16,0,0,-1,0,
 44,27,17,3,0,52,3,0,0,-1,0,
 162,20,18,3,1,53,9,0,0,-1,0,
 147,29,10,3,0,53,14,0,0,-1,0,
 166,27,10,3,0,53,9,0,0,-1,0,
 165,26,10,3,1,53,3,0,0,-1,0,
 164,26,16,3,0,52,3,0,0,-1,0,
 173,22,10,3,3,52,25,0,0,-1,0,
 107,29,12,3,0,51,3,0,0,-1,0,
 45,29,15,3,0,52,3,0,0,-1,0,
 155,30,17,3,0,51,3,0,0,-1,0,
 156,24,18,3,0,51,3,0,0,-1,0,
 157,18,19,3,1,51,6,0,0,-1,0,
 158,23,9,3,1,51,6,0,0,-1,0,
 
 274,18,11,3,1,45,6,0,0,-1,0,
 275,17,18,3,1,45,6,0,0,-1,0,
 276,22,19,3,1,44,6,0,0,-1,0,
 292,20,7,3,1,50,9,0,0,-1,0,
 293,21,16,3,1,50,9,0,0,-1,0,
 294,29,13,3,0,50,9,0,0,-1,0,
 310,19,17,3,1,45,12,0,0,-1,0,
 311,26,18,3,0,45,12,0,0,-1,0,
 340,21,9,3,1,44,17,0,0,-1,0,
 341,28,8,3,0,45,17,0,0,-1,0,
 
 295,17,10,3,1,49,9,0,0,-1,0,
 296,17,12,3,1,49,9,0,0,-1,0,
 297,17,16,3,1,49,9,0,0,-1,0,
 298,24,17,3,1,48,9,0,0,-1,0,
 299,24,8,3,1,48,9,0,0,-1,0,
 300,22,12,3,1,48,9,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [587]=function()
 PlayBGM(11);
talk(151,"‡m‡m‡m. ‚J‚XG bƒG ‚a‚b ƒuƒb †~ƒm„S aƒXG ƒv‚h ‰I‚b ƒuG[. ƒ_ ‚B‚vS …y†VX …x‚b ƒ[ŠFGL. ‚G‚P‚b †~ƒm„S ‚Su„Z‚S ‚TS Gˆnƒd I‚ZaQ ‹hƒd ƒR‚S[‚b‚T. ‚G‚PƒP ‡SD Mo ‡Ka[.",
 45,"D„`, ƒU†vG …IƒG ‚VJWLM.",
 151,"Šom. G‡Eƒb ƒU†vG ‚Cƒv‚b ‡EG†B ‚CƒoD rm. ƒv‚b bƒGƒW ‚G‚P‚h ƒGMu†ym.",
 45,"D„`ƒP ˆ|Š[G ‚C‡iWLM. ¡­¡­D„`, G‰S…l ‡^o „T‚uS ‚CLŠV†EƒX d^ I‹~‚h ‚mPKLM. †~ƒm„S ‡p‚wWLM.",
 151,"‹km. ƒ[ G…EƒG‚b G ‰jˆlS …X„Qƒd BD ‹z‚C ‚km. ŠoM, …dS ‹^n‚f! ‚G‚P‚TS ‚Zvu ‚|„E‚f!");
 WarShowTarget(true);
 PlayWavE(51);
 WarFireWater(0,8,1);
 WarFireWater(1,8,1);
 WarFireWater(2,8,1);
 WarFireWater(3,8,1);
 WarFireWater(4,8,1);
 WarFireWater(5,10,1);
 WarFireWater(6,10,1);
 WarFireWater(7,10,1);
 WarFireWater(10,10,1);
 WarFireWater(11,10,1);
 WarFireWater(12,10,1);
 WarFireWater(6,13,1);
 WarFireWater(7,13,1);
 WarFireWater(8,13,1);
 WarFireWater(9,13,1);
 WarFireWater(10,13,1);
 WarFireWater(0,16,1);
 WarFireWater(2,17,1);
 WarFireWater(3,17,1);
 WarFireWater(4,18,1);
 WarFireWater(6,17,1);
 WarFireWater(7,17,1);
 WarFireWater(8,20,1);
 WarFireWater(9,20,1);
talk(175,"‚K, ‚K‚J. ƒn…IhLM! ƒLG @‚JS ƒILM.",
 1,"‡m¡­¡­ ‚Cƒgƒb ‚Tƒo^ ‡Aƒb ƒuG Du‚S ‰cG „C‚b‚wƒv. ‹I†rG ‡yq…l rngM.");
 WarEnemyWeak(1,1);
 WarEnemyWeak(1,1);
 WarEnemyWeak(1,2);
talk(151,"G†r „U^ ŠXM! ‚G‚P‚h ‹^„Q‚C …X‚f! [ƒv‚fƒP ‡S‚XG G o ‰jˆlf ˆG„~M!");
 PlayBGM(10);
 NextEvent();
 end,
 [588]=function()
 if WarMeet(163,35) then
 WarAction(1,163,35);
talk(163,"Gw ŒyŠm? G ‚^‚_‚b? ‚Kƒaƒb †u‚wŠm?",
 35,"ƒ_^ ‚KƒaGM.",
 163,"‡m, „V„RG„S‚T. o„If ‰}D „V„RGM. „V„Rƒb ‹n‚M ƒs‚b‚T. ŠoM, ƒv‡z „}ƒ^…x.",
 35,"ŠoM, [H‚f!");
 WarAction(6,163,35);
 if fight(163,35)==1 then
talk(163,"…Hn‚f! ‚SŠS ‡fƒG„V a†sŠm.");
 WarAction(5,163,35);
 WarAction(19,35);
talk(35,"nGƒd¡­¡­ HI ‚C‡R‚wƒv¡­¡­",
 163,"‚SŠS ˆY ƒuGŠm, ˆu„D‚OG Gu †suŠm?");
 WarAction(9,163,35);
talk(35,"‰u! G ŒZ q‚b ‚S‹XŠm?");
 WarAction(4,35,163);
 WarAction(4,35,163);
talk(35,"aa¡­¡­",
 163,"‚Cˆj ‚Z†oG‚wƒv. ƒ_^ ‹]Q B ‚K…X.");
 WarAction(8,163,35);
talk(35,"…v¡­¡­!");
talk(35,"ƒ_ ‚XD bƒGY‚C‚wƒv¡­¡­");
 WarAction(18,35);
 ModifyForce(35,0);
 WarLvUp(GetWarID(163));
 else
talk(35,"‰u! G ŒZ q‚b ‚S‹XŠm?");
 WarAction(4,35,163);
talk(163,"…v¡­¡­!");
 WarAction(17,163);
 WarLvUp(GetWarID(35));
 end
 end
 if (not GetFlag(1063)) and War.Turn==5 then
talk(151,"aaa, ƒG‚}‚h ‹^†R q ‚aM! ‚B‚T ‡T‚J‚p! ‚G‚P, G‚W‰` ˆGnƒS `‚E …X‚f.");
 WarModifyAI(150,3,0);
 WarModifyAI(44,1);
 WarModifyAI(162,3,34);
 WarModifyAI(147,1);
 WarModifyAI(166,3,0);
 WarModifyAI(164,1);
 WarModifyAI(107,1);
 WarModifyAI(45,1);
 WarModifyAI(155,1);
 WarModifyAI(156,1);
 WarModifyAI(294,1);
 WarModifyAI(311,1);
 WarModifyAI(341,1);
 SetFlag(1063,1);
 end
 if (not GetFlag(1064)) and War.Turn==3 then
 WarShowArmy(53);
 WarModifyAI(53,3,0);
talk(54,"‚K‚J, ‡i‚Ua‚C …X‡I‚V[. v‡SG ŠXKLM!");
 SetFlag(1064,1);
 end
 if JY.Status==GAME_WARWIN then
talk(151,"†~ƒm„S ‡SG ‚a‚wƒv! ‚Z‹n†{ ‹Qƒb ƒG‚}Šb†EƒX¡­¡­ ‚B‚T …C…D!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡†Q‡YG ƒA…eƒvƒd ‚G‚P‚TG †Q‡Y‚TS G‹HM.");
 GetMoney(1400);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£´£°£°S ƒYƒC!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(591); --goto 591
 end
 if JY.Status==GAME_WARLOSE then
 PlayBGM(4);
talk(1,"‡m, ƒ_^ bƒGƒW …G‚b†M ˆ|j^¡­¡­",
 30,"‚K‚J, ƒG‡SS ƒ_‡I‚V[! †edƒ{ƒm„S ƒA…eƒv‚V‚CZ.",
 44,"…fŠs^ ‡D‚h ‡f†yKLM. ‚K‚J, ‚SƒW ƒA…eƒv‡I‚V[!",
 1,"[, e…M, ƒa†a. ŠoM, †edƒ{ƒm„S ƒA…e‚qM.",
 151,"‚G‚P‚b ‚SŠS „C„k†sŠm? ƒsƒt†sŠm? I‡JG! ‹^‡RMƒd¡­¡­ „C„kM. ‚G‚PfQ‚b Gd „@G ‚aM. ‚Cƒg ^ƒa …X‚Mf ‚@u‚b ƒuƒb ‚nƒv‚fM. ŠoM, ‚B‚T Œa‚V ‚n‚Tf ‚_‚Pa‚f.");
 DrawMulitStrBox("¡¡‚G‚P‚b †edƒ{ƒm„S ƒA…eŠgM.");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [589]=function()
 JY.Smap={};
 SetSceneID(0);
 if GetFlag(135) then
talk(3,"ƒnˆEŠi, I‚ra‡ILY.",
 1,"H„S‚wƒv, ƒa‚P. †w‚oaM¡­¡­ eƒOƒP ƒQq‚h ‹y‚C ˆfPM.",
 3,"ƒnˆEŠi, ‚[ƒ`„E …X‡I‚V[! eƒO ˆEŠiƒb n„L †jn „T‡ILM!",
 1,"‡m¡­¡­ ‡m¡­¡­ ƒmŒF!",
 3,"n, ƒnˆEŠi. ƒG‡SS „yu‡I‚V[!");
 else
talk(1,"eƒO, ƒa‚P. †w‚oa‚wƒv. HŠs ƒQq‚h ƒq‚C ˆfPƒmL G ƒnˆES „oƒWB M[¡­¡­");
 end
 NextEvent();
 end,
 [590]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†edƒ{";
 JY.Base["D‚wC"]=0;
 if GetFlag(135) then
 AddPerson(3,19,14,2);
 end
 AddPerson(126,17,15,2);
 AddPerson(54,15,16,2);
 AddPerson(190,21,15,2);
 AddPerson(170,19,16,2);
 AddPerson(127,17,17,2);
 SetSceneID(82,2);
 RemindSave();
 if GetFlag(135) then
talk(1,"ƒa‚P, †w‚oa‚wƒv. eƒOƒP ƒQq‚h ‹y‚C ˆfPM¡­¡­",
 3,"ƒ[ I‡H ˆ|Š[G‡ILY! ƒnˆEŠi, ‚^ƒZ! …f ‚c…x„V …gƒG‚C …X‡I‚V[.",
 1,"aaa¡­¡­ H‚b ˆAdY‚Cƒv ƒ{†w^ †Pa‚wƒv¡­¡­ ƒa‚P, ƒ_ ‚sqD Mo ‡KaM.",
 3,"ƒnˆEŠi, ƒG‡SS „yu‡I‚V[!");
 end
talk(1,"‚J‚X, ƒ[‚_ ‡V‡Lf o‚eS …V„kƒd [ƒXƒP }AD „O‚b ƒuG[.",
 1,"G‚Wf ƒ[‚_ƒP „V]‚h Š^‚C ‚kƒd ‚l[‚h „Q…e ‰tM^ G‰S…l †~OPƒmL, G‚b „iƒsZ.");
 if GetFlag(135) then
 MovePerson( 3,2,2,
 126,2,2);
 else
 MovePerson( 126,2,2);
 end
talk(126,"‚K‚J, ƒ[‹@ `‚Eƒb †E‚[‡I‚V[. …f‚b †M o ‚WD ‚K‚JS ƒQˆoo ƒLG ‚aKLM.",
 1,"‡m¡­¡­ ‚J‚X, o ^‚C ‚^…aG „Om.",
 126,"I‡H …IG‡ILY?",
 1,"aƒXG ƒv‚h ‚^‚j‚b‚wƒ`. ‚G…mfQ …xu‚h ‰{Q X `‚EG[. ‡mƒv ‚G…mG ƒ[qG ˆf „C†Eˆe „sZX „U ƒ[‚_^ ‚_ƒNa‚V[. ‚J‚X, v‚P‚h ‚aL q „O‚b G‚b ƒ[‚_ŠFG[.",
 126,"‚K‚J, ƒ[‹@ ˆ|Š[ …X‡I‚V[. G ‚J‚X, …G‚Mƒm„S ‡{f ‡tƒ{a†yKLM. ˆUˆU¡­¡­",
 1,"ƒdŠOm. ¡­¡­v‡S, [ƒXY‚C ƒdˆyS ‰HŠ_P‚b…h bƒGƒW JŠZaƒ`L †~ƒm„S ƒWt‰g[.",
 54,"‚K, ‚K‚J¡­¡­");
 if GetFlag(58) then
talk(1,"‚Z‚[ „@S MB ‚G…mS ƒs„sB ‚KƒG ƒU‚f[.",
 126,"‚K‚J! ‚K‚J¡­¡­!",
 54,"ˆU¡­¡­ ˆU¡­¡­!");
 end
 if GetFlag(135) then
talk(3,"ƒnˆEŠi! ‚SŠS …f„V ƒ_„qƒ` ‚[ƒd ‰Bnƒs‚C ‚kƒm‡ILY!");
 end
 if not (GetFlag(58) or GetFlag(135)) then
talk(1,"¡­¡­†w‚oa[. ‡d‚V ‚c…x „OQ B ‚K‚V[. ‹D ‚C‡Rm¡­¡­",
 126,"¡­¡­k, ƒNƒb ƒA…e^†yKLM¡­¡­");
 MovePerson( 126,2,3);
 MovePerson( 126,15,3,
 54,15,3,
 190,15,3,
 170,15,3,
 127,15,3);
talk(1,"…CƒO¡­¡­. ¡­¡­¡­¡­‚M? †u‚wŠm?");
 AddPerson(2,15,16,2);
 DrawSMap();
talk(2,"ˆEŠi, ‚Z‚V…e ŠXKLM.",
 1,"[, eƒO! †jn „O„k‚wƒv!",
 2,"n‚`LM, …f‚b G†w …G„kKLM. ƒa‚PD¡­¡­");
 AddPerson(3,19,14,2);
 DrawSMap();
talk(3,"ƒnˆEŠi, …f‡z eƒO ˆEŠiƒb ‰q…f G‡Ef ‡z „OKLM. ƒnˆEŠiD ‚C„QŠV‚CZ. ‚S‹cKLY, Gu„S [‚V†yKLY?",
 1,"ƒ[ŠQ‚wƒv¡­¡­. ŠoM¡­¡­.");
 MovePerson( 126,7,2)
talk(126,"[, GQ ‚SŠS ˆY …Ij^! ‚SŠS¡­¡­ eƒO? QM^ ƒa‚PY‚C!");
 MovePerson( 126,4,2)
talk(2,"ˆEŠi, ^‚V‚CZ¡­¡­",
 126,"‡dŠu! eƒOŠi, ‚^ƒZ ‰Ra[L n„L ‚K‚JS G ƒoCfƒW …hƒ`^‚C …X‡I‚V[!");
 DecPerson(2);
 DrawSMap();
 MovePerson( 126,3,2)
talk(3,"ƒnˆEŠi, …fŠs^ ƒGMuƒd „OKLM¡­¡­.",
 126,"‚K‚J!!");
 DecPerson(3);
 MovePerson( 126,3,2)
talk(126,"‚K‚J! ‚^ƒZ M‚V `‚Ea‡I‚V[!",
 1,"eƒO, ƒa‚P. Gd ^…x¡­¡­.",
 126,"¡­¡­! ‚K‚J!! ‚K‚J¡­¡­!!");
 DrawSMap();
 end
 DrawMulitStrBox("¡¡ƒWƒG £²£²£³‰z, ‚G‚P‚b oNS „C†ju‚b ‚_†nS Gƒ^‚C ˆfo …^ ƒoCS ‹XŠgM.");
 RemindSave();
 NextEvent(999); --goto ???
 end,
 [591]=function()
 JY.Smap={};
 SetSceneID(0,11);
talk(151,"I‡JG, v‚P^ ŠPƒR‚S†[Mƒd? ƒn…IGM! n„L ‡{S ‚aŒi‚CD ˆfPM. G‚WfD ‚r…x‚h ƒsƒ_ ‡{{ ‚l†_B…E†y‚wƒv. ‚SƒW [„S ‰Bn^‚f!");
 SetSceneID(0,3);
talk(1,"†~ƒm„S ‚n‚|„SfKLM. †Q‡YG‚f‚b …x, ‹B…R q ‚aKLM.",
 175,"‚K‚J, †Q‡YD ƒA…eŠgƒmL ƒ{D„S ‰Bn^‚V‚CZ. ƒ[‹@ ‡D tCƒP ƒ]‚_„S [‡z ‚l†_a‚b ƒuG ‚S‹c†yKLY?",
 1,"ƒ_^ o„UƒP ƒYbˆlƒm„S ƒn ŠUˆfS …f‹T…e ƒ[‰S…l ‡Aƒb ƒaq‚h ŒO„km. ¡­¡­[‡z ‚l†_W‚VM.");
 NextEvent();
 end,
 [592]=function()
 ModifyForce(126,1);
 ModifyForce(54,1);
 ModifyForce(190,1);
 ModifyForce(204,1);
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d4ƒa¡¡ˆE‚K Šx†I";
 DrawStrBoxCenter("d4ƒa¡¡ˆE‚K Šx†I");
 LoadPic(26,1);
 --DrawMulitStrBox("¡¡Áõ±¸ÎªÏûÃğÎº¹ú²ÜØ§£¬ÒÑÓë¶«Îâ½áÎªÍ¬ÃË£®*¡¡Ò»ĞÄÏë¸´ĞËººÊÒµÄÊñ¹ú£¬ÓëÍıÏëÀ©ÕÅÁìÍÁµÄÎâ¹ú£¬¸÷»³¹íÌ¥µÄÁ½¹úÖÕÓÚÁªÊÖ£®*¡¡Êñ¹úÖØ³¼£¬¼¯ÖĞµ½³É¶¼»áÒéÌü£¬¹²Ä±´ò°Ü²ÜÎºµÄ´ó¼Æ£®");
 DrawMulitStrBox("¡¡‚G‚P‚b ‚nƒP v‚P‚h ‚aŒiƒd…x ‚l[‡z ‚l†_S Šh„kM.*¡¡oN ‚^…M„VS ƒU‚f‚b ‡{{ ~‰S iƒaS ƒYu‚b [, ƒW„S …{gG M‡M ‚[ ƒv‚f^ …Xƒlƒ_ ‡YS ‹Qƒb ƒuGM.*¡¡‡{ƒP ‚eƒNƒRƒb ƒ{D †X‚Bf ‚Zb v‚n‚h „_S ‚_„T‚h bƒPPM.");
 LoadPic(26,2);
 NextEvent();
 end,
 [593]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒ{D";
 JY.Base["D‚wC"]=21;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 if GetFlag(135) then
 AddPerson(3,19,9,1);
 end
 AddPerson(170,23,11,1);
 AddPerson(175,9,14,0);
 AddPerson(203,13,16,0);
 SetSceneID(56,5);
 DrawStrBoxCenter("ƒ{D †X‚B");--³É¶¼»áÒéÌü
 if GetFlag(132) then
talk(126,"‚K‚J, eƒOƒP nƒR e…M{ ƒa‚PƒP nƒR ƒa†a^ ‹pƒG‚h ‰RWLM.",
 1,"[, ‚SƒW ƒR‚f a‚f.",
 126,"k. ƒa†a, e…Mƒb ƒR‚f.");
 AddPerson(44,37,22,2);
 AddPerson(30,35,23,2);
 MovePerson( 44,11,2,
 30,11,2);
talk(44,"…f‚b ƒa‚PƒP nƒR ƒa†ahLM. ‹Iƒm„S n„q‚C‹n†{ ‚K‚JS ‚nB ƒc…~S ƒU„Q†yKLM.",
 30,"…f‚b eƒOƒP nƒR e…MhLM. ƒa†a‡z …X‡Z^‚CGL ‚K‚JŠ_ƒW ŠU Gˆn‚S ‚K‡I‚V[.",
 1,"‚[ ‚r†v ‚Z‚[ n‚PƒP †S‚Z^ „O‚wƒv. ‹Iƒm„S ŠUB ƒsn‚f.",
 44,"k. ƒNƒRƒb ƒA…e^†yKLM.");
 ModifyForce(30,1);
 ModifyForce(44,1);
 PlayWavE(11);
 DrawStrBoxCenter("ƒa†a‡z e…MG n‚Tf ^†iPM!");
 MovePerson( 44,12,3,
 30,12,3);
 AddPerson(253,37,23,2);
 MovePerson(253,11,2);
talk(253,"…f, n„qŠi. …fD M qƒmL ‰jˆlf ƒv^…E WLY?",
 1,"ƒ_^ H‚h ‚^‚_f †p‚bMA ‡i…BŠW ‰j„E…E‚C. ŒkƒmŠm?",
 253,"n, n‚`LM! ƒ[‹@ ƒ]ƒb¡­¡­ „a†yKLM, …f‚b ƒA…e^†yKLM¡­¡­ †~ ƒ{^‚V‚T¡­¡­");
 ModifyForce(253,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚G…mG ƒNa„S ^†iPM!");
 MovePerson( 253,12,3);
talk(1,"‚J‚X, GuBD „C†ym?",
 126,"‹Iƒm„S ŠU †r…e ƒ_‚C ‚kƒmA ƒn ƒ[qG „CƒG ‚SŠq†yKLM. n„L ‚BŠwƒP z„`‰HS ‚Z‚j‚b ‡KWLM. ‚K‚J, ‚i„S ŒIŠW CƒP…w„u …IG „OKLM¡­¡­");
 end
 MovePerson(126,0,2);
talk(126,"‚l[‡z ‚l†_PƒmL Gd ƒLƒb ‚nƒv‚fŠFhLM.",
 1,"‚M, …A…w‚V ‚n‚h ŠP oNS „C†jƒ`…E a[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÒé½ñºóĞĞ¶¯£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [594]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"Še[ ˆEŠiƒP ƒQq‚h ŠkS q‚b ‚aƒmƒv oN ‚^…MG ƒmZ^‚b …IhLM. Še[ ˆEŠiD ‡L‚X ƒ[u `‚EaN ƒuhLM.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‚SƒW ‚n‚h „Q‚V‚CZ.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"…Xƒlƒ_ †@‚BƒP „U^ ŠXKLM. d ‹MƒT‚h ‚C‰a‰} ‚K‡I‚V[.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"…Xƒlƒ_ †@‚BƒP „U^ ŠXKLM. d ‹MƒT‚h ‚C‰a‰} ‚K‡I‚V[.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‚nƒP „Y†oƒm„S ^‚b †rƒb ŠehLM. aƒv‚b ˆE‚KƒP †o†oS ‚Cƒv‚b †rGƒd, M‡M aƒv‚b o‚efƒW e‚eƒP ƒa‚oS †E„Q‚b †rhLM.");
 DrawMulitStrBox("¡¡d‡y„XG ˆ|o ¡±e‚e¡±ƒb ‚G‚P^ G†w „y‚Co o‚eG nL‚f ƒ[ ‡k‹JS ^u‰mM.*¡¡ƒa‚o{ g†g ‚[ Z‡tG „OM.");
talk(126,"ˆE‚K‡z e‚e ‚Z‚[ ‚nƒP Fk^ ‚C‰Jƒd „OKLM.",
 1,"ƒ[ŠQ†y‚C. ‚J‚X, ‚SŠS „Q‚b ƒuG C‚uG‚f ƒs[?",
 126,"‚l[‡z ‚l†_o GC †o†o ‹Jƒm„S ‚l[‡z ‰HŠ_ „Q‚b ƒuG C‚uhLM. M„V ƒ[uaA o‚eG ‡mƒHB‚CL e‚ef ƒGK‚_‚h ƒsƒ_ ƒ[‡EfƒW ‚n‚TS ŒEƒR‚S ‚[‚S…E WLM.",
 1,"‚T‚rƒP ˆ|Š[G ‚C‡iWLM. ‡mƒv ƒOu ‚Tƒb ‚n‚TƒsM ‚~ƒ}G ƒLƒb…h ‚[ ‡y†G„S ƒv†uA ‚n…Ua‚C ‚k†yKLY?",
 126,"…fD ŠInƒ` ƒsƒtKLM. ƒGK‚_ƒP ‚Kƒaƒm„S‚b …A…w‚V ‚XˆMaƒd ‚Io jƒAS ƒsƒ_…E WLM. ƒGK‚_‚h ƒs‰M‚C b‚^‚b ‚K‚JŠ_ƒW ‰KG ŠInƒ` Fa‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<¿¼ÂÇÊÇ·ñÅÉÆæÏ®¶ÓÈ¥¹ØÖĞ£®>
 NextEvent();
 end
 end,
 [595]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"e‚ef ‚~ƒ}S ƒsƒ_‚b ƒuƒb Šoƒmƒv ƒ[uaA¡­¡­ ‚TS ƒvB…E a‚b…h, ƒvS „Vo j…X^ ‚SƒZ „OKLY?");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"ƒ[ŠQKLM¡­¡­ ‚T‚rƒP ˆ|Š[‚_„S …fD ‚~ƒ}S ƒvS „sZ^ „OMƒd ‹bLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"…f‚b ‚K‚J{ ‰HŠ_ ‰jƒOƒd Š]KLM.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"e‚e ˆ|hLY? e‚eƒb o‚e G‡k …I‚_‚h n…[…e ‚^‚j‚b GŠKƒm„S, g†g{ ƒa‚o …}D e‚ef …{WLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"‚K‚J, FaŠVKLY?") then
 RemindSave();
 DrawSMap();
 local menu={
 {"¡¡ ƒGK‚_‚h ƒsˆZM",nil,1},
 {"¡¡ƒGK‚_‚h ƒsƒ_‚C ‚k‚bM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
 if not GetFlag(38) then
talk(126,"ƒGK‚_ƒP ‚Kƒaƒm„S‚b „N„wG ƒLRhLM.",
 1,"‚M, ‚SƒW „N„wS …d…e[‚f.");
 AddPerson(133,37,23,2);
 MovePerson(133,3,2);
talk(133,"‚K‚J, I‡H …I„S ‚^‚jŠVKLY?");
 MovePerson(133,8,2);
talk(1,"„N„w, ƒ[‚_^ e‚e ƒGK‚_‚h ‚C‚ga‚V[.",
 133,"e‚eƒm„S …b‚~aƒG„S FaŠV‚TZ.",
 1,"ƒ[ŠQm. ƒ[‚_ƒP ‰cJG ŒRm.",
 133,"‚XS …HxLM. ‰bƒU„S †oƒweƒm„S ^†yKLM.",
 1,"‚M, v‡S …}S …huƒd ^‚V[.",
 133,"k, ‰q…f ^†yKLM.");
 MovePerson( 133,12,3);
 else
talk(126,"ƒGK‚_ƒP ‚Kƒaƒm„S‚b v‡SG ƒLRhLM.",
 1,"‚M, ‚SƒW v‡SS …d…e[‚f.");
 AddPerson(54,37,23,2);
 MovePerson(54,3,2);
talk(54,"‚K‚J, I‡H …I„S ‚^‚jŠVKLY?");
 MovePerson(54,8,2);
talk(1,"v‡S, ƒ[‚_^ e‚e ƒGK‚_‚h ‚C‚ga‚V[.",
 54,"e‚eƒm„S …b‚~aƒG„S FaŠV‚TZ.",
 1,"ƒ[ŠQm. ƒ[‚_ƒP ‰cJG ŒRm.",
 54,"‚XS …HxLM. ‰bƒU„S †oƒweƒm„S ^†yKLM.",
 1,"‚M, …Xƒ| …}S …huƒd ^‚V[.",
 54,"k, ‰q…f ^†yKLM.");
 MovePerson( 54,12,3);
 end
 SetFlag(89,1);
 ModifyForce(133,0);
 ModifyForce(54,0);
 ModifyForce(190,0);
 ModifyForce(127,0);
 ModifyForce(83,0);
 ModifyForce(65,0);
 ModifyForce(82,0);
 ModifyForce(114,0);
 ModifyForce(117,0);
 ModifyForce(188,0);
 elseif r==2 then
talk(126,"k, ‚B‚T ˆE‚K„S g_a‚V‚CZ.");
 end
talk(175,"ƒ[†{ ‚l[f ^ƒW ‰HŠ_ …b‚~a…xƒd ‰Ra‚V[.",
 1,"‚M, ƒ[‚_„V ˆ[†ym.",
 175,"k.");
 MovePerson(175,2,0);
 MovePerson(175,13,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [596]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†n";
 JY.Base["D‚wC"]=0;
 AddPerson(213,28,7,1);
 AddPerson(214,13,9,3);
 AddPerson(20,9,11,3);
 AddPerson(17,25,15,2);
 AddPerson(94,21,17,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("†nƒ{ †X‚B");
 DrawMulitStrBox("¡¡o„K ‚nƒP „v†E‚C †nƒ{fƒW‚b ‡{[ ‚l†_f ‚_o ‚_‚uS bƒPaƒd „O„kM.");
 MovePerson(214,2,3);
 MovePerson(214,1,0);
talk(214,"ŠDa, ‡{{ [^ ‚l†_S Šh„kƒmL ‰HŠ_ ƒOu‚h „Qƒ`‚b ƒuG ‡L‚XWLM. ‚SŠS ‚_„ia‚V†yKLY?",
 213,"‚M, †o†oƒm„S ƒQ‚TS ƒsˆZM. ƒ[†{ a…C‡].",
 17,"k!");
 MovePerson(17,2,2);
 MovePerson(17,0,0);
talk(213,"Œa‚V ‚TS Gˆnƒd †o†oS ‚CƒQB q‚P ƒaq vj{ „@S WŠP ‡{‚TS ‡fn‚f.",
 17,"‚XS …HƒR†yKLM. ‰bƒU„S ^†yKLM!");
 MovePerson(17,14,1);
talk(213,"ƒ[uƒd v‡_, ^…C.",
 20,"k.",
 94,"‡L‚^‚h ƒ_ƒ` ‚K‡I‚V[.");
 MovePerson( 20,2,3,
 94,2,2);
 MovePerson( 20,1,0,
 94,1,0);
talk(213,"v‡_, ƒ[‚_‚b e‚eƒm„S ^ vgfQ ‚Ba‚f. ƒLG ŠPƒR‚S[A ŠGn ‰jƒOƒd, ƒ[…e‚C ‚kƒmA †o†oS ‚CƒQa‚fƒd.",
 20,"k.",
 213,"^…C‚b W‚P„S ^ ƒaUfQD „Gƒb ‚XS ‚Ba‚f.",
 94,"‚XS …HƒR†yKLM.");
 MovePerson( 20,14,1,
 94,14,1);
 NextEvent();
 end,
 [597]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†o†o";
 JY.Base["D‚wC"]=13;
 AddPerson(19,25,9,1);
 AddPerson(79,25,15,2);
 AddPerson(63,14,9,3);
 AddPerson(17,5,19,0);
 SetSceneID(86,5);
 DrawStrBoxCenter("†o†o ƒP‚r‰R");
 DrawMulitStrBox("¡¡a…C‡]ƒb v‚PƒP ‚XS …HƒR‚S vjG ‚C‰J‚b †o†of G‚jŠjM.");
 MovePerson(17,6,0);
talk(17,"ƒ{CƒP ‚XS …HƒR‚S ‚CƒQa…e ŠXm.",
 19,"†~ƒm„S ŠU [ŠVm. ƒOu ‚~ƒ}„Vƒm„S‚b D…fŠW ‚C‡Q q ‚a„km.",
 79,"†wu ƒLS ‡fS …^‚P‚h W‚VM.",
 63,"ƒ[ŠQm. ƒLG ˆAd ŠPƒR‚Sƒi‚C ‚Z‚j[.",
 19,"ƒ[†{ Šom. a…C‡]ƒb †lƒ{S ‚C‰J‚V[.",
 17,"ƒ_^ …X‚C‡f e…ZS ‚C‰J‚d ˆ|G[? „a†ym.",
 19,"ƒW‚Uƒb …g‚TS, ƒOƒgƒb ƒN…E‚h ‚C‰J‚V[. ‚Z‚[ …X‚MS MB „N‚Pa‚V[.",
 79,"‚XS …HƒR†yKLM.",
 63,"k.");
 MovePerson( 17,12,1,
 79,12,1,
 63,12,1)
 NextEvent();
 end,
 [598]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒ{D";
 JY.Base["D‚wC"]=21;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 if GetFlag(135) then
 AddPerson(3,19,9,1);
 end
 AddPerson(170,23,11,1);
 AddPerson(203,13,16,0);
 SetSceneID(56,5);
 DrawStrBoxCenter("ƒ{D †X‚B");--³É¶¼ÒéÊÂÌü
 AddPerson(175,37,23,2);
 MovePerson(175,11,2);
talk(175,"‚K‚J, „Nƒg ‚l[fƒW ‰BnŠXKLM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÉÌÒé½ñºóĞĞ¶¯>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [599]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(1,"…X„X, …BW …b‚~ wƒb ‚SŠS „C„km?",
 175,"ƒ{‚r„C„kKLM. ‡Y‡bG …BW …b‚~f „iPKLM.",
 1,"[, †~ƒm„S Šoƒb m‚yG[.",
 175,"‡Y‡bG ‚ISƒm„S †[M WLM.",
 1,"Šom, ƒ[†{ ƒOuD ‚ISƒm„S †h‚VM.",
 126,"…b_a‚V‚CZ.");
 --MovePerson
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<È¥½­Áê£®>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ‚l[^ ŠYˆe ˆ|ˆe Ce‚aKLM. d^ „OƒmA ‡t‡LWLM.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"‚l[‡zƒP „W†bG „Av„SfŠB ‚Z†ohLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒO…m …X„XƒP ƒsƒd‚h ƒR‚S ƒs‚V‚CZ.");
 end
 end,
 [600]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‚IS";
 JY.Base["D‚wC"]=23;
 AddPerson(126,19,17,2);
 AddPerson(1,25,17,2);
 if GetFlag(135) then
 AddPerson(3,22,10,1);
 end
 AddPerson(170,20,9,1);
 AddPerson(203,9,15,0);
 SetSceneID(54);
 DrawStrBoxCenter("‚IS ƒP‚r‰R");
 AddPerson(175,-5,2,3);
 MovePerson(175,10,3);
talk(175,"‚K‚J, ‡Y‡bG ‚ISf D†WPKLM.",
 1,"ƒ[‹@^, Gu„S ‚Z‚V‚f.",
 175,"k.");
 MovePerson(175,12,2);
talk(1,"‚l[‚f¡­¡­ eƒO^ ‚l[ƒP ‡Yf B‚h h„kS „U, [ƒX ‡Y‡b{ ‡Y‹Qƒd v‚n‚h „Qu‚fƒd ‚SŠS `‚EP†y‚b^.",
 126,"‚K‚JƒP ~‚Xo †@†MG [ƒXƒP ‚Guo ˆEƒo‚h „VƒR„kKLM. ‚K‚J, ‡Y‡bG D†Wo ‡KWLM.");
 AddPerson(142,-5,2,3);
 MovePerson(142,10,3);
talk(142,"‚G‚P ‚J, …A†hmGM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÓëËïÈ¨µÈÈËÉÌÒé½ñºóµÄÊÂ£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [601]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‰q…f ‡YŠiS ŠGƒm‚V‚CZ.");
 end
 if JY.Tid==142 then--ËïÈ¨
talk(142,"ƒ_^ ‚TS Gˆnƒd †[ ƒuƒb [„L ‚n‚h „QƒG ‚n‰HG[. ‰q…f ƒOu ‚TƒP „wq †Q‡YS m†Ka†ym. †Q‡Y, ƒv[‚V[.");
 AddPerson(151,-5,1,3)
 MovePerson(151,9,3);
talk(151,"…f‚b †Q‡YhLM. ‹n‚Mƒb HE‚SD ‚[ ‚WGA …S†fB‚C‚b ˆFG‚CZ.",
 1,"‡Y‡b ‚J, †Q‡Y ‚J. ‰HŠ_ ‚n‚h „Qƒd }ƒLS ƒq‚S ‹b‚VM.",
 142,"Šom. v‚P‚h ‚aŒiA ‚saD ‚|ƒwB‹T ƒuG[.");
 NextEvent();
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ƒO…m ‡Y‡b ‚JƒP „T‚uS ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"‚K‚J, ƒO…m ‡Y‡b ‚JƒP „T‚uS ƒR‚S ƒs‚V‚CZ.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒO…m ‡Y‡b ‚JƒP „T‚uS ƒR‚S ƒs‚V‚CZ.");
 end
 end,
 [602]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚l[‡z ‰HŠ_ ‰j‡SML, ‚Bf‚b CCD ˆf X …IG„kKLM.");
 end
 if JY.Tid==142 then--ËïÈ¨
talk(142,"…fŠsD „@S MB ‚n‚h „Q†yKLM.");
 end
 if JY.Tid==151 then--Â½Ñ·
talk(151,"‰HŠ_ ‚n‚h Š~‚VM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‰HŠ_ ‚n‚h Š~‚VM.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"‰HŠ_ ‚n‚h Š~‚VM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"‡Y‡bŠ_ ƒGK‚_‚h ƒsƒ_ ˆG‚f ‰RB ƒLƒP ‚~ƒ}S ‡L„[‚V‰J‚b „KG Šo†yKLM.",
 1,"ƒGK‚_‚b ‚SƒZ‚h „QQ a†ym?",
 126,"‚l[ƒP ‡k‹Jƒb W‚PG†B ƒaU^ ‚CXLM. W‚P‚h „QA ƒaU‚b M‡M ‡ES ‚CƒQX „}‚hG ‚aKLM. ‚K‚JŠ_ƒW ‰KG ŠInƒ` Fa‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<¿¼ÂÇÊÇ·ñÇëËïÈ¨ÅÉÆæÏ®¶Ó£®>
 NextEvent();
 end
 end,
 [603]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚l[‡z ‰HŠ_ ‰j‡SML, ‚Bf‚b CCD ˆf X …IG„kKLM.");
 end
 if JY.Tid==142 then--ËïÈ¨
talk(142,"…fŠsD „@S MB ‚n‚h „Q†yKLM.");
 end
 if JY.Tid==151 then--Â½Ñ·
talk(151,"‰HŠ_ ‚n‚h Š~‚VM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‰HŠ_ ‚n‚h Š~‚VM.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"‰HŠ_ ‚n‚h Š~‚VM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"‚K‚J, ŠInƒ` ƒsŠVKLY?") then
 RemindSave();
 DrawSMap();
 local menu={
 {"¡¡‡Y‡bfQ W‚P ‚J‚pS ‰RoM",nil,1},
 {"¡¡¡¡ ‰Ra‚C ‚k‚bM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
talk(1,"‡Y‡b ‚J, ƒGK‚_‚h ƒsƒ_‚b ƒuG ‚S‹c†ym?",
 142,"ƒGK‚_‚f aŠVm?",
 1,"‚l[ ‡k‹JƒP W‚P‚h ŠP ‚K‚VƒG‚h ‰Ra[.",
 142,"ƒv„l…e ƒLS †Tda‚d ˆ|G‚wƒ`. Šom, W‚P„S ‚TS ƒ_†ym.");
 SetFlag(90,1);
talk(142,"Šom. ‰bƒU„S ‰Bn^ W‚P …b‚~S ƒe‚Pa†ym.");
 elseif r==2 then
talk(142,"ƒOu ‚TG ‚TqƒBS ‹D ƒs‚|ƒd…x a[. …Hn ‚K‚V[.");
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("‚l[fQƒW ‚Uƒg £²£°£°£°ƒP ƒQv‚h …HƒtM!");
talk(142,"‹Iƒm„S I‡H …IG „O†Eˆe †Q‡YfQ G‚j‚V[. ƒ[†{ ƒv‚b ‰q…f ƒA…e^†ym.");
 end
 MovePerson(142,12,2)
talk(126,"ƒ[†{ ƒOuD …bFS ƒe‚PW‚VM.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<½øĞĞ³öÕ÷×¼±¸£®>
 NextEvent();
 end
 end
 end,
 [604]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"‚l[‡z ‰HŠ_ ‰j‡SML, ‚Bf‚b CCD ˆf X …IG„kKLM.");
 end
 if JY.Tid==151 then--Â½Ñ·
talk(151,"‰HŠ_ ‚n‚h Š~‚VM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‰HŠ_ ‚n‚h Š~‚VM.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"‰HŠ_ ‚n‚h Š~‚VM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"…bFa‚V†yKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 if GetFlag(136) or GetFlag(132)then --Ô­±¾ÊÇÖ»ÓĞ´òÁËÎ÷Áê²ÅÉı¼¶£¬¸ÄÎª´ò»ò²»´ò¶¼Éı¼¶£¬´òÁËÒÄÁê¾Í²»Éı
 LvUp(151,6);
 LvUp(148,11);
 LvUp(167,11);
 LvUp(166,11);
 LvUp(165,11);
 end
--(Èç¹ûÃ»´òÎ÷ÁêÖ®Õ½)40¼¶½üÎÀ¶ÓÁèÍ³£¬40¼¶ÃÍÊŞ±øÍÅ¸ÊÄş£¬38¼¶Õ½³µ¶¡·î£¬39¼¶Õ½³µĞìÊ¢£¬47¼¶ÑıÊõÊ¦Â½Ñ·¡£
--(Èç¹ûÖ»´òÎ÷ÁêÖ®Õ½)51¼¶½üÎÀ¶ÓÁèÍ³£¬51¼¶ÃÍÊŞ±øÍÅ¸ÊÄş£¬49¼¶Õ½³µ¶¡·î£¬50¼¶Õ½³µĞìÊ¢£¬53¼¶ÑıÊõÊ¦Â½Ñ·¡£
--(Èç¹û´òÁËÒÍÁêÖ®Õ½)53¼¶½üÎÀ¶ÓÁèÍ³£¬53¼¶ÃÍÊŞ±øÍÅ¸ÊÄş£¬52¼¶Õ½³µ¶¡·î£¬53¼¶Õ½³µĞìÊ¢£¬56¼¶ÑıÊõÊ¦Â½Ñ·¡£
 WarIni();
 DefineWarMap(24,"d4ƒa †o†oII ‚B„e","1. vj ‚p†U",40,0,18);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,8,20,2,0,-1,0,
 125,8,21,2,0,-1,0,
 -1,7,19,2,0,-1,0,
 -1,9,19,2,0,-1,0,
 -1,8,18,2,0,-1,0,
 -1,10,20,2,0,-1,0,
 -1,9,21,2,0,-1,0,
 -1,7,22,2,0,-1,0,
 150,12,22,2,0,-1,0,
 147,11,21,2,0,-1,0,
 166,11,19,2,0,-1,0,
 165,12,20,2,0,-1,0,
 164,13,21,2,0,-1,0,
 372,1,16,4,0,-1,1,
 });
 DrawSMap();
talk(126,"ƒO…m bƒGƒW ^ƒa ^Y‡S †o†oS „Q‚V‚CZ.");
 JY.Smap={};
 SetSceneID(0,3);
 ModifyForce(121+1,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 18,18,4,1,2,55,3,0,0,-1,0,
 168,14,9,1,2,52,3,0,0,-1,0,
 121,16,6,1,0,52,9,0,0,-1,0,--ÎÄÆ¸
 256,17,5,1,2,48,3,0,0,-1,0,
 257,17,6,1,2,48,3,0,0,-1,0,
 258,11,15,1,2,47,3,0,0,-1,0,
 259,10,15,1,2,47,3,0,0,-1,0,
 260,9,8,1,2,48,3,0,0,-1,0,
 261,11,9,1,1,47,3,0,0,-1,0,
 292,8,11,1,1,51,9,0,0,-1,0,
 293,13,11,1,1,51,9,0,0,-1,0,
 274,18,5,1,1,48,6,0,0,-1,0,
 275,7,8,1,0,48,6,0,0,-1,0,
 276,11,14,1,2,48,6,0,0,-1,0,
 277,10,14,1,2,48,6,0,0,-1,0,
 
 83,21,18,3,3,51,21,0,0,-1,1,
 170,18,18,3,3,50,9,0,0,-1,1,
 294,17,18,3,3,45,9,0,0,-1,1,
 295,19,17,3,3,45,9,0,0,-1,1,
 296,22,17,3,3,44,9,0,0,-1,1,
 297,23,18,3,3,44,9,0,0,-1,1,
 298,22,19,3,3,45,9,0,0,-1,1,
 262,14,3,3,0,47,3,0,0,-1,0,
 263,14,4,3,0,48,3,0,0,-1,0,
 264,4,8,1,2,48,3,0,0,-1,0,
 278,9,10,1,2,46,6,0,0,-1,0,
 279,10,10,1,2,46,6,0,0,-1,0,
 280,15,8,1,2,47,6,0,0,-1,0,
 281,15,11,1,2,47,6,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end
 end
 end,
 [605]=function()
 PlayBGM(11);
talk(19,"‡{‚TG ‰b ŠPƒR‚S†[M! …A…w‚V ‡fn‚f!",
 126,"ƒLƒaƒb vjG‚f WLM. †o†oS ‰Hˆyaƒd ˆE‚K‚h „C‹qƒm‚V‚CZ.",
 151,"‚Z‚[ ‡{‚Tf ‡D‹n‚C‚C …X‚f! ‚saf [‚TƒP Nƒ}S ƒsb‚f!");
 WarShowTarget(true);
 SetFlag(903,1); --²ÜÈÊ´æ»î£¬Ä¬ÈÏ
 PlayBGM(9);
 NextEvent();
 end,
 [606]=function()
 WarLocationItem(3,10,172,98); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º²è ¸ÄÎª ¹­ÆïÖ¸ÄÏÊé
 WarLocationItem(8,5,18,99); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÂíÊõÖ¸ÄÏÊé
 WarLocationItem(3,16,2,100); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÇàÄÒÊé
 if (not GetFlag(1065)) and WarCheckArea(-1,7,4,12,14) then
 PlayBGM(11);
 WarShowArmy(83);
 WarShowArmy(170);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(297);
 WarShowArmy(298);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG D†WPM!");
talk(19,"[, ƒQ‚TG ŠX†sŠm? ‚Z‚[ „@S ƒ_‚f! ƒQ‚TG ‹fƒtƒmL †M…~f Œ{nŠP‚f!",
 1,"ƒ]‹wG„SM¡­¡­ ƒLƒP ƒQ‚TG D†WPM.");
 if GetFlag(58) then
 PlayBGM(12);

JY.Person[372+1]["±øÖÖ"]=JY.Person[2]["±øÖÖ"]
local bzid=JY.Person[2]["±øÖÖ"]
for id=1,War.PersonNum do
if War.Person[id].id==372+1 then
 War.Person[id].bz=bzid;
 War.Person[id].movewav=JY.Bingzhong[bzid]["ÒôĞ§"]; --ÒÆ¶¯ÒôĞ§
 War.Person[id].atkwav=JY.Bingzhong[bzid]["¹¥»÷ÒôĞ§"]; --¹¥»÷ÒôĞ§
 War.Person[id].movestep=JY.Bingzhong[bzid]["ÒÆ¶¯"]; --ÒÆ¶¯·¶Î§
 War.Person[id].movespeed=JY.Bingzhong[bzid]["ÒÆ¶¯ËÙ¶È"]; --ÒÆ¶¯ËÙ¶È
 War.Person[id].atkfw=JY.Bingzhong[bzid]["¹¥»÷·¶Î§"]; --¹¥»÷·¶Î§
 War.Person[id].pic=WarGetPic(id);
end
end
JY.Person[372+1]["±øÁ¦"]=JY.Person[2]["×î´ó±øÁ¦"]
JY.Person[372+1]["²ßÂÔ"]=JY.Person[2]["×î´ó²ßÂÔ"]
for i=1,8 do
JY.Person[372+1]["µÀ¾ß"..i]=JY.Person[2]["µÀ¾ß"..i]
end

 WarShowArmy(372);
 WarModifyAI(372,5,18);
talk(372+1,"‚n^ ˆE‚K‚h [†G „y‚CaD…l Še q ‚aM.");
 end
 PlayBGM(9);
 SetFlag(1065,1);
 end
 if WarMeet(373,19) then
 WarAction(1,373,19);
talk(373,"vj, [ˆs„VG[.",
 19,"[, †u‚wŠm? H¡­¡­ HŠb‚wƒv! n„L †jn „O„k†sŠm!?",
 373,"ƒ_^ ƒ[u ‹]G …GS ƒ{Š]ƒmŠm. Gd ˆE‚KƒP oS ‰s†yM!",
 19,"…M! [H‚f!");
 WarAction(6,373,19);
 if fight(373,19)==1 then
talk(19,"…yM!",
 373,"G ˆQ„Z! „p^ ‚SŠS ƒ_ C‚_^ „C†y†sŠm!");
 WarAction(5,19,373);
talk(373,"„l‚b „Dn ‚K‚C ‚k†yM! ‰q…f ƒqƒd ƒs†yM!!");
 WarAction(8,373,19);
talk(19,"ƒm…v!");
 WarAction(18,19);
 DrawStrBoxCenter("qqŠ_ŠYƒP IƒaG vjS ƒq„kM!");
 SetFlag(903,0); --²ÜÈÊËÀÍö
talk(1,"Gw ŒyŠm? I‡H …IG ‰r‚Sg ƒuGŠm?",
 126,"ƒLG ƒ_‡LS …Iƒm…s‚b^? G ƒG‚}‚h …A…w‚V ‹Qn…E oM!",
 1,"ŠoM, ƒo„yQ Œ{nŠP‚f!");
 NextEvent();
 else
 WarAction(4,19,373);
talk(373,"¡­¡­¡­¡­¡­¡­");
 WarAction(17,373);
 WarLvUp(GetWarID(19));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(19,"‹U, ‹U‹VaM¡­¡­ ‚G‚P G Œi‡pG! ƒm…v!!",
 --1,"ºÃ£¬É±ÁË²ÜÈÊ£¡",
 1,"ŠoM, vjS „_„kM!");
 NextEvent();
 end
 end,
 [607]=function()
 PlayBGM(7);
 if GetFlag(903) then
 DrawMulitStrBox("¡¡vjS „_ƒd ‚G‚P‚TG †o†oS ‡F‚YPM.");
 else
 DrawMulitStrBox("¡¡vjS ƒqƒd ‚G‚P‚TG †o†oS ‡F‚YPM.");
 end
 if GetFlag(58) then
 PlayBGM(2);
talk(373,"¡­¡­I‡H Hƒm„S ˆEŠiS Œr[uY¡­¡­");
 WarAction(16,373);
 DrawStrBoxCenter("qqŠ_ŠYƒP IƒaG ‹XŠgM.");
talk(1,"‚M! …fw¡­¡­? E…X¡­¡­",
 3,"ƒnˆEŠi, I‡H …IG‡ILY?",
 1,"GCa‚wƒv¡­¡­ nIƒuD nLM¡­¡­",
 3,"ƒnˆEŠi, „KƒKƒm‡ILY? ƒG‡SS ƒ_‡I‚V[.",
 1,"ƒ[†G. (‡L‚X ŠUˆf „v ƒuG†y‚C. E…X¡­¡­) ŠoM, †o†oƒm„S ƒR‚S^…x!");
 PlayBGM(7);
 end
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£µ£°£°S …V„kM!");
bonus_moneyexp_4()
 if not GetFlag(903) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [608]=function()
 SetSceneID(0,3);
talk(126,"ƒ[†{ †o†oƒ{ƒm„S ƒR‚S^‚V‚CZ.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<ÔÚÏåÑôÉÌÒéÏÂÒ»²½ĞĞ¶¯>
 NextEvent();
 end,
 [609]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†o†o";
 JY.Base["D‚wC"]=24;
 AddPerson(1,25,9,1);
 AddPerson(126,20,9,1);
 if GetFlag(135) then
 AddPerson(3,25,15,2);
 end
 AddPerson(170,23,16,2);
 AddPerson(151,14,9,3);
 AddPerson(148,12,10,3);
 SetSceneID(86,5);
 DrawStrBoxCenter("†o†o ƒP‚r‰R");
talk(126,"‚K‚J, …Xƒlƒ_ †o†oS „C‹qƒmŠVƒmL ƒ@a…w„tLM.");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [610]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, Še[ ˆEŠiƒb ^ŠV‚C„V ‚Sj‚C n„L †jn „TƒN ƒu„V „GKLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"†o†oS „C‹qƒmŠVƒmL ƒ@a…w„tLM.");
 end
 if JY.Tid==151 then--Â½Ñ·
talk(151,"vjƒb „_„kƒmƒv „Y†oY‚C ^ƒ`A ‰q…f †lƒ{S ‰HˆyB…E a†B, †rƒc…XM ƒLG gS „Qƒd ƒGM„u ƒuhLM.");
 end
 if JY.Tid==148 then--¸ÊÄş
talk(148,"‹n‚M ‹pKLM. …f‚b ‚l[ƒP ƒNa ‡N‡}hLM. ‹Iƒm„S ŠU ‚Cƒ_ ‹b‚VM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"„Y†oƒm„S ^ƒ`A ‰q…f ƒN…Eƒv …g‚TS ‚Cƒvƒd ƒ[M‚M †lƒ{S ‚Cƒv…E WLM.",
 1,"‚M, ƒN…E‡z …g‚TS ‰Hˆya‚C ‚kƒmA †lƒ{fƒW ‰G‚J‡iX ‚n…UG „Om.",
 126,"ƒ[ŠQKLM. †Q‡YfQ ‚CƒQS ‰RB ƒN…E‡z …g‚TS ‚l‚Vf ŠP…E WLM.");
 NextEvent();
 end
 end,
 [611]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, Še[ ˆEŠiƒb ^ŠV‚C„V ‚Sj‚C n„L †jn „TƒN ƒu„V „GKLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"†o†oS „C‹qƒmŠVƒmL ƒ@a…w„tLM.");
 end
 if JY.Tid==151 then--Â½Ñ·
talk(151,"ƒ[‚_ƒRƒP ˆ|ƒb M ƒR„km. ƒ_^ ƒN…E‚h †R‚C …g‚TS †R‚C FBƒW „aƒ` ‚K‚V[.");
 NextEvent();
 end
 if JY.Tid==148 then--¸ÊÄş
talk(148,"ƒOu ‚l[ƒP ƒNaƒRD ‡{‚T{ „@S WŠP ‚n‚h C‚_a†ym.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒ[ŠQKLM. †Q‡YfQ ‚CƒQS ‰RB ƒN…E‡z …g‚TS ‚l‚Vf ŠP…E WLM.");
 end
 end,
 [612]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, Še[ ˆEŠiƒb ^ŠV‚C„V ‚Sj‚C n„L †jn „TƒN ƒu„V „GKLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"†o†oS „C‹qƒmŠVƒmL ƒ@a…w„tLM.");
 end
 if JY.Tid==151 then--Â½Ñ·
 if talkYesNo( 151,"ŠInƒ` ƒsŠVKLY?") then
 RemindSave();
 DrawSMap();
 local menu={
 {"†Q‡YfQ …g‚T ‚J‚pS ‰RoM",nil,1},
 {"†Q‡YfQ ƒN…E ‚J‚pS ‰RoM",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
 SetFlag(92,1);
talk(151,"Šom, ƒ[†{ ƒv‚b …g‚TS „Q†ym.");
 elseif r==2 then
talk(151,"Šom, ƒ[†{ ƒv‚b ƒN…E‚h „Q†ym.");
 end
 MovePerson( 151,12,1,
 148,12,1);
 DecPerson(151);
 DecPerson(148);
talk(126,"ƒOuD …b_W‚VM. ƒe‚P„C‚VA …I…e ‚K‡I‚V[.",
 170,"ƒ[†{ …fŠs‚b ‰q…f ƒe‚Pa…e ^†yKLM.");
 if GetFlag(135) then
 MovePerson( 3,12,1,
 170,12,1);
 DecPerson(3);
 DecPerson(170);
 else
 MovePerson( 170,12,1);
 DecPerson(170);
 end
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<½øĞĞ³öÕ÷×¼±¸£®>
 NextEvent();
 end
 end
 if JY.Tid==148 then--¸ÊÄş
talk(148,"ƒN…E‡z …g‚TS laA …g‚b ƒuƒb †lƒ{ŠFhLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒN…E‚b ƒOƒgG, …g‚Tƒb ƒW‚UG ‚C‰mM WLM.");
 end
 end,
 [613]=function()
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 if GetFlag(92) then
 DefineWarMap(47,"d4ƒa ƒN…EII ‚B„e","1. ƒOƒg ‚p…D*2. n‚T ‚^‚_^ ‚T„Xƒd Šxl",40,0,62);
 SelectTerm(1,{
 0,3,6,4,0,-1,0,
 125,4,7,4,0,-1,0,
 -1,2,6,4,0,-1,0,
 -1,2,7,4,0,-1,0,
 -1,5,8,4,0,-1,0,
 -1,7,4,4,0,-1,0,
 -1,7,5,4,0,-1,0,
 -1,8,3,4,0,-1,0,
 -1,9,5,4,0,-1,0,
 -1,3,9,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 62,22,12,3,2,55,25,0,0,-1,0,
 256,24,14,3,2,45,3,0,0,-1,0,
 101,20,13,3,0,52,9,0,0,-1,0,--ÕÅĞå
 115,21,15,3,0,52,3,0,0,-1,0,--Àîµä
 299,13,13,3,0,52,9,0,0,-1,0,
 300,13,15,3,0,49,9,0,0,-1,0,
 301,15,11,3,0,50,9,0,0,-1,0,
 260,17,13,3,2,51,3,0,0,-1,0,
 261,21,17,3,2,51,3,0,0,-1,0,
 274,14,7,3,2,48,6,0,0,-1,0,
 275,16,7,3,2,48,6,0,0,-1,0,
 276,18,13,3,2,46,6,0,0,-1,0,
 277,21,16,3,2,46,6,0,0,-1,0,
 292,8,14,3,0,49,9,0,0,-1,0,
 293,19,13,3,0,52,9,0,0,-1,0,
 294,22,13,3,0,51,9,0,0,-1,0,
 
 332,15,13,3,0,45,14,0,0,-1,0,
 278,21,11,3,2,44,6,0,0,-1,0,
 257,15,6,3,2,43,3,0,0,-1,0,
 67,0,18,4,1,55,9,0,0,-1,1,
 295,1,19,4,1,52,9,0,0,-1,1,
 296,17,0,3,1,49,9,0,0,-1,1,
 297,18,0,3,1,49,9,0,0,-1,1,
 298,19,1,3,1,50,9,0,0,-1,1,
 });
 else
 DefineWarMap(46,"d4ƒa …g‚T ‚B„e","1. ƒW‚U ‚p…D*2. ƒ{…^ ‚[ ‡E ‡F‚Y",40,0,78);
 SelectTerm(1,{
 0,3,18,4,0,-1,0,
 125,2,18,4,0,-1,0,
 -1,1,15,4,0,-1,0,
 -1,1,17,4,0,-1,0,
 -1,1,19,4,0,-1,0,
 -1,2,16,4,0,-1,0,
 -1,3,17,4,0,-1,0,
 -1,4,16,4,0,-1,0,
 -1,5,18,4,0,-1,0,
 -1,6,17,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 78,22,6,3,2,56,9,0,0,-1,0,
 209,16,14,3,2,53,21,0,0,-1,0,
 101,22,7,3,0,52,9,0,0,-1,0,--ÕÅĞå
 115,22,8,3,0,52,3,0,0,-1,0,--Àîµä
 274,17,17,3,2,49,6,0,0,-1,0,
 256,10,3,3,4,47,3,3,11,-1,0,
 257,13,5,3,4,47,3,3,11,-1,0,
 258,16,18,3,2,47,3,0,0,-1,0,
 292,5,5,3,0,48,9,0,0,-1,0,
 293,3,5,3,0,48,9,0,0,-1,0,
 294,4,5,3,0,52,9,0,0,-1,0,
 295,13,6,3,0,48,9,0,0,-1,0,
 296,19,6,3,0,52,9,0,0,-1,0,
 275,4,4,3,0,49,6,0,0,-1,0,
 276,14,8,3,0,46,6,0,0,-1,0,
 277,21,7,3,0,46,6,0,0,-1,0,
 
 310,12,10,3,0,48,12,0,0,-1,0,
 311,12,12,3,0,47,12,0,0,-1,0,
 297,8,0,3,1,52,9,0,0,-1,1,
 298,9,1,3,1,52,9,0,0,-1,1,
 299,11,1,3,1,48,9,0,0,-1,1,
 300,7,1,3,1,48,9,0,0,-1,1,
 });
 end
 JY.Smap={};
 SetSceneID(0,3);
 if GetFlag(92) then
	talk(151,"Šom ‚G‚P ‚J, ƒOu‚b …g‚TS „Q†ym.",
 	1,"‚M, ‚^…aa[.",
 	126,"ƒOuD ƒN…E„S …b_a‚V‚CZ.");
 	NextEvent(614); --goto 614
 else
	talk(151,"Šom ‚G‚P ‚J, ƒOu‚b ƒN…E‚h „Q†ym.",
 	1,"‚M, ‚^…aa[.",
 	126,"ƒOuD …g‚Tƒm„S …b_a‚V‚CZ.");
	 NextEvent(617); --goto 617
 end
 JY.Status=GAME_WMAP;
WarSave(6)
 end
 end
 end,
 [614]=function()
 PlayBGM(11);
talk(63,"‚G‚P‚TS ‚Cƒv^Q ‚[‚C …X‚f. ‚~‚r aƒvD ‚o ˆYM.",
 126,"ƒN…EƒP ƒLƒaƒb ƒOƒghLM. G‡ES ‰HˆyaA G‚h †Z†E„S †lƒ{S †R q „OKLM.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [615]=function()
 WarLocationItem(19,3,52,101); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÓÂÆøÊé
 if (not GetFlag(1066)) and War.Turn==8 then
 PlayBGM(11);
 WarShowArmy(67);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(297);
 WarShowArmy(298);
 DrawStrBoxCenter("ƒLƒP ƒQ‚TG D†WPM!");
talk(68,"‚G‚P‚TS ‚Cƒv^Q ‚[‚C ˆ|ƒd ‚ISƒm„S Œ{nƒ_‚f!",
 63,"n, ƒQ‚TGM! ˆEdƒRn, ƒQ‚TG ŠXM! ‚Z‚[ IQ „qŒw‚f!");
 PlayBGM(9);
 SetFlag(1066,1);
 end
 if (not GetFlag(1067)) and WarCheckLocation(-1,14,24) then
talk(63,"I‡JG? ‚T„Xƒd‚h Šf„h‹HMƒd! G†GƒW…E ‚SŠS ƒ{S ‚C‰J]! ‹U‹Va‚wƒv, †lƒ{ƒm„S ƒA…e‚qM!");
 WarAction(16,63);
 SetFlag(1067,1);
 NextEvent();
 end
 if WarMeet(3,63) then
 WarAction(1,3,63);
talk(3,"ŠGƒb„Kƒb ƒOƒgGŠ@M! G ƒa‚P‡z o‚F ŒE‚S ƒs†y†sŠm!",
 63,"ƒn…IGM! ƒa‚PM!! ƒm…v!",
 3,"ƒ_ Še[ ˆEŠi eƒOƒP ƒQq‚h ‹y†yM! …GS ‚E[ƒv B‚f! …yM!");
 WarAction(6,3,63);
 if fight(3,63)==1 then
 WarAction(8,3,63);
talk(3,"‚S‹XŠm! H‚b ƒ_ C‚_^ ˆf ˆYM!",
 63,"‹U‹Va‚wƒv! ƒc…~G ‰q…fM! ƒa‚P, ‹`ƒS M‚V ƒs…x!!",
 3,"ŒL! ˆGnƒv‚C …X‚f! ƒ[ƒuG ‚_ƒaG X ŒQGŠm!");
talk(63,"…C…Da‚f! ‚SƒW †lƒ{ƒm„S!");
 WarAction(16,63);
 WarLvUp(GetWarID(3));
 NextEvent();
 else
 WarAction(4,63,3);
talk(3,"‹U‹Va‚wƒv!");
 WarAction(17,3);
 WarLvUp(GetWarID(63));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(63,"‹U, ‹U‹VaM! …C…Da‚f! †lƒ{ƒm„S!");
 NextEvent();
 end
 end,
 [616]=function()
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒOƒgG ƒA…eƒvƒd ‚G‚P‚TG ƒN…E‚h ‡F‚YPM.");
talk(1,"ŠUPM! Gd †lƒ{„V ‰HˆyaA „Y†oG ŠH‹IGM!");
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£µ£°£°S …V„kM!");
bonus_moneyexp_4()
 if GetFlag(1067) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(620); --goto 620
 end,
 [617]=function()
 PlayBGM(11);
talk(79,"‚G‚P^ ŠX‚wƒv! ‡mƒv †@ŠH ‚Cƒv^Q ‚[‚C ‚k†yM. q‚JS MM.",
 126,"G¡­¡­ ‚K‚J! G‡Eƒb ‚n…UWLM!",
 1,"‚SŠSab ƒ[…e[?",
 126,"G‡Eƒb „s‚V Œ^ ‚IƒUˆvhLM! ƒLG C]f FS Cn ƒAS ‡fn ‚[„kS ƒuhLM! ƒAS ƒh„]uA ƒOu ‚Tƒb †P]f „w[„S |‰a†LLM!",
 1,"‡mƒv †Q‡YG ƒN…EfƒW ‰jƒO‚b ‚eG[. ƒOu^ ƒA…eƒvA †Q‡YG ƒd„t„C[.",
 126,"ƒ[ŠQMA ƒLƒP ƒ{…^‚h Šf„h‚b q‹wf ˆGu „ND^ ‚aKLM.",
 1,"ŠoM, ‚B‚T ƒN…{ŠW ƒLƒP ƒ{…^‚h Šf„hn‚f!");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [618]=function()
 if WarMeet(44,210) then
 WarAction(1,44,210);
talk(44,"ƒv‚b ƒa‚PƒP nƒR ƒa†aM! [‚b ƒaq‚b ƒv‡z …I‚_…I„S „}‹a †cŒDG „O†sŠm!",
 210,"ƒa‚PƒP nƒRG„k‚wƒv. G a…CCƒb ‡wGX ƒu ‚aM. ŠU ŠXM, ƒO…m ŒE‚S ƒs…x!");
 WarAction(6,44,210);
 if fight(44,210)==1 then
talk(210,"‰jƒO…xA ‰jƒO‚C¡­¡­",
 44,"…M! nY‚b ‡Lq‚h ‚Z‚j„lL Gd …C‚}„C†sŠm!");
 WarAction(8,44,210);
talk(210,"…v! {, {…B ƒa‚PƒP¡­¡­ nƒRG„SM¡­¡­");
 WarAction(17,210);
talk(44,"a…CC, G ƒa†a^ H‚h …`‚ffQ ƒsƒ_ ‚K…X!");
 WarLvUp(GetWarID(44));
 else
 WarAction(4,210,44);
talk(44,"…v! n¡­¡­ nL¡­¡­");
 WarAction(17,44);
 WarLvUp(GetWarID(210));
 end
 end
 WarLocationItem(3,3,40,102); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºº£Ğ¥Êé
 WarLocationItem(0,10,47,103); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¶ÓÊé
 if (not GetFlag(104)) and WarCheckLocation(-1,7,19) then
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £²£°£°£°S …V„kM!");
 SetFlag(104,1);
 end
 if (not GetFlag(105)) and WarCheckLocation(-1,14,16) then
 DrawStrBoxCenter("‡k‹J ƒ{…^‚h ‡F‚YPM!");
 SetFlag(105,1);
 if (not GetFlag(110)) and GetFlag(105) and GetFlag(106) then
 PlayBGM(7);
talk(1,"†|†}WLM! ƒ{…^‚h ‡F‚YPƒmL ƒLƒP q‚Jƒb OFX ƒu ‚aKLM. †M…~f ƒW‚US IH„]u‚V‚CZ!",
 79,"I‡JG! ƒ{…^‚h Šf„h‹HMƒd! …M, ƒ_ „T‚uG ‚Sƒ[…eƒF‚wƒv. a‚b q ‚aM, †lƒ{ƒm„S ‚}‚ToM!");
 WarAction(16,79);
 NextEvent();
 end
 end
 if (not GetFlag(106)) and WarCheckLocation(-1,17,17) then
 DrawStrBoxCenter("…g‹J ƒ{…^‚h ‡F‚YPM!");
 SetFlag(106,1);
 if (not GetFlag(110)) and GetFlag(105) and GetFlag(106) then
 PlayBGM(7);
talk(1,"†|†}WLM! ƒ{…^‚h ‡F‚YPƒmL ƒLƒP q‚Jƒb OFX ƒu ‚aKLM. †M…~f ƒW‚US IH„]u‚V‚CZ!",
 79,"I‡JG! ƒ{…^‚h Šf„h‹HMƒd! …M, ƒ_ „T‚uG ‚Sƒ[…eƒF‚wƒv. a‚b q ‚aM, †lƒ{ƒm„S ‚}‚ToM!");
 WarAction(16,79);
 NextEvent();
 end
 end
 if (not GetFlag(1068)) and War.Turn==10 then
talk(79,"‹kM, ‚Cƒg ‰b FS ƒh„]ƒ` ‚G‚P‚TS ƒAf ‡dƒGQ a‚f.");
 PlayWavE(53);
 WarFireWater(14,15,2);
 WarFireWater(13,14,2);
 WarFireWater(12,14,2);
 WarFireWater(11,14,2);
 WarFireWater(6,13,2);
 WarFireWater(5,12,2);
 WarFireWater(4,12,2);
 WarFireWater(3,12,2);
 WarFireWater(2,11,2);
 WarFireWater(1,11,2);
 WarFireWater(0,11,2);
 WarFireWater(12,12,2);
 WarFireWater(5,10,2);
 WarFireWater(4,10,2);
 WarFireWater(3,9,2);
 WarFireWater(2,9,2);
 WarFireWater(1,9,2);
 WarFireWater(0,8,2);
 WarFireWater(6,7,2);
 WarFireWater(5,7,2);
 WarFireWater(4,6,2);
 WarFireWater(3,6,2);
 WarFireWater(12,11,2);
 WarFireWater(17,13,2);
 WarFireWater(17,12,2);
 WarFireWater(15,10,2);
 WarFireWater(14,9,2);
 WarFireWater(14,8,2);
 WarFireWater(14,6,2);
 WarFireWater(13,5,2);
 WarFireWater(10,8,2);
 WarFireWater(10,7,2);
 WarFireWater(12,3,2);
 WarFireWater(11,5,2);
 WarFireWater(11,4,2);
 WarFireWater(10,4,2);
 WarFireWater(9,3,2);
 WarFireWater(7,4,2);
 WarFireWater(6,4,2);
 WarEnemyWeak(1,1);
 WarEnemyWeak(1,2);
talk(126,"‹z„k‚wƒv¡­¡­",
 79,"aaa! ‚G‚P G Œi‡pG, ŒBŠo‚wƒv! ‚B‚T ‚G‚P‚TS ŠP‚f.");
 WarShowArmy(297);
 WarShowArmy(298);
 WarShowArmy(299);
 WarShowArmy(300);
 WarModifyAI(101,1); --ÕÅĞå
 WarModifyAI(115,1); --Àîµä
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(258,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(295,1);
 WarModifyAI(296,1);
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 War.WarTarget="1. ƒW‚U ‚p…D";
 WarShowTarget(false);
 SetFlag(1068,1);
 SetFlag(105,1);
 SetFlag(106,1);
 SetFlag(110,1);
 PlayBGM(9);
 end
 if (not GetFlag(1069)) and War.Turn==11 then
 WarFireWater(3,6,3);
 WarFireWater(5,7,3);
 WarFireWater(6,7,3);
 WarFireWater(1,9,3);
 WarFireWater(4,10,3);
 WarFireWater(5,10,3);
 WarFireWater(12,12,3);
 WarFireWater(3,12,3);
 WarFireWater(0,11,3);
 WarFireWater(12,11,3);
 WarFireWater(14,8,3);
 WarFireWater(10,8,3);
 WarFireWater(10,7,3);
 WarFireWater(9,3,3);
 WarFireWater(6,4,3);
 SetFlag(1069,1);
 end
 if (not GetFlag(1070)) and War.Turn==12 then
 WarFireWater(4,6,3);
 WarFireWater(0,8,3);
 WarFireWater(3,9,3);
 WarFireWater(11,14,3);
 WarFireWater(13,14,3);
 WarFireWater(1,11,3);
 WarFireWater(4,12,3);
 WarFireWater(17,13,3);
 WarFireWater(13,5,3);
 WarFireWater(11,5,3);
 WarFireWater(10,4,3);
 WarFireWater(7,4,3);
 SetFlag(1070,1);
 end
 if (not GetFlag(1071)) and War.Turn==13 then
 WarFireWater(2,9,3);
 WarFireWater(2,11,3);
 WarFireWater(5,12,3);
 WarFireWater(6,13,3);
 WarFireWater(12,14,3);
 WarFireWater(14,15,3);
 WarFireWater(17,12,3);
 WarFireWater(15,10,3);
 WarFireWater(14,9,3);
 WarFireWater(14,6,3);
 WarFireWater(12,3,3);
 WarFireWater(11,4,3);
 SetFlag(1071,1);
 end
 if JY.Status==GAME_WARWIN then
talk(79,"‹U‹Va‚wƒv! ƒO…m ƒA…e‚qM! †lƒ{ƒm„S!");
 PlayBGM(7);
 NextEvent();
 end
 end,
 [619]=function()
 DrawMulitStrBox("¡¡ƒW‚UG ƒA…eƒvƒd ‚G‚P‚TG …g‚TS ‡F‚YPM.");
talk(1,"†|†}aM! G‚_„S †lƒ{S ‰HˆyaA „Y†oG „I‹IGM!");
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£µ£°£°S …V„kM!");
 if (not GetFlag(110)) and (GetFlag(105) or GetFlag(106)) then
 WarGetExp();
 end
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [620]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="ƒN…E";
 JY.Base["D‚wC"]=0;
 AddPerson(1,25,9,1);
 AddPerson(126,20,9,1);
 if GetFlag(135) then
 AddPerson(3,26,12,1);
 end
 AddPerson(170,11,10,3);
 AddPerson(203,7,12,3);
 AddPerson(175,24,17,2);
 AddPerson(151,15,14,0);
 SetSceneID(95,5);
 DrawStrBoxCenter("ƒN…E g~");
 DrawMulitStrBox("¡¡G‡Eƒb ‚G‚P‚TƒP g~. ‚G‚P‚Tƒb †lƒ{S „Qƒd…x ƒN…Ef ‚TS ‚[ƒd ‹Iƒm„SƒP ‚_‚uS QPM.");
 --AddPerson(369,4,21,0);
 --MovePerson( 369,8,0);
 --MovePerson( 369,10,1);
 --DecPerson(369);
talk(1,"†Q‡Y ‚_j, qƒdaŠVm.",
 151,"G„Vo …IG…E ‚_q„B‚C ‚km. ‡{‚TG G‰S…l ‚IaML „D‚f…[ ‚iŠKG[. ‚G‚P ‚J, ƒOu ‚K‚JŠ_ƒW ‰Bn[‚f ‚Xa‚VL †~ƒm„S ‡p‚wa[¡­¡­",
 1,"„a†ym. ƒ[†{ ‡Y‡b ‚JŠ_ ƒ_ j‚r‚h ‚BB ‚K‚V[.",
 151,"ƒdŠOm. ƒ[†{ GƒRS …g„} ‰IQ a†ym.");
 if GetFlag(132) then
 AddPerson(148,5,22,0);
 MovePerson( 148,6,0);
talk(148,"†Q‡Y D„`ƒP ‚XS …HƒR‚S …f‡z ƒM„w, ƒWƒ{, F‡WG G‡Ef …gn ‚G‚P ‚J{ ‚SZ‚h ƒv‚dŠW aƒd ‰jƒO†yKLM. ‡L‚^‚h ‚i‚j†yKLM.");
 ModifyForce(148,1);
 ModifyForce(167,1);
 ModifyForce(166,1);
 ModifyForce(165,1);
 JY.Person[148]["µÀ¾ß1"]=0;
 JY.Person[148]["µÀ¾ß2"]=0;
 JY.Person[167]["µÀ¾ß1"]=0;
 JY.Person[167]["µÀ¾ß2"]=0;
 JY.Person[166]["µÀ¾ß1"]=0;
 JY.Person[166]["µÀ¾ß2"]=0;
 JY.Person[165]["µÀ¾ß1"]=0;
 JY.Person[165]["µÀ¾ß2"]=0;
 PlayWavE(11);
 DrawStrBoxCenter("‡N‡}, ƒM„w, ƒWƒ{, F‡WG ^†iPM!");
 elseif GetFlag(136) then
 AddPerson(167,5,22,0);
 MovePerson( 167,6,0);
talk(167,"†Q‡Y D„`ƒP ‚XS …HƒR‚S …f‡z ƒWƒ{, F‡WG G‡Ef …gn ‚G‚P ‚J{ ‚SZ‚h ƒv‚dŠW aƒd ‰jƒO†yKLM. ‡L‚^‚h ‚i‚j†yKLM.");
 ModifyForce(167,1);
 ModifyForce(166,1);
 ModifyForce(165,1);
 JY.Person[167]["µÀ¾ß1"]=0;
 JY.Person[167]["µÀ¾ß2"]=0;
 JY.Person[166]["µÀ¾ß1"]=0;
 JY.Person[166]["µÀ¾ß2"]=0;
 JY.Person[165]["µÀ¾ß1"]=0;
 JY.Person[165]["µÀ¾ß2"]=0;
 PlayWavE(11);
 DrawStrBoxCenter("ƒM„w, ƒWƒ{, F‡WG ^†iPM!");
 else
 AddPerson(166,5,22,0);
 MovePerson( 166,6,0);
talk(166,"†Q‡Y D„`ƒP ‚XS …HƒR‚S …f‡z F‡WG G‡Ef …gn ‚G‚P ‚J{ ‚SZ‚h ƒv‚dŠW aƒd ‰jƒO†yKLM. ‡L‚^‚h ‚i‚j†yKLM.");
 ModifyForce(166,1);
 ModifyForce(165,1);
 JY.Person[166]["µÀ¾ß1"]=0;
 JY.Person[166]["µÀ¾ß2"]=0;
 JY.Person[165]["µÀ¾ß1"]=0;
 JY.Person[165]["µÀ¾ß2"]=0;
 PlayWavE(11);
 DrawStrBoxCenter("ƒWƒ{, F‡WG ^†iPM!");
 end
talk(1,"[, Gd ˆeˆea[. †Q‡Y D„`, ƒdŠOm.",
 151,"ƒ[†{ ƒv‚b ‰q…f ^†ym.");
 MovePerson( 151,7,1);
talk(151,"(‚G‚P, ƒ[uƒd ‚J‚X¡­¡­ …fƒRS ƒLƒm„S |n Šoƒb ‹[S …R u ‚aM. ‚K‚JŠ_ƒWD ƒ_ ƒd†dS ŠInu‚C ˆfaƒNMA¡­¡­)");
 MovePerson( 151,2,1);
 DecPerson(151);
talk(126,"ƒ[†{ ƒGƒo‚h Œ{n †lƒ{S „Q‚V‚CZ. …bFS ƒe‚PB ‚K‡I‚V[.");
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<½øĞĞ³öÕ÷×¼±¸>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [621]=function()
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, ‚SƒW ƒe‚Pa‚V‚CZ.");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"‚K‚J, …bFS ƒe‚Pa‡I‚V[.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"‚K‚J, ‚^ƒZ …f‚h …bF‚V‰a ‚K‡I‚V[.");
 end
 if JY.Tid==203 then--ÑÏÑÕ
talk(203,"‚K‚J, ‚^ƒZ …f‚h …bF‚V‰a ‚K‡I‚V[.");
 end
 if JY.Tid==148 then--¸ÊÄş
talk(148,"‚G‚P ‚J, ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==167 then--ÁèÍ³
talk(167,"‚G‚P ‚J, ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==166 then--ĞìÊ¢
talk(166,"‚G‚P ‚J, ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==165 then--¶¡·î
talk(165,"‚G‚P ‚J, ‹Iƒm„S ŠU ‚^…a…w„tLM.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 PlayBGM(12);
talk(126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 LvUp(2,6);
 LvUp(128,6);
 LvUp(155,6);
 LvUp(38,6);
 LvUp(39,6);
 LvUp(34,6);
 WarIni();
 if GetFlag(90) then
 DefineWarMap(49,"d4ƒa †lII ‚B„e","1. a…C‡] ‚p…D",50,0,16);
 SelectTerm(1,{
 0,8,20,2,0,-1,0,
 125,7,20,2,0,-1,0,
 -1,4,18,2,0,-1,0,
 -1,6,17,2,0,-1,0,
 -1,6,19,2,0,-1,0,
 -1,7,18,2,0,-1,0,
 -1,9,18,2,0,-1,0,
 -1,9,19,2,0,-1,0,
 -1,9,21,2,0,-1,0,
 -1,11,19,2,0,-1,0,
 1,23,5,3,0,-1,1,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 16,12,3,1,2,59,9,0,0,-1,0,
 78,11,8,1,2,56,9,0,0,-1,0,
 62,15,14,1,2,55,25,0,0,-1,0,--Ô­°æ¾ÓÈ»ÊÇ·¢Ê¯³µ
 93,9,4,1,0,58,16,0,0,-1,0,--¼ÖÚ¼
 18,15,5,1,0,58,3,0,0,903,0,--²ÜÈÊ
 209,9,9,1,0,55,21,0,0,-1,0,--ÏÄºîÉĞ
 256,4,8,1,2,54,3,0,0,-1,0,
 257,16,10,1,2,54,3,0,0,-1,0,
 258,8,11,1,2,49,3,0,0,-1,0,
 259,9,3,1,0,49,3,0,0,-1,0,
 260,8,6,1,0,50,3,0,0,-1,0,
 261,9,11,1,2,50,3,0,0,-1,0,
 262,18,5,1,0,49,3,0,0,-1,0,
 292,5,3,1,0,54,9,0,0,-1,0,
 293,5,11,1,2,54,9,0,0,-1,0,
 294,6,4,1,0,52,9,0,0,-1,0,
 295,8,9,1,0,52,9,0,0,-1,0,
 296,19,7,1,0,53,9,0,0,-1,0,
 297,13,7,1,0,53,9,0,0,-1,0,
 298,13,9,1,0,52,9,0,0,-1,0,
 299,16,7,1,0,52,9,0,0,-1,0,
 300,18,7,1,0,51,9,0,0,-1,0,
 274,5,7,1,2,50,6,0,0,-1,0,
 275,6,13,1,2,54,6,0,0,-1,0,
 276,7,12,1,2,54,6,0,0,-1,0,
 277,8,4,1,0,50,6,0,0,-1,0,
 278,18,4,1,0,50,6,0,0,-1,0,
 279,12,5,1,0,50,6,0,0,-1,0,
 --Ô®±ø
 67,18,21,3,3,57,12,0,0,-1,1,--ĞíñÒ/Ôô±ø
 310,19,21,3,3,52,12,0,0,-1,1,
 311,19,22,3,3,52,12,0,0,-1,1,
 312,18,22,3,3,51,12,0,0,-1,1,
 313,20,22,3,3,51,12,0,0,-1,1,
 --Ô®±ø
 79,4,22,4,1,58,9,0,0,-1,1,--ÕÅÁÉ/Æï±ø
 115,3,21,4,1,54,3,0,0,-1,1,--Àîµä
 217,2,20,4,1,54,9,0,0,-1,1,--ÀÖ½ø
 263,0,20,4,1,51,3,0,0,-1,1,
 264,1,21,4,1,51,3,0,0,-1,1,
 265,2,22,4,1,50,3,0,0,-1,1,
 266,3,23,4,1,49,3,0,0,-1,1,
 });
 else
 DefineWarMap(48,"d4ƒa †lI ‚B„e","1. ƒaU ‚p…D",40,0,79);
 SelectTerm(1,{
 0,2,15,4,0,-1,0,
 125,2,14,4,0,-1,0,
 -1,0,13,4,0,-1,0,
 -1,0,17,4,0,-1,0,
 -1,1,14,4,0,-1,0,
 -1,1,16,4,0,-1,0,
 -1,2,17,4,0,-1,0,
 -1,3,16,4,0,-1,0,
 -1,3,19,4,0,-1,0,
 -1,4,17,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 79,15,6,3,2,58,25,0,0,-1,0,
 256,12,10,3,0,52,3,0,0,-1,0,
 257,12,12,3,0,50,3,0,0,-1,0,
 258,10,9,3,0,50,3,3,11,-1,0,
 259,13,7,3,0,49,3,3,11,-1,0,
 260,14,7,3,0,50,3,0,0,-1,0,
 261,13,14,3,0,49,3,0,0,-1,0,
 274,13,11,3,0,52,6,0,0,-1,0,
 275,13,9,3,0,50,6,0,0,-1,0,
 276,15,12,3,0,49,6,0,0,-1,0,
 332,12,9,3,0,50,14,0,0,-1,0,
 
 217,25,15,3,1,54,9,0,0,-1,1,
 292,24,15,3,1,52,9,0,0,-1,1,
 293,25,17,3,1,51,9,0,0,-1,1,
 294,26,14,3,1,51,9,0,0,-1,1,
 295,26,16,3,1,50,9,0,0,-1,1,
 296,27,15,3,1,50,9,0,0,-1,1,
 115,14,1,3,1,54,3,0,0,-1,1,
 297,12,1,3,1,52,9,0,0,-1,1,
 298,13,2,3,1,51,9,0,0,-1,1,
 299,14,3,3,1,51,9,0,0,-1,1,
 300,15,2,3,1,50,9,0,0,-1,1,
 301,16,1,3,1,50,9,0,0,-1,1,
 });
 end
 DrawSMap();
talk(126,"Gd †lƒ{ƒm„S g‚Ta…x.")
 JY.Smap={};
 if GetFlag(90) then
 	SetSceneID(0,3);
	talk(142,"ƒOu ‚TG W‚P‚h ŠP ƒaU‚h ŒEƒR‚S ‚[†yM. ‚B‚T! …b_a‚f!")
 	SetSceneID(0);
	talk(80,"G‹@! a…C‡]S ‚CƒQa…e ‡y q ‚a‚wƒv. ‹U‹VaDM!")
	 NextEvent(626); --goto 626
 else
 	SetSceneID(0,11);
	talk(142,"ƒOu‚b Œ_nƒW ‡{{ ‚n ‚[ ‚mG M„e‚b ƒuS ‚C‰aƒs…x. ‚SŠS ‚G‚P‚h ‰I†y‚b^. ƒ_Q‚b †o‹JG M Ca‚b „KG ^ƒa ŠoM.")
 	SetSceneID(0,11);
	talk(80,"[‚TG W‚P‚h „Q…e [‚C ‚k‚b‚T. ŠU‹kM. ‚B‚T Œa‚V ˆl„Lb ‚G‚P‚TƒP AAS ŠP‚f.")
 	NextEvent(622); --goto 622
 end
 JY.Status=GAME_WMAP;
WarSave(6)
 end
 end
 end,
 [622]=function()
 PlayBGM(11);
talk(80,"ŠU‹kM, ‹z‚C ‚kƒb ‡KaM. ‚B‚T ‚Kƒca‚f, ‚G‚P‚TƒP AAS ‰B‚pa‚f.",
 126,"‚K‚J, ‚J‚pS …HƒtKLM. W‚PƒP ƒaU‚TG G‡EY‚C †PKB ŠXKLM.",
 1,"‚M¡­¡­ ‚B‚T ƒaU‚h ŠGn ‰j„E Œ{nƒ_‚f!");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [623]=function()
 WarLocationItem(13,14,47,107); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¶ÓÊé
 WarLocationItem(3,17,146,108); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÃÍ»ğÊé ¸ÄÎª °×Òø¼×
 WarLocationItem(17,27,34,109); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÕ¨µ¯
 if (not GetFlag(1072)) and War.Turn==8 then
 PlayBGM(11);
 WarShowArmy(217);
 WarShowArmy(292);
 WarShowArmy(293);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 DrawStrBoxCenter("ƒaUƒP ƒQ‚TG D†WPM!");
talk(218,"ƒaU! „@S ‹z…c‚C …X‚V[! …vgG ŠXm!",
 80,"[, …vgG ŠX‚wƒv! ‚SŠq‚ru ˆGƒ`ŠX†y‚C! †|†}aM, ƒQ‚TG ŠXM!");
 PlayBGM(9);
 SetFlag(1072,1);
 end
 if (not GetFlag(1073)) and War.Turn==10 then
 PlayBGM(11);
 WarShowArmy(115);
 WarShowArmy(297);
 WarShowArmy(298);
 WarShowArmy(299);
 WarShowArmy(300);
 WarShowArmy(301);
 DrawStrBoxCenter("ƒaUƒP ƒQ‚TG D†WPM!");
talk(116,"ƒaU, ‹z‚SƒW †w‚oa[!",
 80,"[, G‚BG …Xƒlƒ_ ŠX‚wƒv! ŠoM, ‡T‚J‚pS †K‚Va‚f!");
 PlayBGM(9);
 SetFlag(1073,1);
 end
 if WarMeet(3,80) then
 WarAction(1,3,80);
talk(3,"ƒaU, [ˆs„VG[!",
 80,"ƒa‚Pj^? ŠU ŠXM! …I‚_…I„S „}ƒ^…x!",
 3,"…M, „pQ gMA ƒv‚b ƒa‚P^ nLM! [H‚f, ƒaU!");
 WarAction(6,3,80);
 if fight(3,80)==1 then
talk(3,"GƒsQ, Gd ˆf „qD†y‚C!",
 80,"‡m, †J‚V ƒ[‚_^ ‚Ia‚wƒ`!",
 3,"†gS …Hn‚f!!");
 WarAction(8,3,80);
talk(80,"ƒmŒF! …M, a‚b q ‚aM. ‚B‚T …C…D! ƒa‚P, ‹`ƒS M‚V ƒs…x!");
 WarAction(16,80);
talk(3,"ŒL, ˆGnƒvƒG‚b ƒE‚j‚wƒv. a, b†a^ …G„kƒmL Gd ‚saf ƒv‚h ‡iX …x^ ‚aM!");
 WarLvUp(GetWarID(3));
 NextEvent();
 else
 WarAction(4,80,3);
talk(3,"¡­¡­");
 WarAction(17,3);
 WarLvUp(GetWarID(80));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(80,"…M, a‚b q ‚aM. …C…Da‚f! ‚SƒW ƒA…eƒv‚f!");
 NextEvent();
 end
 end,
 [624]=function()
 PlayBGM(7);
 DrawMulitStrBox("¡¡ƒaU‚TG ƒA…eŠgM.");
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£µ£°£°S …V„kM!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [625]=function()
 SetSceneID(0,3);
change_mode()
talk(1,"…Xƒlƒ_ ‡fn„jM. ŠoM, ‚B‚T M‚V F‚PB ‰bƒU„S †lƒ{S ˆjM.",
 126,"‚^‚_‚h „Kƒ{B ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(49,"d4ƒa †lII ‚B„e","1. a…C‡] ‚p…D",50,0,16);
 SelectTerm(1,{
 0,8,20,2,0,-1,0,
 125,7,20,2,0,-1,0,
 -1,4,18,2,0,-1,0,
 -1,6,17,2,0,-1,0,
 -1,6,19,2,0,-1,0,
 -1,7,18,2,0,-1,0,
 -1,9,18,2,0,-1,0,
 -1,9,19,2,0,-1,0,
 -1,9,21,2,0,-1,0,
 -1,11,19,2,0,-1,0,
 1,23,5,3,0,-1,1,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 16,12,3,1,2,59,9,0,0,-1,0,
 78,11,8,1,2,56,9,0,0,-1,0,
 62,15,14,1,2,55,25,0,0,-1,0,--Ô­°æ¾ÓÈ»ÊÇ·¢Ê¯³µ
 93,9,4,1,0,58,16,0,0,-1,0,--¼ÖÚ¼
 18,15,5,1,0,58,3,0,0,903,0,--²ÜÈÊ
 209,9,9,1,0,55,21,0,0,-1,0,--ÏÄºîÉĞ
 256,4,8,1,2,54,3,0,0,-1,0,
 257,16,10,1,2,54,3,0,0,-1,0,
 258,8,11,1,2,49,3,0,0,-1,0,
 259,9,3,1,0,49,3,0,0,-1,0,
 260,8,6,1,0,50,3,0,0,-1,0,
 261,9,11,1,2,50,3,0,0,-1,0,
 262,18,5,1,0,49,3,0,0,-1,0,
 292,5,3,1,0,54,9,0,0,-1,0,
 293,5,11,1,2,54,9,0,0,-1,0,
 294,6,4,1,0,52,9,0,0,-1,0,
 295,8,9,1,0,52,9,0,0,-1,0,
 296,19,7,1,0,53,9,0,0,-1,0,
 297,13,7,1,0,53,9,0,0,-1,0,
 298,13,9,1,0,52,9,0,0,-1,0,
 299,16,7,1,0,52,9,0,0,-1,0,
 300,18,7,1,0,51,9,0,0,-1,0,
 274,5,7,1,2,50,6,0,0,-1,0,
 275,6,13,1,2,54,6,0,0,-1,0,
 276,7,12,1,2,54,6,0,0,-1,0,
 277,8,4,1,0,50,6,0,0,-1,0,
 278,18,4,1,0,50,6,0,0,-1,0,
 279,12,5,1,0,50,6,0,0,-1,0,
 --Ô®±ø
 67,18,21,3,3,57,12,0,0,-1,1,--ĞíñÒ/Ôô±ø
 310,19,21,3,3,52,12,0,0,-1,1,
 311,19,22,3,3,52,12,0,0,-1,1,
 312,18,22,3,3,51,12,0,0,-1,1,
 313,20,22,3,3,51,12,0,0,-1,1,
 --Ô®±ø
 79,4,22,4,1,58,9,0,0,-1,1,--ÕÅÁÉ/Æï±ø
 115,3,21,4,1,54,3,0,0,-1,1,--Àîµä
 217,2,20,4,1,54,9,0,0,-1,1,--ÀÖ½ø
 263,0,20,4,1,51,3,0,0,-1,1,
 264,1,21,4,1,51,3,0,0,-1,1,
 265,2,22,4,1,50,3,0,0,-1,1,
 266,3,23,4,1,49,3,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [626]=function()
 PlayBGM(11);
talk(17,"‚G‚P, HI ƒOJ‚_‚b‚wƒv! G a…C‡]G ‚n‚TƒP †~ˆY Nƒ}S ƒsb ‚K…X.",
 126,"‚K‚J, †lƒ{S ‡F‚YaA „Y†oG „I‹IhLM. ‚SƒW „Q‚V‚CZ!");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [627]=function()
 WarLocationItem(13,5,1,111); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¶İ¼×ÌìÊé
 WarLocationItem(12,19,18,112); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÂíÊõÖ¸ÄÏÊé
 WarLocationItem(3,16,19,113); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º½£ÊõÖ¸ÄÏÊé
 if (not GetFlag(216)) and WarCheckLocation(-1,15,15) then
talk(1,"ŠoM! D†K„W‚h ƒ_ƒ`‚f!");
 --
 SetWarMap(16,17,1,4);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=62;
 WarDelay(12);
 --
 DrawStrBoxCenter("D†K„W^ ƒ_ƒ`ƒFM!");
talk(79,"I‡JG, D†K„W^ ƒ_ƒ`ƒFMƒd!? …M, ƒOƒg …f…x‚b †~ƒm„S ˆ[S q^ ‚a‚wƒv! fŒS! gƒb ƒv‚ef a†yM. ŠGn ‰j„E‚f!");
 WarModifyAI(297,1);
 WarModifyAI(298,1);
 WarModifyAI(299,1);
 SetFlag(216,1);
 end
 if WarMeet(3,79) then
 WarAction(1,3,79);
talk(3,"ƒW‚U! ƒ_‰z [ƒXG „p dŒKƒSGM! ƒv‚h „V‚q GC H‚b ‹[GM!",
 79,"‰umu! HD eƒO‡z „Gƒb ŒBS ‡iaƒd Š]ƒmŠm?",
 3,"„N…xa‚wƒv! ƒSˆcQ ‚[‚C ‚k†yM, †gS …Hn‚f!");
 WarAction(6,3,79);
 if fight(3,79)==1 then
talk(79,"…v! H, HI ‚IaM!",
 3,"…M, ƒv‚h G†r ƒ{Š]ƒmŠm? †gS …Hn‚f! …G‚S‚f!");
 WarAction(8,3,79);
talk(79,"ƒmŒF¡­¡­",
 79,"…C, …C‚}‡f†PG„SM¡­¡­");
 WarAction(17,79);
 WarLvUp(GetWarID(3));
 else
 WarAction(4,79,3);
talk(3,"ƒmŒF¡­¡­");
 WarAction(17,3);
 WarLvUp(GetWarID(79));
 end
 end
 if (not GetFlag(215)) and WarCheckArea(-1,11,4,13,15) then
talk(17,"ƒ{‚oY‚C ƒR‚SŠX†sŠm, aaa. ƒ_ „T‚vf ‚@ƒ`ƒR„k‚wƒv. ‚SŠS Mu aƒv„V …I‚^…e …g„} ‚[„k‚b‚C ŠInu‚CD ‚kML. ƒ[‡EfƒW‚b ƒvn^‚CD ƒA…eƒW‚CD ˆfoM. ƒG‚}^ ŠXM! †M…~f ƒLS IH„]ƒ`‚f!!");
 WarModifyAI(258,4,8,14);
 WarModifyAI(261,4,8,14);
 WarModifyAI(293,4,8,14);
 WarModifyAI(275,4,8,14);
 WarModifyAI(276,4,8,14);
 SetFlag(215,1);
 end
 if (not GetFlag(1074)) and War.Turn==5 then
 WarShowArmy(67);
 WarShowArmy(310);
 WarShowArmy(311);
 WarShowArmy(312);
 WarShowArmy(313);
 DrawStrBoxCenter("‡m…fƒP ƒQ‚TG D†WPM!");
talk(68,"…yƒNŠW ‹fƒtM, ƒWŠe…e‚f!");
 SetFlag(1074,1);
 end
 if (not GetFlag(1075)) and GetFlag(90) and War.Turn==10 then
 WarShowArmy(79);
 WarShowArmy(115);
 WarShowArmy(217);
 WarShowArmy(263);
 WarShowArmy(264);
 WarShowArmy(265);
 WarShowArmy(266);
 DrawStrBoxCenter("ƒaUƒP ƒQ‚TG D†WPM!");
talk(80,"a…C ƒa‚T, ‹z‚SƒW †w‚oa[! ‡Y‡bS ƒAu„Q‚b …h ‚V…yG ‹j ‚@„~m.",
 17,"[, ƒaU^ …Xƒlƒ_ ŠX‚wƒv!");
 SetFlag(1075,1);
 end
 if GetFlag(58) and WarCheckArea(-1,3,9,5,14) then
 PlayBGM(11);
talk(17,"‚_†io ‚G‚P‚T! ‡NŠW bƒGY‚C [ML!");
 PlayBGM(12);
 WarShowArmy(1);
talk(2,"ˆEŠiŠ_ƒW ‰Wƒ@f ‹naŠVM Š^ƒd G eƒO^ ˆGƒ`ŠXKLM! ƒc…~G n‡P†Eˆe ƒA…eƒW‚f!",
 1,"[¡­¡­! ŠUˆf „v ƒuG nL†y‚C! eƒO, ƒ[‚_j^!",
 2,"a…C‡], G eƒO^ ƒ[‚_‚h „Vƒv…e ŠXm!");
 WarMoveTo(2,12,2);
 WarAction(1,2,17);
talk(17,"H, H‚b eƒO! …G‚C ‚kƒt†sŠm!",
 2,"‚n^ ˆoa‚C ‚k‚b o ƒv‚b …GS q ‚am. …`‚ffQƒW ‰BnŠXm.",
 17,"ŠoM, ƒ_^ M‚V ƒ[u„S ƒsƒ_ ‚K…X!");
 WarAction(5,17,2);
talk(17,"…G‚C ‚k‚b …x„S‚T. M‚V ƒq‚S ‚K…X.",
 2,"ƒ[ FD ‹MƒT„S‚b C‚_^ „C‚C ‚k‚bM!");
 WarAction(4,2,17);
talk(17,"ƒmŒF!",
 2,"a…C‡]! v†da‚V[!");
 WarAction(8,2,17);
talk(17,"ƒm…v!!");
 WarAction(18,17);
talk(2,"…M¡­¡­ a…C‡], ŠU ^‚V[¡­¡­");
 WarLvUp(GetWarID(2));
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 --talk( 17,"Äã£¬ÄãÃÇ¡­¡­ÎÒËäËÀ£¬Îº¹úÒ²²»»áÍö£¡à»£¡à»£¡");
talk(17,"H, HŠsƒR¡­¡­ ‚n‚b ˆoa‚C ‚k‚bM! „^ŒF! „^ŒF!");
 SetFlag(904,1); --ÏÄºîª´æ»î
 NextEvent();
 end
 end,
 [628]=function()
 PlayBGM(7);
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£µ£°£°S …V„kM!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [629]=function()
 SetSceneID(0);
 if GetFlag(904) then
 DrawMulitStrBox("¡¡‚G‚P‚TG a…C‡]S ƒqƒd †lƒ{S ‡F‚YPM.*¡¡„Y†oG „I‹IGL, ‚G‚P |ˆEdƒP ‹dj oN ‚^…MD¡­¡­");
 else
 DrawMulitStrBox("¡¡‚G‚P‚TG a…C‡]S „_ƒd †lƒ{S ‡F‚YPM.*¡¡„Y†oG „I‹IGL, ‚G‚P |ˆEdƒP ‹dj oN ‚^…MD¡­¡­");
 end
 NextEvent();
 end,
 [630]=function()
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d4ƒa¡¡‚eƒQ †@‚r‚B";
 DrawStrBoxCenter("d4ƒa¡¡‚eƒQ †@‚r‚B");
 LoadPic(33,1);
 DrawMulitStrBox("¡¡‚nfQ †lƒ{ƒP ‰Hˆyƒb „^ƒvƒn …@‚pG„kM.*¡¡v‚P‚b ‡m†gf ‚_‚TS ‚Zn ‡{‚TƒP ‚J‚pf ‚_‚PPM.");
 LoadPic(33,2);
 SetSceneID(0,11);
talk(213,"‡m†gƒm„S ^‚f! ‡m†gfƒW ƒL‚TS ŠGn ‰j‡SM!");
 if GetFlag(90) then
 SetSceneID(0,0);
 DrawMulitStrBox("¡¡†lƒ{G ‰HˆyˆY …hf‚b ‡{{ [^ ‚l‚Vf ‚n‚h ˆj ƒuG ƒn YVG„kM.*¡¡‚l[^ W‚P‚h „Q‚b ƒU†vf ‚nƒP ‚~ƒ}G ‡L„[„C„kƒd, W‚PƒP ƒaU …}G _G Eb †lƒ{f ‡t‡Lo ‚Bƒ}S ‚ZS q ‚a„kŠB ƒuGM.");
 end
 if GetFlag(89) then
 NextEvent(631); --goto 631
 else
 SetSceneID(0,11);
talk(242,"v‚P ŠDaŠ_ƒW ‚n‚|„BM! „Y†ofƒW ‚G‚P‚TS ‡fn‚f!");
 NextEvent(642); --goto 642
 end
 end,
 [631]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†l";
 JY.Base["D‚wC"]=25;
 AddPerson(1,25,17,2);
 AddPerson(126,26,10,1);
 AddPerson(175,12,18,0);
 if GetFlag(58) then
 AddPerson(3,24,9,1);
 AddPerson(2,16,13,3);
 ModifyForce(2,1);
 ModifyForce(128,1);
 ModifyForce(155,1);
 ModifyForce(39,1);
 ModifyForce(34,1);
 ModifyForce(38,1);
 end
 SetSceneID(47,5);
 DrawStrBoxCenter("†l ƒP‚r‰R");
 if GetFlag(58) then
talk(2,"ˆEŠi, ˆE‚K‚h ŒOƒd i HG ‚a„kƒmƒv ˆEŠiŠ_ƒW G‡EfƒW ‰jƒOƒNM‚b ˆ|S Š^ƒd @†j{ ‰BS I‹{ˆ`ƒd ‹qnŠXKLM.",
 1,"ƒ[ I‡H ˆ|GŠm. „p^ †jn „OM‚b ƒu„Vƒm„S ‡t‡LaM. ˆE‚KD „C‹qƒtƒmL …X‚Mf Še ƒu ‚aM. ‰HŠ_ ‚n‚h „Q‚b ‚_†nS Gƒ^…x.",
 2,"n! ‡N‚rWLM, ˆEŠi.");
 MovePerson(3,2,2);
 MovePerson(3,2,1);
 MovePerson(3,2,3);
 MovePerson( 3,1,1,
 2,0,0);
talk(3,"Še[ ˆEŠi, [ƒXƒb NF …X‚V‚CZ! …x, ‰xS …w‡I‚V[!",
 2,"…x„p‡z ƒHS …XƒN ‚C [†G„C„k‚T. [ƒXƒb la‚C ‚kƒd‚b ƒ[„V‚[‚C ‚k†y„p!",
 3,"ƒ[†G…E‚CZ. ŠoKLM, ˆEŠi. ƒGMu†yKLM.");
 MovePerson( 2,10,2,
 3,10,2);
 DecPerson(2);
 DecPerson(3);
 end
 MovePerson(175,4,2);
 MovePerson(175,3,0);
 MovePerson(175,3,3);
talk(175,"‚K‚J, ‚n^ †lƒ{S ŒO„kƒmL „^Q ‡i‚UPS ƒuhLM. †M…~f ‹h‚SŒEG‚V‚CZ.",
 126,"‚C‡io ˆ|Š[G[. ‡mƒv ‚Cƒgƒb e‚eƒP ƒGK‚_‚h ƒGM„t‚VM. ƒ[ƒR{ W]a‚C ‚kƒmA ‚nƒP Fk‚h GƒGƒG ‚SŠqm.");
 if GetFlag(38) then
talk(1,"v‡S …I‚]fQ I‡H …IG `ŒI ƒuƒb nL†y‚C¡­¡­");
 else
talk(1,"„N„w …I‚]fQ I‡H …IG `ŒI ƒuƒb nL†y‚C¡­¡­");
 end
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<Ì¸ÂÛ½ñºóµÄ»°£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [632]=function()
 if JY.Tid==126 then--Öî¸ğÁÁ
talk(126,"ƒGK‚_‚h ƒGMu…x.");
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"ƒGK‚_^ …I~ ‹fn…E X ‹|…h.");
 end
 end,
 [633]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†oƒwe";
 JY.Base["D‚wC"]=0;
 if GetFlag(38) then
 AddPerson(54,8,18,0);
 AddPerson(190,11,11,3);
 AddPerson(127,21,17,2);
 else
 AddPerson(133,8,18,0);
 AddPerson(54,11,11,3);
 AddPerson(190,21,17,2);
 end
 SetSceneID(97,12);
 DrawStrBoxCenter("†oƒwe „vg");
 DrawMulitStrBox("¡¡o„K o‚eƒP †oƒwefƒW‚b ‚G‚P‚T ƒGK‚_^ gS „Qƒd „O„kM.");
 WarIni();
 if GetFlag(38) then
talk(54,"‚Kƒ}ƒb „Av„SG „Y†oƒm„S g‚paƒd „O†y‚CZ. G‚_„S‚fA ‡m†gfƒW †@‚BS „Q‚jQ Š} ƒuhLM.",
 190,"v ƒa‚T, ƒOuD ‹z‚C ‚kQ ‚SƒW ‚Kƒ}{ W]W‚VM.",
 127,"ƒ[ŠQm. †TdƒP RI‚b …X‡RƒmL bƒG „l ŠcƒA YVG ‚a‚C ‚km?",
 54,"‡mƒv e‚e{ ƒa‚oƒP ‚n‚TS ƒ[ˆ} Še q‚b ‚am. ƒ[…e‚C ‚kƒmA ‚Kƒ}ƒP †c…C^ K‚p‡ia[. †R q „O‚b „VAƒb ŠP L‚VM.",
 190,"…b‚pW‚VM.",
 54,"‚M, M„V ‚V…yS HI ‡m‚Pa‚C …X‚V[. ‚Kƒ}{ W]a‚b ƒuG ^ƒa ‚eZa[.",
 127,"„a†ym.");
 --ko fix: original script forgot to return the raiding party to the player side in this branch (all units became allies)
 ModifyForce(54,1);
 ModifyForce(190,1);
 ModifyForce(127,1);
 ModifyForce(83,1);
 ModifyForce(65,1);
 ModifyForce(82,1);
 ModifyForce(114,1);
 ModifyForce(117,1);
 ModifyForce(188,1);
 DefineWarMap(52,"d4ƒa g†g ‚B„e","1. ‡sm ‚p†U",30,53,242);
 SelectTerm(1,{
 53,3,13,4,0,-1,0,
 189,3,12,4,0,-1,0,
 126,2,10,4,0,-1,0,
 82,4,11,4,0,-1,0,
 64,0,13,4,0,-1,0,
 81,1,12,4,0,-1,0,
 113,1,11,4,0,-1,0,
 116,5,13,4,0,-1,0,
 187,1,9,4,0,-1,0,
 });
 else
talk(133,"‚Kƒ}ƒb „Av„SG „Y†oƒm„S g‚paƒd „O†y‚CZ. G‚_„S‚fA ‡m†gfƒW †@‚BS „Q‚jQ Š} ƒuhLM.",
 54,"‚T‚r, ƒOuD ‹z‚C ‚kQ ‚SƒW ‚Kƒ}{ W]W‚VM.",
 190,"ƒ[ŠQm. †TdƒP RI‚b …X‡RƒmL bƒG „l ŠcƒA YVG ‚a‚C ‚km?",
 133,"‡mƒv e‚e{ ƒa‚oƒP ‚n‚TS ƒ[ˆ} Še q‚b ‚am. ƒ[…e‚C ‚kƒmA ‚Kƒ}ƒP †c…C^ K‚p‡ia[. †R q „O‚b „VAƒb ŠP L‚VM.",
 54,"ƒ[†{ ‚SƒW …b‚pW‚VM.",
 133,"‚M, M„V ‚V…yS HI ‡m‚Pa‚C …X‚V[. ‚Kƒ}{ W]a‚b ƒuG ^ƒa ‚eZa[.",
 190,"k.");
 ModifyForce(133,1);
 ModifyForce(54,1);
 ModifyForce(190,1);
 ModifyForce(127,1);
 ModifyForce(83,1);
 ModifyForce(65,1);
 ModifyForce(82,1);
 ModifyForce(114,1);
 ModifyForce(117,1);
 ModifyForce(188,1);
 DefineWarMap(52,"d4ƒa g†g ‚B„e","1. ‡sm ‚p†U",30,132,242);
 SelectTerm(1,{
 132,2,13,4,0,-1,0,
 53,3,13,4,0,-1,0,
 189,3,12,4,0,-1,0,
 126,2,10,4,0,-1,0,
 82,4,11,4,0,-1,0,
 64,0,13,4,0,-1,0,
 81,1,12,4,0,-1,0,
 113,1,11,4,0,-1,0,
 116,5,13,4,0,-1,0,
 187,1,9,4,0,-1,0,
 });
 end
 JY.Smap={};
 SetSceneID(0,3);
 ModifyForce(244,9);
 ModifyForce(236,9);
 ModifyForce(235,9);
 ModifyForce(237,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 242,30,9,3,2,54,20,0,0,-1,0,
 243,16,10,3,4,50,9,20,12,-1,0,
 235,14,10,3,0,49,17,0,0,-1,0,
 234,15,9,3,0,48,17,0,0,-1,0,
 236,15,12,3,0,48,17,0,0,-1,0,
 332,14,11,3,0,45,14,0,0,-1,0,
 256,5,3,3,0,45,3,0,0,-1,0,
 257,17,4,3,0,44,3,0,0,-1,0,
 258,4,1,3,0,45,3,0,0,-1,0,
 259,13,5,3,0,45,3,0,0,-1,0,
 260,14,3,3,0,44,3,0,0,-1,0,
 261,24,9,3,2,44,3,0,0,-1,0,
 262,28,9,3,0,44,3,0,0,-1,0,
 292,29,10,3,0,48,9,0,0,-1,0,
 293,20,10,3,0,47,9,0,0,-1,0,
 294,21,9,3,0,48,9,0,0,-1,0,
 295,19,5,3,0,47,9,0,0,-1,0,
 296,20,8,3,0,47,9,0,0,-1,0,
 297,29,8,3,0,46,9,0,0,-1,0,
 274,5,1,3,0,45,6,0,0,-1,0,
 275,10,3,3,0,46,6,0,0,-1,0,
 276,18,4,3,0,46,6,0,0,-1,0,
 277,24,6,3,2,47,21,0,0,-1,0,
 278,24,12,3,2,47,21,0,0,-1,0,
 279,25,9,3,2,47,21,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [634]=function()
 PlayBGM(11);
talk(243,"‡{‚TG …Xƒlƒ_ ŠPƒR‚SŠX‚wƒv. ‡mƒv G g†gS ‚CƒS `‚Eƒb …X‚f. †cŒDG „O†Eˆe ‡zƒW ŒE‚S ƒsn‚f!");
 if GetFlag(38) then
talk(54,"g†gƒb ƒc‚w‹l „Gƒb Z‚ChLM. ‚V…yS ‡m‚Pa‚C ˆ|ƒd ƒN…{ŠW ‰Hˆya‚V‚CZ!");
 else
talk(133,"g†gƒb ƒc‚w‹l „Gƒb Z‚ChLM. ‚V…yS ‡m‚Pa‚C ˆ|ƒd ƒN…{ŠW ‰Hˆya‚V‚CZ!");
 end
talk(244,"‚n‚Tƒb †JƒLGM. ƒ_^ „c‚TS ‰Iƒd „O‚b ƒuƒb n†m^.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [635]=function()
 if WarMeet(127,243) then
 WarAction(1,127,243);
talk(127,"[‚b ƒaq^ ƒLƒP „wqŠ@M. …Xƒl ŠU ŠXM, …I‚_…I„S „}ƒ^…x!",
 243,"‹U‹Va‚wƒv¡­¡­! bƒGY‚C [Q ‚[„kƒmL t‚^‚h ^„u q‹wf!");
 WarAction(6,127,243);
 if fight(127,243)==1 or true then
talk(127,"{…B „wq„SM! ‚_†Ma‚wƒv!",
 243,"‰u¡­¡­!");
 WarAction(4,127,243);
talk(127,"a, a¡­¡­",
 243,"…Hn‚f!",
 127,"…v! ƒn…IGM!");
 WarAction(8,243,127);
talk(127,"ƒmn…v! ¡­¡­ ¡­¡­ ¡­¡­? ƒ_^ n„L †jn „O‚b^?",
 243,"…v! ‚V, †dƒaG¡­¡­ G‹@¡­¡­ ‡EfƒW¡­¡­ ‚C‚~G¡­¡­.",
 127,"‚SŠS ˆY …IGŠm?");
 WarAction(19,243);
talk(243,"ƒn…IGM¡­¡­. ‚~ƒm„S¡­¡­ ˆ`…eƒFM¡­¡­.",
 127,"†~ƒm„S n…jn…jPM!");
 WarAction(18,243);
 WarLvUp(GetWarID(127));
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚T ƒGK‚_^ ‡sm‚h ƒqƒd,*¡¡g†gS ‡F‚YPM.");
 NextEvent();
 else
 WarAction(4,243,127);
talk(127,"‚_†Ma‚wƒv!");
 WarAction(17,127);
 WarLvUp(GetWarID(243));
 end
 end
 WarLocationItem(0,14,61,115); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÁùèº
 WarLocationItem(3,18,17,116); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º¹­ÊõÖ¸ÄÏÊé
 WarLocationItem(6,26,62,117); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÈıÂÔ
 if (not GetFlag(94)) and WarMeet(-1,244) then
 PlayBGM(11);
talk(244,"„l‚b ‚n‚Tf ŠcƒA q ‚aM! G ‚I‚G, ‚Cƒg ‡{‚Tf ^†ia†ym!");
 ModifyForce(244,1);
 PlayWavE(11);
 DrawStrBoxCenter("‚I‚G^ n‚Tf ^†iPM!");
 PlayBGM(9);
 SetFlag(94,1);
 end
 if (not GetFlag(114)) and WarMeet(190,236) then
 PlayBGM(11);
talk(190,"ƒ[‚_ƒRƒb ‚I„RG n†m^? ‚SŠS ‚n‚TS ‚i‚f ƒOu ‹IS ‡f‚b^!",
 236,"n, …Xƒ| ƒa‚TG‚V‚TZ! ‚n‚TfQ B‚h hƒmŠVM ƒR„k‚b…h I‚raŠV‚TZ!",
 190,"ƒA‹mG[. ƒ[u ‹]G …GS u „O†ym.",
 236,"ƒOu‚b …Xƒ| ƒa‚T{ ŠGE ƒ]G ‚am. Gd ƒOu ‚I„Rƒb ƒ[‚_ „Kf ƒW†ym.");
 ModifyForce(236,1);
 ModifyForce(235,1);
 ModifyForce(237,1);
 PlayWavE(11);
 DrawStrBoxCenter("GˆM„R ‚I„RG n‚Tf ^†iPM!");
 WarLvUp(GetWarID(190));
 PlayBGM(9);
 SetFlag(114,1);
 end
 if (not GetFlag(114)) and WarMeet(190,235) then
 PlayBGM(11);
talk(190,"ƒ[‚_ƒRƒb ‚I„RG n†m^? ‚SŠS ‚n‚TS ‚i‚f ƒOu ‹IS ‡f‚b^!",
 235,"n, …Xƒ| ƒa‚TG‚V‚TZ! ‚n‚TfQ B‚h hƒmŠVM ƒR„k‚b…h I‚raŠV‚TZ!",
 190,"ƒA‹mG[. ƒ[u ‹]G …GS u „O†ym.",
 235,"ƒOu‚b …Xƒ| ƒa‚T{ ŠGE ƒ]G ‚am. Gd ƒOu ‚I„Rƒb ƒ[‚_ „Kf ƒW†ym.");
 ModifyForce(236,1);
 ModifyForce(235,1);
 ModifyForce(237,1);
 PlayWavE(11);
 DrawStrBoxCenter("GˆM„R ‚I„RG n‚Tf ^†iPM!");
 WarLvUp(GetWarID(190));
 PlayBGM(9);
 SetFlag(114,1);
 end
 if (not GetFlag(114)) and WarMeet(190,237) then
 PlayBGM(11);
talk(190,"ƒ[‚_ƒRƒb ‚I„RG n†m^? ‚SŠS ‚n‚TS ‚i‚f ƒOu ‹IS ‡f‚b^!",
 237,"n, …Xƒ| ƒa‚TG‚V‚TZ! ‚n‚TfQ B‚h hƒmŠVM ƒR„k‚b…h I‚raŠV‚TZ!",
 190,"ƒA‹mG[. ƒ[u ‹]G …GS u „O†ym.",
 237,"ƒOu‚b …Xƒ| ƒa‚T{ ŠGE ƒ]G ‚am. Gd ƒOu ‚I„Rƒb ƒ[‚_ „Kf ƒW†ym.");
 ModifyForce(236,1);
 ModifyForce(235,1);
 ModifyForce(237,1);
 PlayWavE(11);
 DrawStrBoxCenter("GˆM„R ‚I„RG n‚Tf ^†iPM!");
 WarLvUp(GetWarID(190));
 PlayBGM(9);
 SetFlag(114,1);
 end
 if (not GetFlag(1076)) and War.Turn==30 then
 PlayBGM(11);
 if GetFlag(38) then
talk(54,"‚o „C†yM, †@‚Bf ‹z†yM! ‚B‚T, …{D‚h ‰Eb ‚Bga‚f!");
 else
talk(133,"‚o „C†yM, †@‚Bf ‹z†yM! ‚B‚T, …{D‚h ‰Eb ‚Bga‚f!");
 end
 SetFlag(93,1);
 SetFlag(1076,1);
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARLOSE then
 PlayBGM(11);
 if GetFlag(38) then
talk(54,"‹U‹Va‚wƒv! G†GƒW‚b †@‚Bf ‹z†yM!");
 else
talk(133,"‹U‹Va‚wƒv! G†GƒW‚b †@‚Bf ‹z†yM!");
 end
 SetFlag(93,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARWIN then
talk(243,"‹U‹VaM. ‚G‚P‚TS ‡f‚C ˆfaL ƒv‚b G g‚C‡z ‡S‚XS ‰HŠ_a†yM.");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚T ƒGK‚_^ ‡sm‚h ƒqƒd,*¡¡g†gS ‡F‚YPM.");
 NextEvent();
 end
 end,
 [636]=function()
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£¶£°£°S …V„kM!");
bonus_moneyexp_4()
 if GetFlag(38) then
talk(54,"ŠoM, ‚SƒW ƒa‚oS ŠP‚f!");
 else
talk(133,"ŠoM, ‚SƒW ƒa‚oS ŠP‚f!");
 end
 JY.Status=GAME_WMAP2;
 NextEvent();
 end,
 [637]=function()
change_mode()
 --JY.Smap={};
 --SetSceneID(0,3);
 WarIni2();
 if GetFlag(38) then
 DefineWarMap(53,"d4ƒa ƒa‚o ‚B„e","1. vg ‚p†U",60,53,241);
 else
 DefineWarMap(53,"d4ƒa ƒa‚o ‚B„e","1. vg ‚p†U",60,132,241);
 end
 SelectTerm2(1,{
 -1,1,9,4,0,-1,0,
 -1,2,8,4,0,-1,0,
 -1,4,8,4,0,-1,0,
 -1,4,10,4,0,-1,0,
 -1,2,6,4,0,-1,0,
 -1,0,7,4,0,-1,0,
 -1,3,12,4,0,-1,0,
 -1,0,11,4,0,-1,0,
 -1,2,10,4,0,-1,0,
 -1,1,13,4,0,-1,0,
 -1,3,5,4,0,-1,0,
 -1,1,5,4,0,-1,0,
 -1,1,6,4,0,-1,0,
 -1,0,9,4,0,-1,0,
 });
 ModifyForce(112,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 241,30,8,3,2,57,20,0,0,-1,0,
 102,18,3,3,2,55,22,20,12,-1,0,
 111,18,14,3,2,52,16,0,0,-1,0,
 100,28,8,3,2,53,21,0,0,-1,0,
 19,9,8,3,2,53,25,0,0,-1,0,
 214,9,9,3,2,53,25,0,0,-1,0,--dos±øÖÖÉè¶¨Îª3
 215,18,13,3,2,54,9,0,0,-1,0,--ÅÓµÂ
 17,26,8,3,2,55,22,0,0,901,0,--ÏÄºîÔ¨
 256,27,6,3,2,49,3,0,0,-1,0,
 257,30,11,3,2,47,3,0,0,-1,0,
 258,25,8,3,2,48,3,0,0,-1,0,
 259,9,7,3,2,48,3,0,0,-1,0,
 260,9,10,3,2,48,3,0,0,-1,0,
 261,14,4,3,2,48,3,0,0,-1,0,
 274,28,9,3,2,48,6,0,0,-1,0,
 275,19,3,3,2,47,6,0,0,-1,0,
 
 276,19,13,3,2,49,6,0,0,-1,0,
 277,15,5,3,2,48,6,0,0,-1,0,
 292,11,7,3,0,50,9,0,0,-1,0,
 293,20,5,3,2,50,9,0,0,-1,0,
 294,20,11,3,2,49,9,0,0,-1,0,
 295,12,7,3,0,50,9,0,0,-1,0,
 332,16,13,3,2,50,14,0,0,-1,0,
 348,11,8,3,0,49,19,0,0,-1,0,
 278,12,12,3,4,47,6,10,10,-1,0,
 336,23,7,3,2,48,15,0,0,-1,0,
 337,23,9,3,2,47,15,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [638]=function()
 PlayBGM(11);
talk(242,"G‡EfƒW ‡{‚TS ŒEƒR‚S‚f! „l‚b ‡{‚TG dŠA‚_„S †^Q Še q ‚aM.");
 if GetFlag(38) then
talk(54,"ƒa‚oS „|ƒmA ‰b „Y†ohLM. ‚Z‚[ „@S „l ƒ_‡I‚V[!");
 else
talk(133,"ƒa‚oS „|ƒmA ‰b „Y†ohLM. ‚Z‚[ „@S „l ƒ_‡I‚V[!");
 end
talk(112,"ƒ[ ‚V…Y r‡V ‚JƒP „@ƒb †~ƒm„S †w‡CPw„V G‰S…l ‚I‚_B‚CML¡­¡­ ƒ_ ‚oƒcG {…B ŒGu‚C ‚kƒt‚wƒv.");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [639]=function()
 WarLocationItem(2,26,49,119); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¾üÊé
 if (not GetFlag(217)) and WarCheckArea(-1,2,10,13,14) then
talk(242,"G†w ƒ{‚oY‚C ƒR‚SŠXM! ‚E ‚Tƒb ƒLS ŠGn ‰j„E‚f!! I‡H q‚h ‰lƒW‚fD ƒLG ‡m†gƒP ‚Kƒ}{ W]a‚b ƒuS ‡fn‚f!");
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(261,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(332,1);
 SetFlag(217,1);
 end
 if (not GetFlag(95)) and WarMeet(-1,112) then
 PlayBGM(11);
talk(112,"‡dŠu, ‰jƒO‚C …X‚V[! ƒv‚b ƒWƒWZ. Gd ‡{‚Tƒm„S ‰Bn^†ym.");
 ModifyForce(112,1);
 PlayWavE(11);
 DrawStrBoxCenter("ƒWƒW^ n‚Tf ^†iPM!");
 PlayBGM(17);
 SetFlag(95,1);
 end
 if WarMeet(54,103) then
 WarAction(1,54,103);
talk(54,"…fƒG „O‚b …x‚b ƒaWGŠ@M!",
 103,"v‡Sj^? [ˆs„VG[. I‡H ^‚jƒlG‚fD „Om? ‡g‚DS ‡ba…e ŠXm? ƒ[‹@ ˆNƒb ƒ[„V‚[‚V[.",
 54,"ƒaW, „y‚fu ‡g‚Da‚V[! ‚n‚b ˆoaQ „C‚S „Om.",
 103,"ˆN†i …X‚V[. ƒv‚b ƒQm‚h „quƒd v‚JS ˆLŒI ˆu, ‚[ ‚W M‚V ‡g‚Da‚C ‚km.",
 54,"ƒ[ŠQMA ‰j…[ q‹wf!");
 WarAction(6,54,103);
 if fight(54,103)==1 then
talk(54,"…Hn‚f!");
 WarAction(8,54,103);
talk(103,"…v! {…B¡­¡­ v‡SG„SM¡­¡­ ƒv‚b Gd ŒG„~M!");
 WarAction(17,103);
talk(54,"¡­¡­ƒaW, †~ƒm„S ƒP„S‡S ‚rƒ_ŠbM.");
 WarLvUp(GetWarID(54));
 else
 WarAction(4,103,54);
talk(54,"‚_†Ma‚wƒv!");
 WarAction(17,54);
 WarLvUp(GetWarID(103));
 end
 end
 if (not GetFlag(1077)) and War.Turn==60 then
 PlayBGM(11);
 if GetFlag(38) then
talk(54,"ƒn…IGM, †@‚Bf ‹z†yM! ‚B‚T, …{D‚h ‰Eb ‚Bga‚f!");
 else
talk(133,"ƒn…IGM, †@‚Bf ‹z†yM! ‚B‚T, …{D‚h ‰Eb ‚Bga‚f!");
 end
 SetFlag(93,1);
 SetFlag(1077,1);
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARLOSE then
 PlayBGM(11);
 if GetFlag(38) then
talk(54,"ƒn…IGM! G†GƒW‚b †@‚Bf ‹z†yM.");
 else
talk(133,"ƒn…IGM! G†GƒW‚b †@‚Bf ‹z†yM.");
 end
 SetFlag(93,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARWIN then
talk(242,"‡{‚TG HI ‚IaM¡­¡­! …v!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚T ƒGK‚_^ vgS ƒqƒd,*¡¡ƒa‚oS ‡F‚YPM.");
 NextEvent();
 end
 end,
 [640]=function()
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£¶£°£°S …V„kM!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [641]=function()
 JY.Smap={};
 SetSceneID(0,3);
 if GetFlag(38) then
talk(54,"ŠoM, Œa‚V „Y†oƒm„S g‚Ta‚f!");
 else
talk(133,"ŠoM, Œa‚V „Y†oƒm„S g‚Ta‚f!");
 end
 NextEvent();
 end,
 [642]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="†l";
 JY.Base["D‚wC"]=25;
 AddPerson(1,25,17,2);
 AddPerson(126,25,14,2);
 if (not GetFlag(38)) and (not GetFlag(89)) then
 AddPerson(133,19,17,2);
 end
 local x=26;
 local y=10;
 if GetFlag(58) then
 AddPerson(2,x,y,1);
 x=x-2;
 y=y-1;
 end
 if not GetFlag(89) then
 AddPerson(54,x,y,1);
 x=x-2;
 y=y-1;
 end
 AddPerson(170,x,y,1);
 x=12;
 y=18;
 if GetFlag(135) then
 AddPerson(3,x,y,0);
 x=x-2;
 y=y-1;
 end
 if not GetFlag(89) then
 AddPerson(190,x,y,0);
 x=x-2;
 y=y-1;
 AddPerson(127,x,y,0);
 end
 if GetFlag(58) then --¹ØÓğ»Ø¹é
 ModifyForce(2,1);
 ModifyForce(128,1);
 ModifyForce(155,1);
 ModifyForce(39,1);
 ModifyForce(34,1);
 ModifyForce(38,1);
 end
 --ÆæÏ®¶Ó
 if GetFlag(89) then
 ModifyForce(133,0);
 ModifyForce(54,0);
 ModifyForce(190,0);
 ModifyForce(127,0);
 ModifyForce(83,0);
 ModifyForce(65,0);
 ModifyForce(82,0);
 ModifyForce(114,0);
 ModifyForce(117,0);
 ModifyForce(188,0);
 ModifyForce(244,0); --½ªÎ¬
 ModifyForce(236,0); --Ç¼×å
 ModifyForce(235,0); --Ç¼×å
 ModifyForce(237,0); --Ç¼×å
 ModifyForce(112,0); --ĞìÊü
 end
 
 SetSceneID(47,5);
 DrawStrBoxCenter("†l ƒP‚r‰R");
 AddPerson(175,0,5,3);
 MovePerson(175,8,3);
 if GetFlag(89) then
	 if GetFlag(93) then
		talk(175,"ƒGK‚_fQƒW n„L nI m‚yG ‚a‚wƒ`. ‚n‚TfQ _G Ej ‚Z†oG[.",
 		126,"ƒGK‚_‚h „l ƒGMuA ƒLfQ „N‚P‚h Ih ‚V…y„V „{ ŠFhLM.",
 		1,"ƒ[ŠQKLM. n‹]ƒOƒv ˆGu „ND^ ‚aKLM. ƒ[ƒRD Šc‚C‚kn ‹fS ƒuhLM. v‚P^ ‡m†gf „OƒmL ‰q…f ‡m†gƒm„S ‚TS ƒ_‚V‚CZ.");
	 else
		talk(175,"‚K‚J, „Nƒg ƒsƒd^ ƒR‚SŠXKLM. ƒGK‚_^ „Y†of G‚jŠjM WLM.",
 		126,"†|†}aM. Œa‚V ƒGK‚_‡z ‚TS WŠP †M…~f ‡m†gS ˆjM.",
 		1,"ŠoM! ‚B‚T …bFS ƒe‚Pa‚f. ‡m†gƒm„S ‰bƒa †YoM!");
 	end
 else
	talk(175,"‚K‚J, e‚eƒP ‚n‚TG „Y†oƒm„S G‚lPKLM.",
 	126,"ƒLG „Y†ofƒW „N‚Saƒ`‚b ƒuG[.",
 	1,"bƒGY‚C ŠXƒmL ˆoE…I ƒu ‚aM. „Y†oƒm„S g‚Ta‚f!");
 end
 if GetFlag(58) then
talk(2,"‚CƒgG…Eˆ|„S ˆE‚KƒP „QŒTS ‰sS „UhLM.",
 3,"ƒG‡SS ƒ_‚S …bFS ƒe‚Pa‚V‚CZ! ˆEŠi, …fŠs‚b ‰q…f ƒe‚Pa†yKLM!");
 --[[MovePerson( 2,4,2,
 3,4,2);
 MovePerson( 2,2,1,
 3,2,0);
 MovePerson( 2,8,2,
 3,8,2);
 DecPerson(2);
 DecPerson(3);]]--
 end
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<½øĞĞ³öÕ÷×¼±¸£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [643]=function()
 if JY.Tid==133 then--ÅÓÍ³
talk(133,"…Xƒlƒ_ ‚n‡z †@‚BS „Q‹{LM. …bFS ƒe‚PB ‚K‡I‚V[.");
 end
 if JY.Tid==2 then--¹ØÓğ
talk(2,"ˆEŠi, …Xƒlƒ_ ‚n‡z †@‚BhLM. ƒOu ˆEdƒP ‹dG Gƒ^‚S‚Cƒ` WLM.");
 end
 if JY.Tid==3 then--ÕÅ·É
talk(3,"ƒnˆEŠi, …f‚h ƒsƒ_‡I‚V[! Šc‚C‚kn ƒOu ‹dG Gƒ^‚S†LLM.");
 end
 if JY.Tid==54 then--ÕÔÔÆ
talk(54,"‚n‚h „Q‚b ‚_†nS Gƒ^‚V‚CZ.");
 end
 if JY.Tid==190 then--Âí³¬
talk(190,"aƒ^Wu n„q‚CƒP ƒQq‚h ‹yƒd Š]KLM.");
 end
 if JY.Tid==170 then--»ÆÖÒ
talk(170,"…fD G ŠRƒb G‚h ‚K‚JS ‚nB ƒU„Qƒd Š]KLM.");
 end
 if JY.Tid==127 then--ÎºÑÓ
talk(127,"‚SƒW …bFa‚V‚CZ!");
 end
 if JY.Tid==175 then--ÂíÁ¼
talk(175,"…Xƒlƒ_ ‚n‡z †@‚BS „Q‚j‚b‚wƒ`.");
 end
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 WarIni();
 if GetFlag(89) then
 	if GetFlag(93) then
		talk(126,"‚^‚_‚h ƒv†u‚S †c„QB ‚K‡I‚V[.");
 		DefineWarMap(50,"d4ƒa ‡m†gI ‚B„e","1. ‚r…XƒP ‚p…D",40,0,213);
 SelectTerm(1,{
 0,12,21,3,0,-1,0,
 125,11,21,3,0,-1,0,
 -1,8,23,3,0,-1,0,
 -1,10,20,3,0,-1,0,
 -1,10,23,3,0,-1,0,
 -1,11,19,3,0,-1,0,
 -1,11,22,3,0,-1,0,
 -1,12,23,3,0,-1,0,
 -1,13,22,3,0,-1,0,
 -1,14,21,3,0,-1,0,
 132,1,3,4,0,-1,1,
 53,2,2,4,0,-1,1,
 189,2,4,4,0,-1,1,
 126,0,2,4,0,-1,1,
 243,0,4,4,0,-1,1,
 111,0,3,4,0,-1,1,
 });
 		DrawSMap();
 		JY.Smap={};
 		SetSceneID(0,3);
		talk(126,"‡m†gƒm„S g‚Ta‚V‚CZ!");
 		NextEvent(647); --goto 647
 		JY.Status=GAME_WMAP;
 	else
		talk(126,"^‚b †rf „Y†of ƒR…e ƒGK‚_‡z W]aƒd ƒ[‡EfƒW ‚^‚_‚h M‚V „Kƒ{a‚V‚CZ.");
 		JY.Smap={};
 		SetSceneID(0,3);
		talk(1,"ƒGK‚_ ƒa‚~ƒRGb, qƒd ‡Aƒtm. MƒR ‚C‡R†y‚C„V †M…~f ‡m†gS ŠP…E a[!",
 		126,"‡m†gƒm„S g‚Ta‚V‚CZ!");
 		NextEvent(652); --goto 652
 		JY.Status=GAME_SMAP_AUTO;
 	end
 else
	talk(126,"‚^‚_‚h ƒv†u‚S †c„QB ‚K‡I‚V[.");
 	DefineWarMap(54,"d4ƒa „Y†o ‚B„e","1. vg ‚p†U",40,0,241);
 SelectTerm(1,{
 0,29,8,3,0,-1,0,
 125,29,7,3,0,-1,0,
 -1,27,7,3,0,-1,0,
 -1,27,10,3,0,-1,0,
 -1,28,9,3,0,-1,0,
 -1,28,11,3,0,-1,0,
 -1,29,11,3,0,-1,0,
 -1,30,6,3,0,-1,0,
 -1,30,10,3,0,-1,0,
 -1,31,9,3,0,-1,0,
 });
 ModifyForce(112,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 241,1,3,4,2,60,20,0,0,-1,0,
 102,5,7,1,2,57,22,20,12,-1,0,
 111,4,16,4,5,54,16,0,0,-1,0,
 100,9,5,4,2,54,21,0,0,-1,0,
 19,19,19,4,2,56,25,0,0,-1,0,
 214,6,7,1,2,55,25,0,0,-1,0,--dos±øÖÖÉè¶¨Îª3
 215,21,17,4,1,56,9,0,0,-1,0,--ÅÓµÂ
 17,16,17,4,0,58,22,0,0,901,0,--ÏÄºîÔ¨
 256,2,3,4,0,56,3,0,0,-1,0,
 257,1,4,4,0,55,3,0,0,-1,0,
 258,11,5,4,2,53,3,0,0,-1,0,
 295,16,19,4,0,53,9,0,0,-1,0,
 296,14,18,4,0,52,9,0,0,-1,0,
 297,15,16,4,0,54,9,0,0,-1,0,
 292,20,16,4,1,54,9,0,0,-1,0,
 
 293,21,16,4,1,53,9,0,0,-1,0,
 294,22,17,4,1,42,9,0,0,-1,0,
 274,11,4,4,2,54,6,0,0,-1,0,
 336,14,6,4,0,50,15,0,0,-1,0,
 337,15,6,4,0,48,15,0,0,-1,0,
 338,16,3,4,0,48,15,0,0,-1,0,
 339,16,5,4,0,47,15,0,0,-1,0,
 275,11,6,4,0,54,6,0,0,-1,0,
 276,3,8,4,0,52,21,0,0,-1,0,
 277,8,8,3,2,52,21,0,0,-1,0,
 278,3,7,4,2,52,21,0,0,-1,0,
 298,5,14,4,0,53,9,0,0,-1,0,
 299,7,14,4,0,53,9,0,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"„Y†oƒm„S ^‚V‚CZ.");
 NextEvent();
 JY.Status=GAME_WMAP;
WarSave(6)
 end
 end
 end
 end,
 [644]=function()
 PlayBGM(11);
talk(242,"G ‰jˆlf ‚nƒP ‡S‚XG ‚@„~M. †@ŠH ˆkƒW‚b ‚o ˆYM!",
 126,"‚K‚J, G‡E „Y†oƒP q‚P ƒaq‚b vgG‚f WLM.",
 1,"‚M, ‡mƒv ƒOu ‚TƒP Nƒ}GA G‡ES la‚b ƒuGƒb ‡YƒUˆv ‡D†LƒGZ.",
 126,"„N†dƒb ƒgƒAhLM. ƒN‚eŠW „Q‚V‚CZ.",
 112,"ƒ[ ‚V…Y r‡V ‚JƒP „@ƒb †~ƒm„S †w‡CPw„V G‰S…l ‚I‚_B‚CML¡­¡­ ƒ_ ‚oƒcG {…B ŒGu‚C ‚kƒt‚wƒv.");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [645]=function()
 WarLocationItem(8,10,49,120); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¾üÊé
 if (not GetFlag(121)) and WarCheckLocation(-1,10,14) then
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £²£°£°£°S …V„kM!");
 SetFlag(121,1);
 end
 if (not GetFlag(95)) and WarMeet(-1,112) then
 PlayBGM(11);
talk(112,"‡dŠu, ‰jƒO‚C …X‚V[! ƒv‚b ƒWƒWZ. Gd ‡{‚Tƒm„S ‰Bn^†ym.");
 ModifyForce(112,1);
 PlayWavE(11);
 DrawStrBoxCenter("ƒWƒW^ n‚Tf ^†iPM!");
 PlayBGM(17);
 SetFlag(95,1);
 end
 if WarMeet(3,103) then
 WarAction(1,3,103);
talk(3,"…fƒG „O‚b …x‚b ƒaWGŠ@M!",
 103,"ƒa‚Pj^? [ˆs„VG[. I‡H ^‚jƒlG‚fD „Om? ‡g‚DS ‡ba…e ŠXm? ƒ[‹@ ˆNƒb ƒ[„V‚[‚V[.",
 3,"ƒaW, „y‚fu ‡g‚Da‚V[. ‚n‚b ˆoaQ „C‚S „Om.",
 103,"ˆN†i …X‚V[. ƒv‚b ƒQm‚h „quƒd v‚JS ˆLŒI ˆu, ‚[ ‚W M‚V ‡g‚Da‚C ‚km.",
 3,"ƒ[ŠQMA ‰j…[ q‹wf!");
 WarAction(6,3,103);
 if fight(3,103)==1 then
talk(3,"…Hn‚f!");
 WarAction(8,3,103);
talk(103,"…v! {…B¡­¡­ ƒa‚P„SM¡­¡­ ƒv‚b Gd ŒG„~M!");
 WarAction(17,103);
talk(3,"¡­¡­†~ƒm„S ƒP„S‡S ‚rƒ_M. †Oƒ@ƒ~Šp‚wƒv.");
 WarLvUp(GetWarID(3));
 else
 WarAction(4,103,3);
talk(3,"‚_†Ma‚wƒv!");
 WarAction(17,3);
 WarLvUp(GetWarID(103));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(242,"‚G‚P‚TG G‰S…l ‚IaML¡­¡­ ƒmŒF!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P‚TG vgS ƒqƒd „Y†oS ‡F‚YPM.");
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£¶£°£°S …V„kM!");
talk(126,"‚K‚J, ƒGƒo‚h Œ{n †M…~f ‡m†gS „Q‚V‚CZ!",
 1,"ŠoM, ‚~ƒ}{ ƒaq‚h M‚V †c„Qa‚f!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [646]=function()
 JY.Smap={};
 SetSceneID(0,3);
if not GetFlag(89) then
	change_mode()
end
 WarIni();
 DefineWarMap(50,"d4ƒa ‡m†gI ‚B„e","1. ‚r…XƒP ‚p…D",40,0,213);
 SelectTerm(1,{
 0,12,21,3,0,-1,0,
 125,11,21,3,0,-1,0,
 -1,8,23,3,0,-1,0,
 -1,10,20,3,0,-1,0,
 -1,10,23,3,0,-1,0,
 -1,11,19,3,0,-1,0,
 -1,11,22,3,0,-1,0,
 -1,12,23,3,0,-1,0,
 -1,13,22,3,0,-1,0,
 -1,14,21,3,0,-1,0,
 });
 DrawSMap();
talk(1,"‚B‚T, ‡m†gƒm„S g‚ToM.");
 NextEvent();
 end,
 [647]=function()
 --ÆæÏ®¶Ó
 if not GetFlag(38) then
 ModifyForce(133,1);
 end
 ModifyForce(54,1);
 ModifyForce(190,1);
 ModifyForce(127,1);
 ModifyForce(83,1);
 ModifyForce(65,1);
 ModifyForce(82,1);
 ModifyForce(114,1);
 ModifyForce(117,1);
 ModifyForce(188,1);
 if GetFlag(94) then
 ModifyForce(244,1); --½ªÎ¬
 end
 if GetFlag(114) then --dosÎª118£¬Ã²ËÆ´íÁË
 ModifyForce(236,1); --Ç¼×å
 ModifyForce(235,1); --Ç¼×å
 ModifyForce(237,1); --Ç¼×å
 end
 if GetFlag(95) then
 ModifyForce(112,1); --ĞìÊü
 end
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 213,21,2,1,2,61,16,0,0,-1,0,
 239,20,3,1,2,58,16,20,12,-1,0,
 240,22,3,1,2,58,16,0,0,-1,0,
 211,20,13,3,0,57,22,0,0,-1,0,
 238,20,12,3,0,56,13,0,0,-1,0,
 67,15,17,3,4,58,9,11,12,-1,0,
 93,16,16,3,4,57,16,12,12,-1,0,
 79,4,13,1,0,58,25,0,0,-1,0,
 217,3,15,1,0,57,9,0,0,-1,0,
 115,2,13,1,0,53,3,0,0,-1,0,
 78,21,14,3,0,57,9,0,0,-1,0,--Ğì»Î
 170,20,15,3,0,57,9,0,0,-1,0,--Å£½ğ
 102,21,8,1,0,57,22,0,0,-1,0,--ÕÅàA
 19,17,11,3,4,57,25,11,9,-1,0,--²Üºé
 215,23,8,1,0,57,9,0,0,-1,0,--ÅÓµÂ
 17,19,6,1,0,59,22,0,0,901,0,--ÏÄºîÔ¨
 16,18,7,1,0,60,9,0,0,904,0,--ÏÄºîª
 18,22,7,1,2,60,25,0,0,903,0,--²ÜÈÊ
 256,5,16,1,2,55,3,0,0,-1,0,
 257,14,16,3,4,53,3,11,11,-1,0,
 258,18,13,3,4,53,3,13,10,-1,0,
 297,19,11,3,0,54,9,0,0,-1,0,
 298,21,6,1,0,54,9,0,0,-1,0,
 292,19,14,3,0,54,9,0,0,-1,0,
 293,19,4,1,0,55,9,0,0,-1,0,
 294,22,4,1,0,54,9,0,0,-1,0,
 274,5,15,1,2,53,21,0,0,-1,0,
 275,17,15,3,4,54,6,13,11,-1,0,
 295,18,12,3,0,54,9,0,0,-1,0,
 296,20,7,1,0,54,9,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [648]=function()
 PlayBGM(11);
talk(214,"‡{‚Tƒb HI ƒOJ‚_‚C …X‚f. G ‚r…XƒP^ ‚n‚TƒP IƒWˆlS ŠTƒsQ B ‚K…X.",
 126,"‚K‚J, ƒLƒP „wq ‚r…XƒP‚b „V„V„Q ‚kƒb C‚_hLM. „N†da‚C …X‚Vƒd ‚EŠZŠW v†da‡I‚V[.");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [649]=function()
 if WarMeet(30,68) then
 WarAction(1,30,68);
talk(30,"ƒv‚b eƒOƒP nƒR e…MGM! †u^ ƒv‡z „}ƒ^†y†sŠm?",
 68,"[, eƒOƒP nƒRGŠm? ƒ[ŠQMA ‰j…[ ŠTG ƒv†y‚T. ŠoM! G ‡m…f^ C‚_B ‚K…X.",
 30,"mƒQ ƒR‚S‚K‚C! [H‚f!");
 WarAction(6,30,68);
 if fight(30,68)==1 then
talk(30,"‡m, ‡m…f„S‚T! dˆF Nƒ}G „O‚wƒv!",
 68,"aaa! G ‡m…f‚b n„L ŠR‚C ‚kƒtM. ‹]G ‚C‚C ‚k‚bM! [H‚f!");
 WarAction(6,30,68);
 WarAction(6,30,68);
 WarAction(6,30,68);
talk(30,"ŠIŠIŠI¡­¡­! G ‹Fƒb ‚S‹XŠm!");
 WarAction(9,30,68);
talk(68,"GƒsQ, z…cQ! aa, †J‚V ŠLƒbG^ …rƒ}G Šo‚T¡­¡­ ƒv‚b ƒA…eƒv…E†yM.",
 30,"ˆGnƒvƒ`†sŠm! ƒcS ‚[ƒd ^‚f!",
 68,"e…M, ‹`ƒS M‚V ƒs…x!");
 WarAction(16,68);
 WarLvUp(GetWarID(30));
 else
 WarAction(6,30,68);
 WarAction(6,30,68);
 WarAction(6,30,68);
talk(68,"ŠIŠIŠI¡­¡­! G ‹Fƒb ‚S‹XŠm!");
 WarAction(8,68,30);
talk(30,"‚_†Ma‚wƒv!");
 WarAction(17,30);
 WarLvUp(GetWarID(68));
 end
 end
 WarLocationItem(12,2,55,122); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º²è
 WarLocationItem(8,24,19,123); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º½£ÊõÖ¸ÄÏÊé
 if (not GetFlag(1078)) and GetFlag(89) and War.Turn==12 then
 PlayBGM(12);
 if not GetFlag(38) then
 WarShowArmy(132);
 end
 WarShowArmy(53);
 WarShowArmy(189);
 WarShowArmy(126);
 if GetFlag(94) then
 WarShowArmy(243);
 end
 if GetFlag(95) then
 WarShowArmy(111);
 end
talk(190,"‚SƒW ˆGƒ`^‚f! n„L ‰jˆlf ‹z‚C ‚kƒtM!",
 1,"I‡JG? ƒLƒP ƒQ‚TG‚fƒd?",
 126,"‚K‚J, ƒGK‚_^ …Xƒlƒ_ d„U ‹fƒtKLM.",
 1,"ŠoM, ‚B‚T ‡T‚J‚p.");
 PlayBGM(9);
 SetFlag(131,1);
 SetFlag(1078,1);
 end
 if WarCheckArea(-1,0,19,4,24) then
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 end,
 [650]=function()
talk(214,"‡{‚TG †~ƒm„S ‚Ia‚wƒv! ‚B‚T ƒO…m ƒ{‚oƒm„S ƒA…eƒv‚f! ƒ{‚ofƒW ƒLS ‚aoM!");
 WarAction(16,214);
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚r…XƒP^ ‚n‚TS Gˆnƒd ƒ{‚oƒm„S ƒA…eŠgM.");
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£¶£°£°S …V„kM!");
bonus_moneyexp_4()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [651]=function()
 JY.Smap={};
 SetSceneID(0);
 if GetFlag(89) and GetFlag(93) and (not GetFlag(131)) then
talk(126,"‚n‚TG ƒ{S IQ ‚C‰Jƒ`‚b ‚Z†oG[. ‚SŠSa†ym?",
 1,"‚M, †M…~f G‡ES ‰HˆyXY? ‚J‚X, …f‹Jƒb?",
 126,"[, ‚K‚J. ƒGK‚_^ ‹fƒb ‡KWLM.",
 1,"†~ƒm„S ŠU‹kM. ‚B‚T ‡m†gS ‰B‚pa‚f!");
 else
talk(126,"‚n‚TG ƒ{S IQ ‚C‰Jƒ`‚b ‚Z†oG[. ‚SŠSa†ym?",
 1,"ŠoM, ‚B‚T ‡m†gS ‰B‚pa‚f!");
 end
 NextEvent();
 end,
 [652]=function()
 PlayBGM(12);
 --ÆæÏ®¶Ó
 if not GetFlag(38) then
 ModifyForce(133,1);
 end
 ModifyForce(54,1);
 ModifyForce(190,1);
 ModifyForce(127,1);
 ModifyForce(83,1);
 ModifyForce(65,1);
 ModifyForce(82,1);
 ModifyForce(114,1);
 ModifyForce(117,1);
 ModifyForce(188,1);
 if GetFlag(94) then
 ModifyForce(244,1); --½ªÎ¬
 end
 if GetFlag(114) then --dosÎª118£¬Ã²ËÆ´íÁË
 ModifyForce(236,1); --Ç¼×å
 ModifyForce(235,1); --Ç¼×å
 ModifyForce(237,1); --Ç¼×å
 end
 if GetFlag(95) then
 ModifyForce(112,1); --ĞìÊü
 end
talk(170,"‚K‚J, ‚^ƒZ …f‚h …hƒ`^ ‚K‡I‚V[. G ŠRƒb GD n„L ‰jˆlƒhf E q „O‚MS ƒsb …wu†yKLM.",
 203,"‚U‡t ƒa‚T, …fD ‰HŠ_ ^†ym. ‚K‚J, …fŠs ŠeG ƒn ‚JS ƒoƒO†yKLM.",
 1,"‚M, †~ƒm„S Šom.",
 126,"‚K‚J, ‡d‚V z…c‡I‚V[.",
 1,"I‡H …IG[, ‚J‚X?",
 126,"‚[ ‡Lƒb ƒGƒo^ Mm {WLM. „Vf aƒv …IG ŠUˆf„CA ‚B‚TƒP kƒG^ „_hLM.",
 1,"¡­¡­",
 170,"‚T‚r, ƒ[ I‡H ˆ|Š[G‡ILY. G ‚U‡t, ‚K‚JS ‚nBƒW‚fA „V ‚W …G‚SD …XMa‚C ‚kKLM.",
 203,"‚^ƒZ …fŠs‚h ‰jˆlf ƒ_ƒsƒ_ ‚K‡I‚V[.",
 1,"‚T‚rƒP ˆ|‚_„S W‚VM. ‚[ ‡LƒP …X‚Mƒb „a†yƒmƒv G‚W‰` ‹D ‹]‚V[.",
 170,"‚K‚J! ¡­¡­„a†yKLM. ‚XS ‚i‚j†yKLM.");
change_mode()
talk(126,"‚~ƒ}{ ƒaq‚h †c„QB ‚K‡I‚V[.");
 ModifyForce(170,0);
 ModifyForce(203,0);
 WarIni();
 DefineWarMap(51,"d4ƒa ‡m†gII ‚B„e","1. n‚T ‚^‚_^ ƒ_ƒ{ ƒ{…Z DˆG",40,0,213);
 SelectTerm(1,{
 0,24,18,3,0,-1,0,
 125,24,17,3,0,-1,0,
 -1,2,17,4,0,-1,0,
 -1,21,19,3,0,-1,0,
 -1,2,19,4,0,-1,0,
 -1,22,18,3,0,-1,0,
 -1,3,18,4,0,-1,0,
 -1,23,19,3,0,-1,0,
 -1,4,19,4,0,-1,0,
 -1,25,17,3,0,-1,0,
 -1,5,18,4,0,-1,0,
 -1,26,18,3,0,-1,0,
 -1,5,19,4,0,-1,0,
 169,8,0,4,0,-1,1,
 202,8,1,4,0,-1,1,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 213,13,2,1,4,65,16,13,1,-1,0,
 212,13,1,1,4,62,9,8,0,-1,0,
 239,12,2,1,4,61,16,12,1,-1,0,
 240,14,2,1,4,61,16,14,1,-1,0,
 211,13,13,1,0,60,22,0,0,-1,0,
 238,13,14,1,0,60,13,0,0,-1,0,
 67,20,7,1,2,62,9,0,0,-1,0,
 93,27,7,1,2,61,16,0,0,-1,0,
 79,6,7,1,2,62,25,0,0,-1,0,
 217,0,4,1,0,61,9,0,0,-1,0,
 115,7,11,1,2,61,3,0,0,-1,0,
 78,21,6,4,1,62,9,0,0,-1,0,--Ğì»Î
 170,20,5,4,1,61,9,0,0,-1,0,--Å£½ğ
 102,7,7,3,1,62,22,0,0,-1,0,--ÕÅàA
 215,6,6,3,1,61,9,0,0,-1,0,--ÅÓµÂ
 17,14,15,4,0,62,22,0,0,901,0,--ÏÄºîÔ¨
 16,12,15,3,0,63,9,0,0,904,0,--ÏÄºîª
 18,26,7,1,0,63,25,0,0,903,0,--²ÜÈÊ
 19,1,4,1,0,62,25,0,0,-1,0,--²Üºé
 256,1,3,1,0,57,3,0,0,-1,0,
 257,20,12,1,2,57,3,0,0,-1,0,
 258,26,6,1,2,56,3,0,0,-1,0,
 292,11,16,3,0,59,9,0,0,-1,0,
 293,15,16,4,0,59,9,0,0,-1,0,
 274,4,13,1,0,57,21,0,0,-1,0,
 275,6,8,1,0,57,21,0,0,-1,0,
 276,9,14,1,0,56,21,0,0,-1,0,
 277,9,15,1,0,56,21,0,0,-1,0,
 278,17,14,1,0,55,21,0,0,-1,0,
 279,17,15,1,0,55,21,0,0,-1,0,
 280,20,8,1,0,55,21,0,0,-1,0,
 281,22,13,1,0,57,21,0,0,-1,0,
 282,24,8,1,0,56,21,0,0,-1,0,
 283,12,7,4,0,55,6,0,0,-1,1,
 284,13,6,1,0,55,6,0,0,-1,1,
 285,14,7,3,0,52,6,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [653]=function()
 PlayBGM(11);
talk(213,"‚G‚P ‚i‚n^ ‰c{ ŠGƒWML! ‰cƒb ‚_‚nƒP ‚UdM. ƒ[‹@ ‚|D‚b †@ŠH „o‹_X q ‚aM!",
 214,"ŠDa, G ‡m†gƒ{ƒb q‚Pf ŠG‚C ‚kƒmL ‡d‚V †nƒ{ƒm„S ƒA…eƒv‚V‚CZ.",
 213,"‚r…XƒP, ‰cG G‰S…l †kO‚h ƒsƒtƒmL ƒ[‚_^ ‚uRˆk…E oM!",
 214,"ŠDaŠ_ †~ƒm„S AƒcG ‚aKLM. ‡mƒv ‚Cƒgƒb ƒNS ƒVHƒmN „U^ n‚`LM. ‚^ƒZ¡­¡­.",
 213,"ŠoM, ‰cƒb ‰q…f †nƒ{ƒm„S ^†yM. ‚r…XƒP, ƒ[‚_^ ‡D‚h ‡fn‚f. ‡{‚TG ƒ_ „If I‚C ‚kQ a‚f.",
 214,"aa¡­¡­",
 126,"‡m†gƒ{ƒb „^L „QƒG ‡@KLM. †M…~f ƒ{ƒP ‚e†dS la‚V‚CZ!");
 WarShowTarget(true);
 SetFlag(218,1);
 PlayBGM(10);
 NextEvent();
 end,
 [654]=function()
 if GetFlag(173) and WarMeet(2,80) then
talk(2,"…ZƒQ, ‡O „VŠg‚wƒ`.",
 80,"e ƒa‚T, nI†GD ƒv‚b ‚K‚TS ŠUˆf ŒA„gŠB ‚Z†oG[. ‚l…a, b†a, ƒ[uƒd¡­¡­ v‚P. v‚P^ ‚SŠS vv ‚K‚JƒP nƒRG‚f a†ym? ƒNa‚h „quƒd ˆGnƒvML, ‰k‚r b†a‡z „G‚wƒ`¡­¡­",
 2,"ŠUˆfS nŠVMA ƒOufQ ‡g‚Da‚b ƒuG ‚S‹c†ym?",
 80,"I‡JG[¡­¡­?",
 2,"a‚P ‰jˆlfƒW ƒ_^ ‰S„[f J‹u …Yˆoaƒd „OS „U, ƒ[‚_^ ‹qn‡z GB‚h E†VPm. …GƒG‚b ‹]ƒOƒv ƒ[ƒuƒm„S‚b nIƒuD ‹Eu‚C ‚k‚bMƒd. du ƒ_Mƒs‚fƒd ˆ|G[.",
 80,"¡­¡­",
 2,"ƒ[„U ƒv‚b ƒ[ ˆ|f ˆl„Lb „QŒTS †~ƒd vvfQ ‡g‚DPm. G‚W‰` ƒ_^ ƒ[ ˆ|„S ƒ[‚_‚h ‡ba†ym.",
 80,"¡­¡­",
 2,"…ZƒQ, ¡­¡­ƒ]G ‚S‹Xa[?",
 80,"¡­¡­Šom, ‡g‚Da†ym.");
 ModifyForce(80,1);
 PlayWavE(11);
 DrawStrBoxCenter("ƒaU^ n‚Tf ^†iPM!");
talk(80,"M„V …X‚MS ‹D ^‚fŒ_ŠWQ B ‚K‚V[. ‚Cƒgƒb ‰jƒOƒd Š]‚C ‚km.",
 2,"Šom, ‰q…f ƒA…eƒv‚V[.",
 80,"†w‚oa[.");
 JY.Person[80]["µÀ¾ß1"]=0;
 JY.Person[80]["µÀ¾ß2"]=0;
 WarAction(16,80);
 SetFlag(218,0);
 WarLvUp(GetWarID(2));
 end
 if (not GetFlag(173)) and WarCheckLocation(212,0,8) then
 PlayBGM(11);
talk(213,"‚G‚P, G ƒQoƒb …A…w‚V ‹y†yM!");
 WarAction(16,213);
 --
 WarMoveTo(240,12,1);
 WarAction(0,240,1)
 WarMoveTo(241,14,1);
 WarAction(0,241,1)
 WarMoveTo(214,13,1);
 WarAction(0,214,1)
 
 
 --
 SetFlag(173,1);
 PlayBGM(10);
 end
 if (not GetFlag(1079)) and WarCheckLocation(-1,10,13) then
talk(1,"I‡JG? ƒ{…ZG ‚Au‚C ‚k‚bMƒd? ‚M, ‚SŠSaA ŠoSY¡­¡­");
 PlayBGM(12);
 WarShowArmy(169);
 WarShowArmy(202);
talk(203,"‚U‡t ƒYƒa‚T, `‚EƒsM ‡@Q ƒ{‚of …~‚SƒR„k‚wƒ`.",
 170,"ƒ[ŠQm. ‚n‚TG G‡Eƒm„S ˆGnƒv‚b ƒuG ƒsGƒGf ‚SeA …~‚SƒR q „O†yM Š]„km. ‚n‚T ‚_ƒaS ‹Q‚C ˆfo ƒuG n‡@‚wƒ`.",
 203,"n‡@‚wƒ`. ‚n‚T ‚~‚r‚b ‹Qƒtm?",
 170,"ƒ[ŠQm. ‚n‚T ‚~‚r‚h …Zƒ|B ƒ{…ZS ‚o‹JfƒW b‚b ˆFS „an„jm. ƒ{…Z„V ‚AA ƒmZ ‚JG[. ‚T‚rD ƒOu‚h ˆGu …R ƒuG[.",
 203,"Šom, ‚SƒW †h‚VM.",
 170,"†h‚VM, ‡n ƒYƒa‚T!");
 WarMoveTo(203,13,8);
 WarMoveTo(170,13,7);
 --
 SetWarMap(14,10,1,6);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=63;
 WarDelay(12);
 --
talk(203,"ŠU‹kM, ƒ{…ZG ‚A„~M!",
 170,"‚K‚J, ‚SƒW hƒ{a‚V‚CZ!",
 1,"‚U‡t! ‡n‚o! ƒ[‚_ƒRG ‚SŠS bƒG „Om?",
 170,"ƒL‚TG ƒ{fƒW ˆGnƒv‚b ƒuS ƒsƒd ƒ[ƒRG ƒEˆkƒv†[ ‡Eƒm„S ƒR‚SŠXKLM.",
 203,"ƒ{…ZS ‚A„kƒmL ‚SƒW …w‡I‚V[!",
 1,"‚U‡t, ‡n‚o. †~ƒm„S †|†}a[!",
 170,"aaaa! ˆuƒb ŠR„k‚SD ŠLƒb …C†cƒRfQ ‚C‚C‚b ‚kKLM¡­¡­!!");
 PlayBGM(11);
 WarShowArmy(283);
 WarShowArmy(284);
 WarShowArmy(285);
talk(285,"‚SƒW ƒLƒaS K‚f!");
 WarAction(4,284,170);
 WarAction(4,286,170);
 WarAction(8,285,170);
 WarAction(4,284,203);
 WarAction(4,286,203);
 WarAction(8,285,203);
 JY.Person[170]["±øÁ¦"]=limitX(JY.Person[170]["±øÁ¦"]/5,1,1000);
 JY.Person[203]["±øÁ¦"]=limitX(JY.Person[203]["±øÁ¦"]/5,1,1000);
 JY.Person[170]["Ê¿Æø"]=30;
 JY.Person[203]["Ê¿Æø"]=30;
talk(170,"…v, `‚E‚C¡­¡­ ˆfPM! ‚D‚~G¡­¡­ „O„kML!",
 1,"‚U‡t! ‡n‚o! ƒJƒKm!",
 203,"ƒJƒKKLM. ‚K‚J, ‚SƒW¡­¡­",
 --1,"ºÃ°É£¬±ğµ£ĞÄ£¡ºÃºÃÑøÉË£¡»ÆÖÒ£¡ÑÏÑÕ£¡À´ÈË£¬ÕÕ¿´ºÃ¶şÎ»ÀÏ½«¾ü£¡",
 1,"ŠoM, OF …X‚V[! ‚B‚T …b‚pB ‚SƒW ‚[ ƒYƒa‚TS ‚wa‚f!");
 WarModifyAI(169,2);
 WarModifyAI(202,2);
 PlayBGM(10);
 War.WarTarget="1. ‚r…XƒP ‚p…D";
 WarShowTarget(false);
 SetFlag(1079,1);
 end
 WarLocationItem(17,12,9,212); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÓñçô
 if JY.Death==170 then
talk(170,"…v! Gd¡­¡­ „l‚b¡­¡­¡­¡­ ‚TS Gˆnƒd ƒLS †R q ‚a†y‚wƒv¡­¡­¡­¡­");
 WarAction(18,170);
 SetFlag(1080,1);
 end
 if JY.Death==203 then
talk(203,"G FD C‹nG¡­¡­. …v!¡­¡­¡­¡­");
 WarAction(18,203);
 SetFlag(1080,1);
 end
 if JY.Status==GAME_WARWIN then
talk(214,"ƒmŒF! ‡{‚TG G‰S…l ‚IaML¡­¡­ †nƒ{ƒm„S ƒA…e‚qM!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚r…XƒP^ ƒA…eƒvƒd ‚G‚P‚TG ‡m†gS ‡F‚YPM.");
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £±£¶£°£°S …V„kM!");
 if GetFlag(1080) then
talk(126,"‚K‚J, ƒOu^ G‹HKLM!",
 1,"‚M! ‚U‡t! ‚U‡tƒb ‚SŠS „C„km? ‡n‚oƒb?",
 126,"n„L †jn „T‡ILM„V¡­¡­",
 1,"I‡JG! ‚U‡tƒb ‚SƒZ „Om? ‡iƒa ‚U‡tfQ ^†ym!");
 PlayBGM(4);
 DrawMulitStrBox("¡¡‚G‚P …I‚]ƒb ‡m†gS ‡F‚Yo ƒGLS †E‚[ƒd ‰bƒU„S ‚U‡t{ ‡n‚o Pƒm„S ˆGƒ`‰tM.*¡¡‚U‡t{ ‡n‚oƒb ƒGKS …Hn ‚eCS hƒd ƒc…~G ‚n‚|„SfM.*¡¡†jnƒS ^ˆoƒb ‚a„kM¡­¡­");
talk(1,"‚U‡t! ‡n‚o! ‡m†gS ‰Hˆyo ƒuƒb ‚Z‚[ ‚[ ‚r†vƒP ‚JG[!",
 203,"[, ‚K‚J. ƒ@a…w„tLM¡­¡­",
 170,"[, v‚P‚b¡­¡­? v‚P‚h ƒq„kKLY?",
 1,"‚M¡­¡­ ƒq„km.",
 126,"¡­¡­",
 170,"[, †~ƒm„S ŠU‹kKLM¡­¡­ ƒ[ŠQMA …f‚b „IS ‡NnD boG ‚aKLM.",
 1,"ƒ[ I‡H ˆ|G[! oNS „C†ju‚b ‚_†nƒb n„L ‹[ƒv‚C ‚kƒtƒd ‹Iƒm„SD ‚[ ‚r†vfQ ƒG‚_…E a[! ƒG‡SS ƒ_‚V[! G„Vo @†j C‹nGƒb ‚_q„B‚C ‚km!",
 203,"‚K‚J¡­¡­ G ŠRƒb ‚~‚r‚h ‰l ‚K‚VL †~ƒm„S ‡N‚rWLM. …X‚C‡fY‚C ‚K‚JS ‚nB „@S MPƒmL …X‚MG ‹^hLM.",
 170,"‚S‹cKLY¡­¡­ ‚K‚J. ƒw@„S‡S¡­¡­ ‚BŠw ‚a‚b¡­¡­ ‚|ƒwƒ{‚_‚b¡­¡­",
 1,"¡­¡­! ‚U‡t! ‡n‚o! ƒ_ ƒcmu^ ƒRu[? ‚_†Ca‚V[!!");
 DrawMulitStrBox("¡¡‚G‚P‚Tƒb …Xƒlƒ_ ‡m†gS ‰HˆyPƒmƒv ƒ[ tuf‚b ƒn Šs`G ‚i„gM¡­¡­*¡¡ƒ[…eƒv ‚n‚b n„L †Uˆoa‚C ‚kƒtM. v‚P‡z ‚r…XƒP‚b o ‚@‚M] ƒe‚Pa†B ‡{{ƒP …X‚C‡f †@‚BS ‹S‚jƒd „O„kM.");
 else
talk(126,"‚K‚J, ƒOu^ G‹HKLM!",
 1,"‚M! ‚U‡t! ‚U‡tƒb ‚SŠS „C„km? ‡n‚oƒb?",
 126,"C‹n‚b I†EƒOƒv n„L †jn „T‡ILM¡­¡­",
 1,"I‡JG! ‚U‡tƒb ‚SƒZ „Om? ‡iƒa ‚U‡tfQ ^†ym!");
 PlayBGM(4);
 DrawMulitStrBox("¡¡‚G‚P …I‚]ƒb ‡m†gS ‡F‚Yo ƒGLS †E‚[ƒd ‰bƒU„S ‚U‡t{ ‡n‚o Pƒm„S ˆGƒ`‰tM.*¡¡‚U‡t{ ‡n‚oƒb ƒGKS …Hn ‚eCS h„kM¡­¡­");
talk(1,"‚U‡t! ‡n‚o! ‡m†gS ‰Hˆyo ƒuƒb ‚Z‚[ ‚[ ‚r†vƒP ‚JG[!",
 203,"[, ‚K‚J. ƒ@a…w„tLM¡­¡­",
 170,"[, v‚P‚b¡­¡­? v‚P‚h ƒq„kKLY?",
 1,"‚M¡­¡­ ƒq„km.",
 126,"¡­¡­",
 170,"[, †~ƒm„S ŠU‹kKLM¡­¡­ ƒ[ŠQMA …f‚b boG ‚aKLM.",
 1,"ƒ[ I‡H ˆ|G[! oNS „C†ju‚b ‚_†nƒb n„L ‹[ƒv‚C ‚kƒtƒd ‹Iƒm„SD ‚[ ‚r†vfQ ƒG‚_…E a[! ƒG‡SS ƒ_‚V[! G„Vo @†j C‹nGƒb ‚_q„B‚C ‚km!",
 203,"‚K‚J¡­¡­ G ŠRƒb ‚~‚r‚h ‰l ‚K‚VL †~ƒm„S ‡N‚rWLM. …X‚C‡fY‚C ‚K‚JS ‚nB „@S MPƒmL …X‚MG ‹^hLM.");
 DrawMulitStrBox("¡¡‚G‚P‚Tƒb …Xƒlƒ_ ‡m†gS ‰HˆyPƒmƒv ƒ[ tuf‚b ƒn Šs`G ‚i„gM¡­¡­*¡¡ƒ[…eƒv ‚n‚b n„L †Uˆoa‚C ‚kƒtM. v‚P‡z ‚r…XƒP‚b o ‚@‚M] ƒe‚Pa†B ‡{{ƒP …X‚C‡f †@‚BS ‹S‚jƒd „O„kM.");
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [655]=function()
 if not GetFlag(1080) then
 ModifyForce(170,1);
 ModifyForce(203,1);
 end
 SetSceneID(-1,0);
 JY.Base["ÕÂ½ÚÃû"]="d4ƒa¡¡‡{‚n ˆz…C †@‚B";
 DrawStrBoxCenter("d4ƒa¡¡‡{‚n ˆz…C †@‚B");
 LoadPic(27,1);
 DrawMulitStrBox("¡¡‡m†gS ŒOƒb v‚P‚b ‚nƒP …X‚C‡f ƒsƒ^j †nƒ{f ‚B ‚~ƒ}S ‚Zn G‡EfƒW ‡{{ …x†]S „}ƒ^ƒG„S PM.*¡¡o„K ‚G‚P‚b ‡m†gfƒW ‚~ƒ}{ ƒaq‚h M‚V †c„QPƒd, ‡{{ ‚nƒP …X‚C‡f †@‚BG …Xƒlƒ_ ‚VJ„C„kM.");
 LoadPic(27,2);
 SetSceneID(0,11);
talk(213,"†nƒ{fƒW †@‚BoM! ‚B‚T †nƒ{ƒm„S †L†@a‚f! †@ŠH ‚n‚h ‚G‚P ‚i‚nfQ „|ƒG‚C ‚k†yM!");
 NextEvent();
 end,
 [656]=function()
 JY.Smap={};
 JY.Base["ÏÖÔÚµØ"]="‡m†g";
 JY.Base["D‚wC"]=26;
 AddPerson(1,7,8,3);
 AddPerson(126,13,9,3);
 if not GetFlag(38) then
 AddPerson(133,9,11,3);
 end
 if GetFlag(58) then
 AddPerson(2,19,8,1);
 end
 AddPerson(54,21,9,1);
 AddPerson(127,23,10,1);
 if GetFlag(135) then
 AddPerson(3,7,14,0);
 end
 AddPerson(190,9,15,0);
 AddPerson(175,37,23,2);
 SetSceneID(84,8);
 DrawStrBoxCenter("‡m†g ‚U†X");
 MovePerson(175,8,2);
talk(175,"‚K‚JŠ_ nŠnLM. v‚P^ †nƒ{f ‚B ‚~ƒ}S ‚ZƒtƒmL ƒOu ‚T{ †@‚BS ‰r…I JFj ‡KWLM.",
 1,"‚M, …Xƒlƒ_ ƒ[„U^ ŠX‚wƒ`.");
 MovePerson(127,2,3);
 MovePerson(127,2,1);
 MovePerson(127,2,2);
talk(127,"ƒ[ŠQMA „l `‚EX ƒu ‚aG ‰jˆl„V ƒGM„u ŠFhLM!");
 MovePerson(190,3,3);
 MovePerson(190,2,0);
 MovePerson(190,2,2);
talk(190,"ƒ[ŠQKLM! o ‡evƒP ‚n‡nS „C†j„t‚VM.");
 MovePerson(54,3,3);
 MovePerson(54,3,1);
 MovePerson(54,2,2);
talk(54,"oNS „C†juƒd ‚B‚dS ‹[‹g‚VM!");
 if GetFlag(135) then
 MovePerson(3,4,3);
 MovePerson(3,2,0);
 MovePerson(3,3,2);
talk(3,"ƒnˆEŠi, [ˆs ƒo‡c ƒB‚S †[ ƒOu ‹dG Gƒ^‚S‚Cƒ` WLM.");
 end
 if GetFlag(58) then
 MovePerson(2,4,3);
 MovePerson(2,2,1);
 MovePerson(2,3,2);
talk(2,"G[ƒP ˆ|‚_„ShLM, ˆEŠi. ƒOu ƒo ‚r†vƒP ‹dG Gƒ^‚S‚Cƒ` WLM.");
 end
 if not GetFlag(38) then
 MovePerson(133,1,3);
 MovePerson(133,0,2);
talk(133,"‚K‚J, ‚SƒW …bFS ‚Xa‡I‚V[!");
 end
 MovePerson(126,1,3);
 MovePerson(126,0,2);
talk(126,"‚K‚J, ‚Cƒg ƒa‚~ƒRƒP ‚rƒG^ ‰EƒmL …b‚pX …Y†qƒP ƒG‚}hLM.",
 1,"‚M¡­¡­ ‚C‚qƒSS ‰BnƒsA ƒd‚qƒP …B…{G„km. ‚UwƒP ‚qS ƒwFa†B ‚qƒo‚h ‚waƒd…x eƒO, ƒa‚P ‚[ nƒO‡z ‡Y‹Qƒb G†G †~ƒm„S [ˆs ƒo‡cG UŠjm. Gd …Xƒlƒ_ G ‚qƒo‚h ‹[‰M „U^ ŠXm. ‚SŠq‚ru †fƒQS Gƒ^‚b‚wƒ`.",
 126,"‚K‚J, n„L …X‚MS ‹^nƒW‚b ‚o ŒjLM. oNS „C†juƒ`A …X‚C‡f ‚_‚r^ …gƒtKLM.",
 1,"‚M¡­¡­ ŠoM! ‚B ƒa‚~ƒb …bF ƒe‚P‚h ‚VJa‚f.");
 DrawMulitStrBox("ƒmŒF!");
talk(175,"‚K‚J, vƒg„V „l „@ƒ_‚V‚S v‚P‚h „Qƒd oNS „C†ju‡I‚V[.");
 MovePerson(175,10,3);
 DecPerson(175);
talk(127,"Gd ‡f ƒR‚S†[ …f‚h ‰l ‚K‚VL ‡N‚rWLM. ‹Iƒm„SD ŠU Gˆn‚S ‚K‡I‚V[.");
 MovePerson(127,12,3);
 DecPerson(127);
talk(190,"v‚P‚h ƒq‚S ‰Bn^ƒN n„q‚CƒP ƒQq‚h ‹yƒd „V†eƒ{ƒP ƒQqD ‹y†yKLM. ƒ[ ƒcS n„q‚C ~‚Bf ƒU„Qƒd…x aL ‚XS ƒ_ƒ` ‚K‡I‚V[!");
 MovePerson(190,12,3);
 DecPerson(190);
talk(54,"…f‚b ‚K‚J{ †I‚qS ‰HŠ_B ŠXƒd ‹Iƒm„SD ~ŒTS „GGX ƒuhLM. G …X‚C‡f ‰jˆlfƒW …G‚MS I‹{ˆ`ƒd …m‡Wf ƒW†yKLM.");
 MovePerson(54,12,3);
 DecPerson(54);
 if GetFlag(135) then
talk(3,"ƒnˆEŠi, †@FƒLj „U^ ŠXKLM. ‚Sj‚C ˆuG „nu‚b‚TZ!",
 1,"I‡H …IGŠm? ‚[ƒ`‡S QŠm?",
 3,"ƒ[ I‡H ˆ|Š[G‡ILY! Gw ƒG‡SG „|ŠPƒWhLM. …f‚h …bF‚V‰a ‚K‡I‚V[!");
 MovePerson(3,14,3);
 DecPerson(3);
 end
 if GetFlag(58) then
talk(2,"ˆEŠi, ƒOu †fƒQG Gƒ^‚S‚Cƒ` WLM.",
 1,"ƒ[ŠQ‚wƒv! „x„LŠW ƒ[„U „p^ ˆE‚KfƒW OB ‹K‹HM‚b ˆ|S ƒR„kS „U‚b G†w ƒoCf ‚a‚b „{ „aƒtM¡­¡­ ‚Cƒg Gu ‰HŠ_aL †~ƒm„S Šo‚wƒv!",
 2,"ˆEŠi, ƒ[ I‡H ˆ|Š[G‡ILY. ƒOu‚b ‰HŠ_ …GƒG‚h †_ƒoa‚C ‚kƒtKLY? G eƒO‚b †@ŠH †_ƒo‚h …f„qu‚C ‚kKLM. ˆEŠi, …f‚b ‰q…f ƒe‚Pa†yKLM.");
 MovePerson(2,14,3);
 DecPerson(2);
 end
 if not GetFlag(38) then
talk(133,"‚K‚J, …fD ƒe‚Pa…e ^†yKLM.",
 1,"„N„w, ƒ[‚_^ ‚a„kMA [ƒXƒb ‚a„kS ƒuG[. ƒdŠOm.",
 133,"‡i„Q ‚kKLM, {‡Lo ˆ|Š[hLM. …f ‡Oo ‚K‚JƒP ‚CƒO‚CƒbS h‚S „l‚aG ƒGŒgLM. ƒ[†{ …f‚b ‰q…f …bFS ƒe‚Pa†yKLM.");
 MovePerson(133,16,3);
 DecPerson(133);
 end
talk(1,"†~ƒm„S Šo‚wƒv. ƒvD ƒe‚P‚h¡­¡­?");
 if GetFlag(1080) then
 AddPerson(170,20,16,2);
 AddPerson(203,22,15,2);
 else
 AddPerson(170,36,24,2);
 AddPerson(203,38,23,2);
 MovePerson( 170,8,2,
 203,8,2);
 end
talk(170,"‚K‚J, G o ‰jˆlf ˆG„~KLM.",
 203,"…fŠs^ ˆAdˆe †q„ia†yKLM.",
 1,"‚U‡t! ‡n‚o!");
 if GetFlag(1080) then
 DecPerson(170);
 DecPerson(203);
talk(126,"¡­¡­? ‚K‚J, I‡H …IG‡ILY?",
 1,"‡m! ¡­¡­G‹@ „A…yGA ‚U‡t{ ‡n‚o ‚[ ƒYƒa‚TG n„L Pf „O‚b ƒu„V „Gm¡­¡­",
 126,"¡­¡­. ‚K‚J, ƒR‚S^ ƒe‚Pa‚V‚CZ.");
 else
 MovePerson( 170,12,3,
 203,12,3);
 DecPerson(170);
 DecPerson(203);
 end
 --ÏÔÊ¾ÈÎÎñÄ¿±ê:<½øĞĞ³öÕ÷×¼±¸£®>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [657]=function()
 if JY.Tid==126 then--Öî¸ğÁÁ
 if talkYesNo( 126,"ƒe‚P‚b „CŠVKLY?") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [658]=function()

talk(126,"‚~ƒ}{ ƒaq‚h †c„QB ‚K‡I‚V[.");
 WarIni();
 DefineWarMap(55,"d4ƒa †nI ‚B„e","1. v‚P ‚p†U",40,0,212);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm(1,{
 0,19,23,2,0,-1,0,
 125,20,23,2,0,-1,0,
 -1,14,23,2,0,-1,0,
 -1,16,23,2,0,-1,0,
 -1,17,22,2,0,-1,0,
 -1,18,22,2,0,-1,0,
 -1,18,23,2,0,-1,0,
 -1,19,21,2,0,-1,0,
 -1,20,22,2,0,-1,0,
 -1,21,21,2,0,-1,0,
 -1,21,22,2,0,-1,0,
 -1,22,22,2,0,-1,0,
 -1,22,23,2,0,-1,0,
 -1,23,23,2,0,-1,0,
 -1,25,23,2,0,-1,0,
 });
 DrawSMap();
talk(126,"rs ‚qGD"..JY.Person[1]["·ÜÕ½"]..", †nƒ{ƒm„S g‚ToM!");
 JY.Smap={};
 SetSceneID(0,3);

SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 212,18,0,1,2,65,9,0,0,-1,0,
 211,17,1,1,0,62,22,0,0,-1,0,
 238,17,0,1,2,61,16,0,0,-1,0,
 67,13,6,3,1,62,9,0,0,-1,0,
 93,17,7,1,0,61,16,0,0,-1,0,
 79,18,7,1,0,62,25,0,0,218,0,
 217,22,6,4,1,61,9,0,0,-1,0,
 115,31,15,3,1,61,3,0,0,-1,0,
 19,17,5,1,2,61,25,0,0,-1,0,--²Üºé
 214,18,5,1,2,61,20,0,0,-1,0,
 78,9,6,3,1,62,9,0,0,-1,0,--Ğì»Î
 170,10,7,3,1,61,9,0,0,-1,0,--Å£½ğ
 102,26,6,4,1,62,22,0,0,-1,0,--ÕÅàA
 215,25,7,4,1,61,9,0,0,-1,0,--ÅÓµÂ
 17,13,4,4,4,62,22,14,17,901,0,--ÏÄºîÔ¨
 16,21,4,3,4,64,9,24,17,904,0,--ÏÄºîª
 18,18,2,1,1,63,25,0,0,903,0,--²ÜÈÊ
 278,14,8,1,0,55,6,0,0,-1,0,
 256,5,15,4,1,58,3,0,0,-1,0,
 257,29,15,3,1,57,3,0,0,-1,0,
 258,7,15,4,1,58,3,0,0,-1,0,
 
 259,16,8,1,0,57,3,0,0,-1,0,
 260,19,8,1,0,57,3,0,0,-1,0,
 279,21,8,1,0,55,6,0,0,-1,0,
 274,13,3,1,0,55,21,0,0,-1,0,
 275,12,4,1,0,55,21,0,0,-1,0,
 276,22,4,1,0,55,21,0,0,-1,0,
 277,21,3,1,0,55,21,0,0,-1,0,
 213,18,0,1,2,65,16,0,0,-1,1,
 292,7,6,3,1,58,9,0,0,-1,0,
 293,8,7,3,1,58,9,0,0,-1,0,
 294,9,8,3,1,57,9,0,0,-1,0,
 295,10,9,3,1,57,9,0,0,-1,0,
 296,28,6,4,1,58,9,0,0,-1,0,
 297,27,7,4,1,58,9,0,0,-1,0,
 298,26,8,4,1,57,9,0,0,-1,0,
 299,25,9,4,1,57,9,0,0,-1,0,
 });


 JY.Status=GAME_WMAP;
 NextEvent();
WarSave(6)
 end,
 [659]=function()

 PlayBGM(11);
talk(213,"HŠs ‚i‚n^ ‰cƒP ~‰S‚h ƒl‚maML. G ƒv‚f‚b n„qŠiG ƒAƒ`‚KƒN ƒuƒm„S I‡JƒsM m‚ea†B †u‚wfQD „|†r q ‚aM.",
 126,"v‚P^ ƒ{ ‹wƒm„S ƒv‡z †@‚Bf ƒvŒUKLM. „o†_ŠW „Q‚V‚CZ!");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [660]=function()
 if WarMeet(44,212) then
 WarAction(1,44,212);
talk(44,"[‚b ƒaq^ v†gGŠm? G‰}‚f, Œi‡pG! ‚SƒW ƒv‡z „}ƒ^…x!",
 212,"ŒL, ‰xˆ| …X‚f. G v†gƒb „V„Vo …x^ nLM!");
 WarAction(6,44,212);
 if fight(44,212)==1 then
talk(212,"dˆF C‚_^ „C‚b‚T. ƒ_ ˆpS …Hn ƒsn‚f!");
 WarAction(4,212,44);
talk(44,"[, Gƒuƒb¡­¡­",
 212,"…Hn‚f, GŒN!");
 WarAction(9,212,44);
talk(44,"n…jn…jPM!",
 212,"G ˆQ„Z! ‰XP‚wƒv!",
 44,"G‚W‰` ƒ_ „y‹~M.");
 WarAction(8,44,212);
talk(212,"nGƒd! n‡P‚wƒv¡­¡­");
 WarAction(18,212);
talk(44,"‹xŠjM! GŒNS ‹[ƒaƒ_‚f!");
 WarLvUp(GetWarID(44));
 else
talk(212,"dˆF C‚_^ „C‚b‚T. ƒ_ ˆpS …Hn ƒsn‚f!");
 WarAction(4,212,44);
talk(44,"[, Gƒuƒb¡­¡­",
 212,"…Hn‚f, GŒN!");
 WarAction(8,212,44);
talk(44,"nGƒd! n‡P‚wƒv¡­¡­");
 WarAction(17,44);
 WarLvUp(GetWarID(212));
 end
 end
 if WarMeet(30,239) then
 WarAction(1,30,239);
talk(30,"vƒT ˆEd^ „L‰n …bFP‚wƒv. ŠoM, ƒ_^ ƒq‚S ‚K…X! v‚y, v†dB‚f!",
 239,"n¡­¡­ GŠQQ ˆY GC ‰jƒO‚C ‚kS q ‚a‚wƒv.");
 WarAction(6,30,239);
 if fight(30,239)==1 then
talk(30,"ƒv‚b eƒOƒP nƒR e…MGM. v‚y, H‚b …Gƒb ƒc…~GM!",
 239,"‰jƒO…xA ‰jƒO‚C!");
 WarAction(8,30,239);
talk(239,"…v!");
 WarAction(18,239);
talk(30,"v‚y, H‚h ƒq‚b …x‚b G e…MGM!");
 WarLvUp(GetWarID(30));
 else
 WarAction(4,239,30);
talk(30,"…v!");
 WarAction(17,30);
 WarLvUp(GetWarID(239));
 end
 end
 WarLocationItem(2,9,49,124); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¾üÊé
 WarLocationItem(2,26,60,125); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£º°ÔÍõÖ®½£
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
talk(213,"G‹@! I‡JS aƒ`‚b QŠm? ‰cƒb ‚_‚nƒP ‚UdM!",
 1,"H‚h ƒq‚S ‚qƒo‚h ‚wa†yM! …GS ƒe‚Pƒv B‚f!",
 213,"„aƒd „OM, ‡mƒv ‰cƒb n„L …Gƒd Š]‚C ‚kM! ‡g‚Da†yM! ƒ[…eA „C‚C ‚k†sŠm?",
 1,"G…xD vvƒP nƒRG‚d ˆ|j^? ƒWt‰gƒd o„dƒ~Šp‚wƒv¡­¡­");
 PlayBGM(11);
 WarShowArmy(213);
talk(213,"[, ‚r…XƒP! ‚SƒZ „O„k†sŠm? Gu ‡z ‚SƒW …fŒNƒRS ƒq‚S‚f!",
 214,"k, ƒU‚f‚V‚b ‚_„S ƒq‚S ƒsG†yKLM¡­¡­",
 213,"„i? ‚r, ‚r…XƒP! †w‡R†sŠm? ƒLƒb …f‹JGM! ‚SŠS ‰cfQ ‹FS „}†u†sŠm?",
 1,"Gw ŒyŠm? I‡H …IG ‰r‚Sg ƒuGŠm?",
 214,"G ˆf‚q ƒuG vv ‚K‚JƒP oƒw` ‚Xƒ{S „lŠp…TM! ƒ_^ ƒ[‡LS ‚_ƒNB H‚h ‰ra†yM!",
 213,"G‰}! ‚r…XƒP! ƒ[„V‚[‚S‚f! ƒmn…v!!");
 WarAction(8,214,213);
 --WarAction(18,213);
 DrawStrBoxCenter("‚r…XƒP^ d ‡Yƒm„S v‚P‚h ƒq„kM!");
talk(214,"‚G‚P! v‚P‚b …G„kƒmƒv ‚n‚b †Uˆoa‚C ‚k‚bM. ƒ_^ vv ‚K‚JƒP ƒ]S ‰{†yM! ƒ{‚ofƒW ƒGMu†yM!");
 WarAction(16,214);
 PlayBGM(3);
talk(1,"‚_…r ‚SŠS ˆY …IG[?",
 126,"‚Z‚j†yKLM. ˆ|X q „O‚b ƒuƒb ƒn ‰jˆlG n„L ‹[ƒv‚C ‚kƒtM‚b ƒuŠFhLM. ƒ{‚oƒm„S „Qƒd …w‚V‚CZ!");
bonus_moneyexp_8()
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 end,
 [661]=function()
 WarIni2();
 DefineWarMap(56,"d4ƒa †nII ‚B„e","1. ‚r…XƒP ‚p†U",40,0,213);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm2(1,{
 0,14,19,2,0,-1,0,
 125,15,19,2,0,-1,0,
 -1,6,20,2,0,-1,0,
 -1,22,20,2,0,-1,0,
 -1,5,19,2,0,-1,0,
 -1,23,20,2,0,-1,0,
 -1,13,18,2,0,-1,0,
 -1,4,18,2,0,-1,0,
 -1,24,19,2,0,-1,0,
 -1,16,18,2,0,-1,0,
 -1,4,20,2,0,-1,0,
 -1,25,18,2,0,-1,0,
 -1,17,18,2,0,-1,0,
 -1,3,18,2,0,-1,0,
 -1,25,20,2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 213,14,5,1,2,67,16,0,0,-1,0,
 239,10,6,1,0,64,16,0,0,-1,0,
 240,17,6,1,0,64,16,0,0,-1,0,
 67,15,5,1,0,64,9,0,0,-1,0,
 93,25,13,1,2,63,16,0,0,-1,0,
 79,13,11,1,2,64,25,0,0,218,0,
 217,13,13,1,0,63,9,0,0,-1,0,
 115,14,13,1,0,63,3,0,0,-1,0,
 18,14,7,1,0,65,25,0,0,903,0,--²ÜÈÊ
 19,13,7,1,0,63,25,0,0,-1,0,--²Üºé
 214,15,7,1,0,63,20,0,0,-1,0,--²ÜĞİ
 78,5,6,3,1,64,9,0,0,-1,0,--Ğì»Î
 170,6,7,3,1,63,9,0,0,-1,0,--Å£½ğ
 102,26,12,1,1,64,22,0,0,-1,0,--ÕÅàA
 215,25,11,1,1,63,9,0,0,-1,0,--ÅÓµÂ
 17,14,9,1,1,65,22,0,0,901,0,--ÏÄºîÔ¨
 16,15,9,1,1,66,9,0,0,904,0,--ÏÄºîª
 256,12,10,1,0,60,3,0,0,-1,0,
 257,14,11,1,2,59,3,0,0,-1,0,
 292,6,10,3,0,62,9,0,0,-1,0,
 293,4,11,3,0,62,9,0,0,-1,0,
 294,4,12,3,2,60,9,0,0,-1,0,
 295,25,14,3,2,60,9,0,0,-1,0,
 296,19,7,4,0,59,9,0,0,-1,0,
 297,23,7,3,0,60,9,0,0,-1,0,
 274,12,13,1,2,58,6,0,0,-1,0,
 275,14,12,1,0,58,6,0,0,-1,0,
 276,18,9,4,0,58,21,0,0,-1,0,
 277,5,11,3,2,58,6,0,0,-1,0,
 278,5,13,3,0,58,6,0,0,-1,0,
 279,13,10,1,2,58,21,0,0,-1,0,
 280,14,10,1,0,58,21,0,0,-1,0,
 281,22,11,4,0,58,6,0,0,-1,0,
 282,7,8,3,2,58,6,0,0,-1,0,
 
 8,14,2,1,2,77,9,0,0,-1,1,
 
 258,18,5,4,0,60,3,0,0,-1,0,
 259,18,6,4,0,59,3,0,0,-1,0,
 298,9,5,3,0,60,9,0,0,-1,0,
 299,9,6,3,0,59,9,0,0,-1,0,
 });
 War.Turn=1;
 NextEvent();
 end,
 [662]=function()
 PlayBGM(11);
talk(214,"aa! G„S‰l ‚n‚b †Uˆoa‚C ‚k‚bM! ‡{‚TGb, ‡zƒW …G‚S‚f!");
 WarShowTarget(true);
 PlayWavE(51);
 WarFireWater(6,11,1); --WarFireWater(6,15,1);
 WarFireWater(6,12,1);
 WarFireWater(6,13,1);
 WarFireWater(6,14,1);
 WarFireWater(6,15,1);
 WarFireWater(7,15,1);
 WarFireWater(7,16,1);
 WarFireWater(7,17,1);
 WarFireWater(7,18,1);
 WarFireWater(8,18,1);
 WarFireWater(9,18,1);
 WarFireWater(10,18,1);
 WarFireWater(11,18,1);
 WarFireWater(12,18,1);
 WarFireWater(18,18,1);
 WarFireWater(19,18,1);
 WarFireWater(20,18,1);
 WarFireWater(21,18,1);
 WarFireWater(22,18,1);
 WarFireWater(22,17,1);
 WarFireWater(22,16,1);
 WarFireWater(22,15,1);
 WarEnemyWeak(2,1);
 WarEnemyWeak(1,1);
talk(1,"[, GQ I‡H …IGŠm? d ƒ{f …dS ‚C‚jML!",
 126,"ƒLG †cqƒP gS ˆj ‡KWLM. †l‚BŠW GƒG†Eƒv „y‚fu …_‰Za†yM‚b ƒuG‚CZ.",
 1,"I‡JG? d ‚TG …df …@‚b ƒuv„y kCo ƒU‚fƒd?",
 126,"ƒ[ŠQKLM. G ƒ{D ‚C‡Q q ‚aƒmL ƒA…eƒv‚C ‚kƒmA¡­¡­ n! ƒ{…ZG!");
 --
 SetWarMap(23,24,1,10);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=56;
 WarDelay(12);
 --
talk(1,"‹U‹Va‚wƒv! ‚SŠS …D„Sv„y ‚a†M ˆ|j^!",
 214,"aaa! …@ …G‚b „KG ‹oM! vv ‚K‚J, M‚M `f M‚V ‚Z‚V†yKLM!",
 126,"‚K‚J, ŒCƒd ƒv^‚b q‹wf ‚aKLM. ‚r…XƒP‚b ‡L‚X ˆGnƒS †rS …XƒxB ‚[„kS ƒuhLM.",
 1,"ŠoM, ‚B ƒa‚~ƒb ‚r…XƒP‚h ‚r„S‹Qn‚f!");
 PlayBGM(9);
 NextEvent();
WarSave(6)
 end,
 [663]=function()
 WarLocationItem(11,0,49,126); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¾üÊé
 WarLocationItem(10,11,49,127); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÔ®¾üÊé
 WarLocationItem(13,23,52,128); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÓÂÆøÊé
 WarLocationItem(5,6,52,129); --»ñµÃµÀ¾ß:»ñµÃµÀ¾ß£ºÓÂÆøÊé
 if (not GetFlag(1081)) and War.Turn==8 then
 PlayBGM(11);
talk(126,"‚K‚J, ‚n…UWLM! ‚SƒW ƒW‚[‚j‡I‚V[!");
 PlayWavE(51);
 WarFireWater(0,11,1);
 PlayBGM(9);
 SetFlag(1081,1)
 end
 if (not GetFlag(1082)) and War.Turn==16 then
 PlayBGM(11);
talk(126,"‚K‚J, ‚SƒW ƒW‚[‚j‡I‚V[!");
 PlayWavE(51);
 WarFireWater(23,13,1);
 PlayBGM(9);
 SetFlag(1082,1)
 end
 if (not GetFlag(1083)) and War.Turn==20 then
 PlayBGM(11);
talk(126,"‚K‚J, ƒW‚[‚j‡I‚V[!");
 PlayWavE(51);
 WarFireWater(11,10,1);
 WarFireWater(6,5,1);
 PlayBGM(9);
 SetFlag(1083,1)
 end
 if (not GetFlag(1084)) and War.Turn==24 then
 PlayBGM(11);
talk(126,"‚K‚J, ‚SƒW ƒW‚[‚j‡I‚V[! ƒ{…WG IH‹T ‚Cƒ@G‚f ‚n…UWLM!");
 PlayWavE(51);
 WarFireWater(5,9,1);
 WarFireWater(6,9,1);
 WarFireWater(7,9,1);
 WarFireWater(8,9,1);
 WarFireWater(9,9,1);
 WarFireWater(13,10,1);
 WarFireWater(14,10,1);
 WarFireWater(15,10,1);
 WarFireWater(19,7,1);
 WarFireWater(20,7,1);
 WarFireWater(21,7,1);
 WarFireWater(22,7,1);
 WarFireWater(23,7,1);
 PlayBGM(9);
 SetFlag(1084,1)
 end
 if (not GetFlag(1085)) and War.Turn==28 then
 PlayBGM(11);
talk(214,"„U^ „C„kM. ‚G‚P, ŠU ^‚f. †nƒ{{ ‰HŠ_ IHˆk‚f.",
 126,"‚K‚J, ƒ{G IH†LLM.",
 1,"I‡JG! ƒm…v!");
 DrawMulitStrBox("¡¡†nƒ{G …d…@ IHƒFM.*¡¡‚G‚P‚Tƒb ‚r…XƒPƒP @„Tf ‚@ƒ` ‚B†UPM.");
 SetFlag(1085,1)
 JY.Status=GAME_START;
 NextEvent(999); --goto ???
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
talk(214,"‹U‹Va‚wƒv¡­¡­ ƒ_ „@S MBD ‡{‚TS ‡fS q ‚aML¡­¡­",
 1,"‚r…XƒP, …GS ‚E[ƒv B‚f!",
 214,"GM!");
 PlayBGM(11);
 DrawMulitStrBox("¡¡‚r…XƒP^ vƒg „l „qNM.");
talk(1,"„i? I‡H muŠm?",
 214,"G mu‚b¡­¡­ nL, ‡mƒv †@ŠH¡­¡­");
 DrawMulitStrBox("¡¡‚r…XƒP‚b n„L „qDƒ` oM. ƒ_^ „O‚b o¡­¡­");
 PlayBGM(10);
 WarShowArmy(8);
talk(9,"‚r…XƒP, n„L ‹[ƒv‚C ‚kƒtM!",
 214,"[, vv ‚K‚J!",
 1,"I‡JG! vv‚fL! ‚SŠSab vv^¡­¡­",
 9,"‚G‚P, ‚n‚h ‚S‚C…yŠWD ‡w„B…TM„V bƒGY‚CM. ƒv‚b bƒGƒW H‚h ƒGM„~M. ‡Sƒb dˆF Šoƒt‚wƒv. ‡mƒv ƒ_QY‚C G‚jŠjƒmL¡­¡­ aaa!");
 WarMoveTo(9,10,0);
 WarAction(16,9);
 PlayBGM(3);
talk(214,"vv ‚K‚J, ‡d‚V ƒGMƒ` ‚K‡I‚V[!",
 1,"‚SŠS ˆY …IG[? E…X vv^ …G‚C ‚kƒt†M ˆ|G[?",
 126,"…fD ‚Z‚j†yKLM. ‡mƒv¡­¡­",
 1,"‡mƒv I‡JG[?",
 126,"‚Cƒg ƒsƒd „O‚b ƒuG ‹dƒb nL†y‚CZ?",
 1,"‚M¡­¡­ vv^ ‚oƒm„S ƒR‚S‰tM aL ^ ‹b‚VM. ‚oS †j‰X‚b ƒu ˆ|ƒd‚b ˆGu „ND^ ‚am.",
 126,"k, ƒ[†{ ƒR‚S^‚V‚CZ.");
bonus_moneyexp_8()
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 end,
 [664]=function()
 WarIni2();
 DefineWarMap(57,"d4ƒa †nIII ‚B„e","1. vv ‚p†U",50,0,8);
 -- id,x,y,d,ai,?,·ü±ø --1,2,3,4 ÏÂ ÉÏ ×ó ÓÒ
 SelectTerm2(1,{
 0,24,21,2,0,-1,0,
 125,25,21,2,0,-1,0,
 -1,13,23,2,0,-1,0,
 -1,8,23,2,0,-1,0,
 -1,23,22,2,0,-1,0,
 -1,9,21,2,0,-1,0,
 -1,14,23,2,0,-1,0,
 -1,25,23,2,0,-1,0,
 -1,10,22,2,0,-1,0,
 -1,22,21,2,0,-1,0,
 -1,26,22,2,0,-1,0,
 -1,12,22,2,0,-1,0,
 -1,11,22,2,0,-1,0,
 -1,12,23,2,0,-1,0,
 -1,15,22,2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
 8,19,1,1,2,77,9,0,0,-1,0,
 213,19,3,1,2,70,16,0,0,-1,0,
 239,18,3,1,2,65,16,0,0,-1,0,
 240,20,3,1,2,65,16,0,0,-1,0,
 68,30,8,1,0,64,16,0,0,-1,0,
 76,35,14,1,0,64,16,0,0,-1,0,
 67,31,9,1,2,65,25,0,0,-1,0,
 93,34,16,1,2,64,16,0,0,-1,0,
 79,10,9,4,2,65,25,0,0,218,0,
 217,4,8,1,0,63,9,0,0,-1,0,
 115,23,16,3,0,63,3,0,0,-1,0,
 386,19,2,1,3,72,25,8,0,-1,0,--µäÎ¤S
 61,18,1,1,0,67,16,0,0,-1,0,--¹ù¼Î
 77,20,1,1,0,65,16,0,0,-1,0,--³ÌêÅ
 18,20,12,1,0,66,25,0,0,903,0,--²ÜÈÊ
 19,21,12,1,0,65,25,0,0,-1,0,--²Üºé
 241,17,5,3,0,65,20,0,0,-1,0,--²ÜÕæ
 214,21,5,4,0,63,20,0,0,-1,0,--²ÜĞİ
 78,6,6,1,0,65,9,0,0,-1,0,--Ğì»Î
 215,3,9,1,0,64,9,0,0,-1,0,--ÅÓµÂ
 121,3,7,1,0,64,9,0,0,-1,0,--ÎÄÆ¸
 101,5,7,1,0,63,9,0,0,-1,0,--ÕÅĞå
 170,4,6,1,0,63,9,0,0,-1,0,--Å£½ğ
 17,18,6,4,0,66,22,0,0,901,0,--ÏÄºîÔ¨
 16,19,5,1,0,67,9,0,0,904,0,--ÏÄºîª
 209,28,5,4,0,63,21,0,0,-1,0,--ÏÄºîÉĞ
 210,29,6,4,0,64,20,0,0,902,0,--ÏÄºîµÂ
 102,20,6,3,0,65,22,0,0,-1,0,--ÕÅàA
 103,30,5,4,0,63,6,0,0,-1,0,--¸ßÀÀ
 83,16,2,1,0,64,21,0,0,-1,0,--Âú³è
 100,22,2,1,0,64,21,0,0,-1,0,--ÁõêÊ
 172,31,8,1,0,63,21,0,0,-1,0,--²Ü´¿
 129,3,17,1,2,63,3,0,0,-1,0,--º«ºÆ
 62,27,6,1,2,64,25,0,0,-1,0,--ÓÚ½û
 274,2,17,1,2,61,21,0,0,-1,0,
 275,11,11,1,2,61,21,0,0,-1,0,
 276,18,17,3,2,60,21,0,0,-1,0,
 277,32,9,3,2,60,21,0,0,-1,0,
 278,35,16,1,2,59,21,0,0,-1,0,
 256,6,16,3,0,61,3,0,0,-1,0,
 257,8,11,4,2,61,3,0,0,-1,0,
 258,23,15,3,0,60,3,0,0,-1,0,
 259,32,5,4,0,60,3,0,0,-1,0,
 260,30,15,4,0,59,3,0,0,-1,0,
 292,6,17,3,0,62,9,0,0,-1,0,
 293,16,11,4,0,62,9,0,0,-1,0,
 294,16,10,4,0,62,9,0,0,-1,0,
 295,35,17,1,2,61,9,0,0,-1,0,
 296,34,17,1,2,61,9,0,0,-1,0,
 297,32,6,4,0,61,9,0,0,-1,0,
 261,17,15,3,2,61,3,0,0,-1,0,
 262,17,16,3,2,60,3,0,0,-1,0,
 298,3,8,3,0,61,9,0,0,-1,0,
 });
 War.Turn=1;
 NextEvent();
 end,
 [665]=function()
 PlayBGM(11);
talk(1,"vv, ƒ]‹wG†y‚C! Gd „p^ ‹[ƒS „y‹~^ nLŠm!",
 9,"v‚PD ‚r…XƒPD ‚Z‚[ …{ƒtƒmL H‚b „l„m ‚Z‚j†y‚C. ŠoM, ƒ_^ E‚XB ‚K…X.",
 9,"‚n¡¤‡{¡¤[ ƒo ƒv‚f‚b e„T^ †w‡^aƒd „@G ‡J‚POB ƒW„S‚h †TdoM. G C‚|^ G‚S‚CA ƒv‚b ‚sa‚h „w…IX q ‚aM. ab …Gƒb „faƒG„S PM.",
 1,"…Gƒb „fPMƒd?",
 9,"ƒ[ŠQM. ƒ_^ …GƒmA |}ƒP ˆRˆEG Z‚Cu‚f ƒsƒtM. G‚S @†ZS Q„~ƒmL, ‰q…f eƒO‚h …GGƒd ƒ[ ‚uRS ‚l[f ‹X„|„} [‡z ‡{G M„eQ aƒ` o ƒuGM.");
talk(126,"I‡JG! ƒ[ŠQMA [‡z ‡{ƒP MvG vvƒP SG„k†M ˆ|j^.",
 9,"ƒ[ŠQM. ƒ[„U ƒv‚b G†w ‚a‚b ˆuGL ‚l[D …X‚M ‹^ƒd ‡{{ ‰j…[ q „O„k‚C. ƒ[u b‹HM„V ‡{{ [^ ‚l†_X „{ƒb Œ{„gM. ‚G‚P, „p^ ‚l[‚h „o‹_X „{ƒb †~ƒm„S ƒ]‹wG„kM.",
 1,"¡­¡­",
 9,"‡{{ [^ ‰HŠ_ CaA ‚S†s ‹JG ˆoaˆe …gƒb ‹JD ƒQƒG^ „^Q „_jM. ƒ[„U ƒvƒWA ‡Y‡@Q GƒGƒd ‚n^ ‚sa‚h „w…IoM. ƒ[ƒuG ƒ_ „T„[G„kM„V¡­¡­ ƒ_^ ŒG„~‚wƒv.",
 9,"QM^ ƒv‚f‚h v‚P ‚i‚nfQ ŠEŒI ƒuD ƒn ŠUˆfG„kM. G ƒv‚f^ ƒ[…xƒP ‡Yf G‰S…l ‹]G IHƒFƒmL. G nŠKM‡S ƒ{…X…f G ŒBG „C„k‚wƒv.",
 1,"¡­¡­",
 9,"‡mƒv G‚_„S ‹[ƒv‚C‚b ‚k‚bM! H‚h „_ƒd ‚n‡z ‡{S WŠP ‚sa‚h „w…Ia†yM. ‚G‚P, ƒ_ ‹dS ^„S‡f‚C …X‚f.",
 1,"vv, ƒ[‹@ `‚EG ƒoCf ‚B‚dS „VƒR„kƒd „V†eƒ{S D„df ƒE„]ƒj ƒQrG[! ‚l…a, b†a, ƒQm, ƒQƒH¡­¡­ ‚Z‚[ d ‰{…{„V JŒI …xƒRG[. vv, ƒ[‚_ ‡Oo ƒ[ƒR{ M‚j‚C ‚km.",
 9,"I‡JG! ƒv‚h ‚l…a ‚i‚n‡z „GMƒd! ƒd‡Co ƒu¡­¡­!",
 1,"vv, ‚sa^ G†w ƒ[‚_‚h „o‹_a‚C ‚km! ƒv‚f‚h ‚S‚CŠpŠWƒd RƒgS B‡RƒmL …G‚C ‚kƒdƒW‚b ‚saf ‚rbX †rG ‚am.");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
WarSave(6)
 end,
 [666]=function()
 if WarMeet(3,68) then
 WarAction(1,3,68);
talk(3,"[‚b ƒaq^ ‡m…fŠ@M. bƒG ƒa‚P^ ŠXM. H‚h …`‚ffQ ƒsƒ_ ‚K…X. ‡m…f, t‚^‚h ^u…x.",
 68,"ŒL! ƒa‚P, ‡zƒW …G‚S‚f!");
 WarAction(6,3,68);
 if fight(3,68)==1 then
talk(68,"[, {…B ‹MƒT^ „O‚wƒv!",
 3,"Œ{‚fP‚T, HfQD ‹MƒT^ „O‚wƒv! GM!");
 WarAction(10,3,68);
talk(68,"t‚^‚h ^uƒG ‚SŠq‚T. ƒa‚P, G ‹F„S ‹[ƒ_ ‚K…X.",
 3,"[H‚f!",
 68,"…Hn‚f!");
 WarAction(9,68,3);
talk(3,"ƒ[ FDŠb†sŠm!");
 WarAction(4,3,68);
talk(3,"†~ƒm„S n‡P‚wƒv.",
 68,"ƒv‚h ƒq‚S‚f.",
 3,"…G‚S‚f!");
 WarAction(8,3,68);
talk(68,"…v¡­¡­!");
 WarAction(18,68);
talk(3,"¡­¡­„Nƒgƒb †~ƒm„S n…jn…jPM.");
 WarLvUp(GetWarID(3));
 else
talk(68,"[, {…B ‹MƒT^ „O‚wƒv!",
 3,"Œ{‚fP‚T, HfQD ‹MƒT^ „O‚wƒv! GM!");
 WarAction(10,3,68);
talk(68,"t‚^‚h ^uƒG ‚SŠq‚T. ƒa‚P, G ‹F„S ‹[ƒ_ ‚K…X.",
 3,"[H‚f!",
 68,"…Hn‚f!");
 WarAction(8,68,3);
talk(3,"…v¡­¡­!");
 WarAction(17,3);
 WarLvUp(GetWarID(68));
 end
 end

 if JY.Person[80]["¾ıÖ÷"]~=1 and GetFlag(218) and WarMeet(2,80) then
 WarAction(1,2,80);
talk(2,"ƒaU¡­¡­",
 80,"eƒO¡­¡­",
 2,"ƒaU, ƒ[‚_‡z ƒv‚b ‹[ƒ_ ‰j…[ q‹wf ‚a‚wƒ`¡­¡­",
 80,"nI ˆ|D …X‚V[. …x, IƒG‚h …w‚V[!",
 2,"¡­¡­");
 WarAction(6,2,80);
 if fight(2,80)==1 then
talk(80,"eƒO! ‹laL „O‚C …X‚V[! d‚_„S ‰jƒO‚V[! ƒ[…e‚C ‚kƒmA ƒ_ ‡Yf …Gm! [‚V[!");
 WarAction(4,80,2);
talk(80,"aa¡­¡­",
 2,"ƒaU, …Gƒb ƒc…~GM!");
 WarAction(8,2,80);
talk(80,"ƒmŒF!! ƒn…IGM!");
 WarAction(19,80);
talk(2,"ƒaU¡­¡­",
 80,"ƒ[u …jR …X‚V[. ‚Cƒg ƒ_ …X‚Mƒb †~ƒm„S †K‡Sa[. ƒ_^ ‡tƒ{o ‚K‚TS ‚nB¡­¡­ …G‚b ƒuGL. …m‚P‚b …xƒG‚h „an‚K‚b G‚h ‚nB …G‚b ˆF, ƒ[ƒuG ƒ_ ‹dG„km¡­¡­ Gd…E Gƒ^„k‚wƒ`.",
 2,"‡mƒv ƒv‚b¡­¡­ G‹@ †@{‚h „VƒRƒd ˆ|ƒt‚wƒ`¡­¡­",
 80,"eƒO, ƒ[„U a‚PfƒW ƒ[‚_^ ‚a„kMA [ƒXY‚C [‚CD ˆfPm. ƒNƒo¡­¡­ ‡AG ƒFm. ƒd, ƒdŠOm!",
 2,"ƒaU¡­¡­ ‚SŠSab? ‚SŠS G‰S…l †~zo ‹[S ŠGn…E o†M ˆ|j^! ƒmŒF!!");
 WarAction(18,80);
 WarLvUp(GetWarID(2));
 else
talk(2,"eƒO! ‹laL „O‚C …X‚V[! d‚_„S ‰jƒO‚V[! ƒ[…e‚C ‚kƒmA ƒ_ ‡Yf …Gm! [‚V[!");
 WarAction(4,80,2);
talk(2,"aa¡­¡­");
 WarAction(17,2);
 WarLvUp(GetWarID(80));
 end
 end
 if WarMeet(54,116) then
 WarAction(1,54,116);
talk(54,"G‚B! ƒv‡z ‚r`†@†MS a…x!",
 116,"ƒ[ŠQMA ƒvD ‚S‹W q ‚aM. v‡S, ‹R‹S‚f!");
 WarAction(6,54,116);
 if fight(54,116)==1 then
talk(116,"…v!");
 WarAction(8,54,116);
talk(116,"n, ‚nD ˆoa‚b‚wƒv¡­¡­");
 WarAction(18,116);
 WarLvUp(GetWarID(54));
 else
 WarAction(4,116,54);
talk(54,"…v!");
 WarAction(17,54);
 WarLvUp(GetWarID(116));
 end
 end
 if WarMeet(190,218) then
 WarAction(1,190,218);
talk(190,"…vg! ‚nqfƒW QQŠW ¡±ƒNƒo¡±‚h ƒFM! Gd bƒGƒW ƒ[ ƒQoS ‹y†yM! …Hn‚f!",
 218,"‰u!");
 WarAction(6,190,218);
 if fight(190,218)==1 then
talk(190,"GM!");
 WarAction(4,190,218);
talk(218,"ƒm…v!",
 190,"‰u!");
 WarAction(8,190,218);
talk(218,"…v!");
 WarAction(18,218);
talk(190,"…M! ‚nqƒP oS vƒgGƒv…X ‰s„kM!");
 WarLvUp(GetWarID(190));
 else
 WarAction(4,218,190);
talk(190,"ƒm…v!");
 WarAction(17,190);
 WarLvUp(GetWarID(218));
 end
 end
 if (not GetFlag(1086)) and War.Turn==4 then
 PlayBGM(11);
talk(9,"ƒv‚b …bFa†ym.");
 PlayWavE(51);
 WarFireWater(0,16,1);
 WarFireWater(0,17,1);
 WarFireWater(0,18,1);
 DrawStrBoxCenter("ƒ{‚of …dG ŠgM!");
talk(9,"ŠU‹kM, aaa¡­¡­ ‚G‚P, ƒ_^ †wu ƒ{‚of ‡YS ‰l ‚[„kS „{ƒb Œ{„g†y‚C. n, …dGb, ŠUD …@‚b‚wƒv! …d„S ‚G‚P‚TS c‚S ‹^n‚f!");
 WarModifyAI(103,4,35,18);
 WarModifyAI(62,4,31,10);
 PlayBGM(10);
 SetFlag(1086,1);
 end
 if (not GetFlag(1087)) and War.Turn==6 then
 PlayWavE(51);
 WarFireWater(1,18,1);
 WarFireWater(2,18,1);
 WarModifyAI(210,4,33,9);
 WarModifyAI(209,4,30,9);
 SetFlag(1087,1);
 end
 if (not GetFlag(1088)) and War.Turn==8 then
 PlayBGM(11);
 PlayWavE(51);
 WarFireWater(2,17,1);
 WarFireWater(3,17,1);
 WarFireWater(4,17,1);
 WarFireWater(3,18,1);
 WarFireWater(3,19,1);
 WarFireWater(2,20,1);
 WarFireWater(3,20,1);
 WarFireWater(4,20,1);
 WarFireWater(4,18,1);
talk(126,"[, ‚K‚J. ‹I†rf!",
 1,"I‡H …IG[¡­¡­",
 9,"aaa! …@‚f, …@‚f! @‚Jƒm„S HŠs‚h c‚S ‹^†yM!");
 WarModifyAI(129,1);
 WarModifyAI(274,1);
 WarModifyAI(256,1);
 WarModifyAI(292,1);
 WarModifyAI(261,4,20,16);
 WarModifyAI(276,4,21,16);
 PlayBGM(10);
 SetFlag(1088,1);
 end
 if (not GetFlag(1089)) and War.Turn==10 then
 PlayWavE(51);
 WarFireWater(6,18,1);
 WarFireWater(8,18,1);
 SetFlag(1089,1);
 end
 if (not GetFlag(1090)) and War.Turn==12 then
 PlayWavE(51);
 WarFireWater(10,18,1);
 WarFireWater(12,18,1);
 SetFlag(1090,1);
 end
 if (not GetFlag(1091)) and War.Turn==14 then
 PlayWavE(51);
 WarFireWater(14,18,1);
 WarFireWater(16,18,1);
 SetFlag(1091,1);
 end
 if (not GetFlag(1092)) and War.Turn==16 then
 PlayWavE(51);
 WarFireWater(18,18,1);
 WarFireWater(19,17,1);
 WarFireWater(20,18,1);
 SetFlag(1092,1);
 end
 if (not GetFlag(1093)) and War.Turn==18 then
 PlayBGM(11);
 PlayWavE(51);
 WarFireWater(18,15,1);
 WarFireWater(18,16,1);
 WarFireWater(18,17,1);
 WarFireWater(19,16,1);
 WarFireWater(20,15,1);
 WarFireWater(20,16,1);
 WarFireWater(20,17,1);
 WarFireWater(19,15,1);
 WarFireWater(22,18,1);
 WarFireWater(24,18,1);
talk(1,"…v! …dG „l „OM!",
 214,"ƒ{‚o …Iƒb Ce‚aM! HŠs‚h „_ƒmA ‚sa‚b v‚JƒP ƒuG ˆYM! ‚G‚P! ‚J‚X! v‚JS ‚nB …A…w‚V HŠs‚h ‚aŒi†yM!",
 9,"ƒU„S ƒ[ŠQm, ‚r…XƒP. GƒuG …X‚C‡f †@‚BGL bƒGƒW‚b G„}…E„V a[.");
 WarModifyAI(261,1);
 WarModifyAI(276,1);
 WarModifyAI(115,1);
 WarModifyAI(258,1);
 WarModifyAI(18,1);
 WarModifyAI(19,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(275,1);
 WarModifyAI(79,1);
 WarModifyAI(257,1);
 PlayBGM(10);
 SetFlag(1093,1);
 end
 if (not GetFlag(1094)) and War.Turn==20 then
 PlayWavE(51);
 WarFireWater(19,14,1);
 WarFireWater(19,12,1);
 WarFireWater(25,17,1);
 WarFireWater(25,15,1);
 SetFlag(1094,1);
 end
 if (not GetFlag(1095)) and War.Turn==22 then
 PlayWavE(51);
 WarFireWater(17,12,1);
 WarFireWater(15,12,1);
 WarFireWater(25,13,1);
 WarFireWater(25,11,1);
 SetFlag(1095,1);
 end
 if (not GetFlag(1096)) and War.Turn==24 then
 PlayWavE(51);
 WarFireWater(13,12,1);
 WarFireWater(11,12,1);
 WarFireWater(25,9,1);
 WarFireWater(26,10,1);
 SetFlag(1096,1);
 end
 if (not GetFlag(1097)) and War.Turn==26 then
 PlayWavE(51);
 WarFireWater(9,12,1);
 WarFireWater(7,12,1);
 WarFireWater(25,7,1);
 WarFireWater(28,10,1);
 SetFlag(1097,1);
 end
 if (not GetFlag(1098)) and War.Turn==28 then
 PlayBGM(11);
 PlayWavE(51);
 WarFireWater(6,10,1);
 WarFireWater(6,11,1);
 WarFireWater(7,11,1);
 WarFireWater(8,10,1);
 WarFireWater(8,11,1);
 WarFireWater(7,9,1);
 WarFireWater(28,9,1);
 WarFireWater(28,8,1);
 WarFireWater(29,7,1);
 WarFireWater(30,7,1);
talk(9,"‚G‚P, ƒ[ Œ^ƒS ‡m†gƒP FƒQfƒW ƒHS …hƒO†B ~†]S baŠB „UƒP ˆ|S ƒG„Fa‚b^? ƒ[„U ‹[f ^ƒW ~†]ƒb ŠeŠFG‚f P‚C. ƒU„S H‡z ƒv¡­¡­ ƒ_ ‚oƒcƒb †J‚V ŒGu‚C ‚kƒtM.",
 9,"„p^ ƒv‚h …f„qu‚C ‚kƒd o†c‚h R„l‚fA ƒv‚b M‡M †rS ‚@„kS‚CD ‚Z‡MM. nLA †J‚V¡­¡­ ‡m, Gd ‡z G‹@ ˆ|ƒb ‹z„k‚wƒv.",
 9,"‚G‚P, ‚SŠS ‹kˆe ƒOu ŠeG M„e‚b ƒuƒb ‚s‚XGM. ‚CƒgG ƒ[ ‡S‚XS ^‚h „UGL …Xƒl ŠU ŠXM!");
 PlayBGM(10);
 WarModifyAI(78,1);
 WarModifyAI(215,1);
 WarModifyAI(121,1);
 WarModifyAI(101,1);
 WarModifyAI(170,1);
 WarModifyAI(217,1);
 SetFlag(1098,1);
 end
 if (not GetFlag(1099)) and War.Turn==34 then
 PlayWavE(51);
 WarFireWater(25,6,1);
 WarFireWater(25,5,1);
 WarFireWater(30,6,1);
 WarFireWater(30,5,1);
 WarModifyAI(16,3,0);
 WarModifyAI(17,3,0);
 WarModifyAI(102,3,0);
 WarModifyAI(386,3,0);
 WarModifyAI(61,3,0);
 WarModifyAI(77,3,0);
 SetFlag(1099,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(11);
talk(9,"…M! ‚G, ‚G‚P¡­¡­! „p^ ƒ_ ‹dS¡­¡­ ‚Z‚[ ‚NJ…e„]„~‚wƒv¡­¡­! ƒm…v!!");
 PlayBGM(7);
 DrawMulitStrBox("¡¡‚G‚P^ vv‚h „_ƒd ‚TS Gˆn‚S †nƒ{S ‡F‚YPM.");
talk(1,"B„jM, …Xƒlƒ_ vv‚h „_„kM!",
 126,"‚K‚J, ‚_†nS Gƒ^ŠVKLM.");
 if GetFlag(58) then
talk(2,"ƒnˆEŠi, ƒ@a…w„tLM. [ˆs mƒQS Gƒ^ŠVƒmL †~ƒm„S ‡@‚C ‚kƒb …IG„kKLM.",
 3,"n, †~ƒm„S [†G ƒGM„~‚wƒv.");
 end
talk(54,"ƒ{CS ‚Z‚V…e ^‚V‚CZ!",
 1,"ŠoM! †K^‚h ‰EG …[u†B „Y†oƒm„S ‰Bn…yM!");
bonus_moneyexp_8()
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [667]=function()
 SetSceneID(0,12);
 DrawMulitStrBox("¡¡vvƒP ‹dƒb ƒ~…eƒFM.*¡¡G‡EfƒW vvƒP †Uˆo{ ‰HŠ_¡­¡­*¡¡‚n¡¤‡{¡¤[ |}‚V‚_‚b ‡fS ƒ_„~M.");
 NextEvent();
if JY.Base["ÓÎÏ·Ä£Ê½"]==0 then
RemindSave()
JY.Status=GAME_START;
end
 end,
 [668]=function()
if JY.Base["ÓÎÏ·Ä£Ê½"]==0 then
NextEvent(1)
else
JY.Status=GAME_START;
end
 end,
 [669]=function()
 JY.Status=GAME_START;
 end,
 [670]=function()
 JY.Status=GAME_START;
 end,
 [671]=function()
 JY.Status=GAME_START;
 end,
 [672]=function()
 JY.Status=GAME_START;
 end,
 [673]=function()
 JY.Status=GAME_START;
 end,
 [674]=function()
 JY.Status=GAME_START;
 end,
 [675]=function()
 JY.Status=GAME_START;
 end,
 [676]=function()
 JY.Status=GAME_START;
 end,
 [677]=function()
 JY.Status=GAME_START;
 end,
 [678]=function()
 JY.Status=GAME_START;
 end,
 [679]=function()
 JY.Status=GAME_START;
 end,
 [680]=function()
 JY.Status=GAME_START;
 end,
 [681]=function()
 JY.Status=GAME_START;
 end,
 [682]=function()
 JY.Status=GAME_START;
 end,
 [683]=function()
 JY.Status=GAME_START;
 end,
 [684]=function()
 JY.Status=GAME_START;
 end,
 [685]=function()
 JY.Status=GAME_START;
 end,
 [686]=function()
 JY.Status=GAME_START;
 end,
 [687]=function()
 JY.Status=GAME_START;
 end,
 [688]=function()
 JY.Status=GAME_START;
 end,
 [689]=function()
 JY.Status=GAME_START;
 end,
 [690]=function()
 JY.Status=GAME_START;
 end,
 [691]=function()
 JY.Status=GAME_START;
 end,
 [692]=function()
 JY.Status=GAME_START;
 end,
 [693]=function()
 JY.Status=GAME_START;
 end,
 [694]=function()
 JY.Status=GAME_START;
 end,
 [695]=function()
 JY.Status=GAME_START;
 end,
 [696]=function()
 JY.Status=GAME_START;
 end,
 [697]=function()
 JY.Status=GAME_START;
 end,
 [698]=function()
 JY.Status=GAME_START;
 end,
 [699]=function()
 JY.Status=GAME_START;
 end,
 [700]=function()
 JY.Status=GAME_SMAP_AUTO
if WarDrawStrBoxYesNo("…~„}g e…Z mO ‚B„e*b†a^ ƒaU¡¤…Cƒ{¡¤‡p‡qS Gˆnƒd mOƒP ‚G‚P‚h ƒGKB ‚nƒG…I_*ƒQ‚TG ƒi „UY‚C „q‹} q „OS ƒuj^?",M_White,true) then
 PlayBGM(12);
talk(2,"‚_‚AS ‹s‹t‚f!");
WarIni();
 DefineWarMap(33,"…~„}g e…Z mO ‚B„e","1. b†a ‚p…D*2. ƒQ‚T D†W",30,0,4); --ko leader2=4 -> pid 5 (Lu Bu), the unit actually on the field (SelectEnemy entries are pid-1) is the enemy leader
 SelectTerm(1,{
 0,23,3,1,0,-1,0,
 1,22,3,1,0,-1,0,
 2,24,3,1,0,-1,0,
 -1,28,22,3,0,-1,0,
 -1,29,21,3,0,-1,0,
 -1,30,20,3,0,-1,0,
 -1,31,19,3,0,-1,0,
 });
 SelectEnemy({
 4,6,5,1,2,6,7,0,0,-1,0,
 79,3,7,1,0,3,23,0,0,-1,0,
 80,6,8,1,0,3,7,0,0,-1,0,
 74,10,8,1,0,3,4,0,0,-1,0,
 73,10,11,1,1,2,1,0,0,-1,0,
 274,8,8,1,0,1,4,0,0,-1,0,
 275,5,11,1,1,1,4,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 else
 JY.Status=GAME_START;--ko fix: "no" used to re-run this event forever
 end
 end,
 [701]=function()
 PlayBGM(11);
talk(5,"‚G‚P ‚i‚n^ mOf †]„^uƒd „OML. …Cƒ{, ƒaU, ŒQyn „qƒ`‚f!",
 80,"k!",
 2,"ƒnˆEŠi, b†a^ „L‰n ŠXKLM. ƒQ‚TG ƒi „UY‚C „qŒw…E WLM.",
 1,"ŠoM, ‚Z‚[ ‚_‚AS ‹s…cƒd ŠGƒW‚f!");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [702]=function()
 if JY.Status==GAME_WARWIN then
talk(5,"ƒm‚M, ‚G‚P^ G‰S…l „qDML. ƒA…e‚qM!");
 PlayBGM(7);
 DrawMulitStrBox("‚G‚P‚TG b†a‚TS ƒAu‡RM.");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("‚Uƒg £³£°£°S ƒYƒC!");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [703]=function()
 JY.Status=GAME_START;
 end,
 [704]=function()
 JY.Status=GAME_START;
 end,
 [705]=function()
 JY.Status=GAME_START;
 end,
 [706]=function()
 JY.Status=GAME_START;
 end,
 [707]=function()
 JY.Status=GAME_START;
 end,
 [708]=function()
 JY.Status=GAME_START;
 end,
 [709]=function()
 JY.Status=GAME_START;
 end,
 [710]=function()
 JY.Status=GAME_START;
 end,
 [711]=function()
 JY.Status=GAME_START;
 end,
 [712]=function()
 JY.Status=GAME_START;
 end,
 [713]=function()
 JY.Status=GAME_START;
 end,
 [714]=function()
 JY.Status=GAME_START;
 end,
 [715]=function()
 JY.Status=GAME_START;
 end,
 [716]=function()
 JY.Status=GAME_START;
 end,
 [717]=function()
 JY.Status=GAME_START;
 end,
 [718]=function()
 JY.Status=GAME_START;
 end,
 [719]=function()
 JY.Status=GAME_START;
 end,
 [720]=function()
 JY.Status=GAME_START;
 end,
 [721]=function()
 JY.Status=GAME_START;
 end,
 [722]=function()
 JY.Status=GAME_START;
 end,
 [723]=function()
 JY.Status=GAME_START;
 end,
 [724]=function()
 JY.Status=GAME_START;
 end,
 [725]=function()
 JY.Status=GAME_START;
 end,
 [726]=function()
 JY.Status=GAME_START;
 end,
 [727]=function()
 JY.Status=GAME_START;
 end,
 [728]=function()
 JY.Status=GAME_START;
 end,
 [729]=function()
 JY.Status=GAME_START;
 end,
 [730]=function()
 JY.Status=GAME_START;
 end,
 [731]=function()
 JY.Status=GAME_START;
 end,
 [732]=function()
 JY.Status=GAME_START;
 end,
 [733]=function()
 JY.Status=GAME_START;
 end,
 [734]=function()
 JY.Status=GAME_START;
 end,
 [735]=function()
 JY.Status=GAME_START;
 end,
 [736]=function()
 JY.Status=GAME_START;
 end,
 [737]=function()
 JY.Status=GAME_START;
 end,
 [738]=function()
 JY.Status=GAME_START;
 end,
 [739]=function()
 JY.Status=GAME_START;
 end,
 [740]=function()
 JY.Status=GAME_START;
 end,
 [741]=function()
 JY.Status=GAME_START;
 end,
 [742]=function()
 JY.Status=GAME_START;
 end,
 [743]=function()
 JY.Status=GAME_START;
 end,
 [744]=function()
 JY.Status=GAME_START;
 end,
 [745]=function()
 JY.Status=GAME_START;
 end,
 [746]=function()
 JY.Status=GAME_START;
 end,
 [747]=function()
 JY.Status=GAME_START;
 end,
 [748]=function()
 JY.Status=GAME_START;
 end,
 [749]=function()
 JY.Status=GAME_START;
 end,
 [750]=function()
 JY.Status=GAME_START;
 end,
 [751]=function()
 JY.Status=GAME_START;
 end,
 [752]=function()
 JY.Status=GAME_START;
 end,
 [753]=function()
 JY.Status=GAME_START;
 end,
 [754]=function()
 JY.Status=GAME_START;
 end,
 [755]=function()
 JY.Status=GAME_START;
 end,
 [756]=function()
 JY.Status=GAME_START;
 end,
 [757]=function()
 JY.Status=GAME_START;
 end,
 [758]=function()
 JY.Status=GAME_START;
 end,
 [759]=function()
 JY.Status=GAME_START;
 end,
 [760]=function()
 JY.Status=GAME_START;
 end,
 [761]=function()
 JY.Status=GAME_START;
 end,
 [762]=function()
 JY.Status=GAME_START;
 end,
 [763]=function()
 JY.Status=GAME_START;
 end,
 [764]=function()
 JY.Status=GAME_START;
 end,
 [765]=function()
 JY.Status=GAME_START;
 end,
 [766]=function()
 JY.Status=GAME_START;
 end,
 [767]=function()
 JY.Status=GAME_START;
 end,
 [768]=function()
 JY.Status=GAME_START;
 end,
 [769]=function()
 JY.Status=GAME_START;
 end,
 [770]=function()
 JY.Status=GAME_START;
 end,
 [771]=function()
 JY.Status=GAME_START;
 end,
 [772]=function()
 JY.Status=GAME_START;
 end,
 [773]=function()
 JY.Status=GAME_START;
 end,
 [774]=function()
 JY.Status=GAME_START;
 end,
 [775]=function()
 JY.Status=GAME_START;
 end,
 [776]=function()
 JY.Status=GAME_START;
 end,
 [777]=function()
 JY.Status=GAME_START;
 end,
 [778]=function()
 JY.Status=GAME_START;
 end,
 [779]=function()
 JY.Status=GAME_START;
 end,
 [780]=function()
 JY.Status=GAME_START;
 end,
 [781]=function()
 JY.Status=GAME_START;
 end,
 [782]=function()
 JY.Status=GAME_START;
 end,
 [783]=function()
 JY.Status=GAME_START;
 end,
 [784]=function()
 JY.Status=GAME_START;
 end,
 [785]=function()
 JY.Status=GAME_START;
 end,
 [786]=function()
 JY.Status=GAME_START;
 end,
 [787]=function()
 JY.Status=GAME_START;
 end,
 [788]=function()
 JY.Status=GAME_START;
 end,
 [789]=function()
 JY.Status=GAME_START;
 end,
 [790]=function()
 JY.Status=GAME_START;
 end,
 [791]=function()
 JY.Status=GAME_START;
 end,
 [792]=function()
 JY.Status=GAME_START;
 end,
 [793]=function()
 JY.Status=GAME_START;
 end,
 [794]=function()
 JY.Status=GAME_START;
 end,
 [795]=function()
 JY.Status=GAME_START;
 end,
 [796]=function()
 JY.Status=GAME_START;
 end,
 [797]=function()
 JY.Status=GAME_START;
 end,
 [798]=function()
 JY.Status=GAME_START;
 end,
 [799]=function()
 JY.Status=GAME_START;
 end,
 [800]=function()
 JY.Status=GAME_START;
 end,
 [801]=function()
 JY.Status=GAME_START;
 end,
 [802]=function()
 JY.Status=GAME_START;
 end,
 [803]=function()
 JY.Status=GAME_START;
 end,
 [804]=function()
 JY.Status=GAME_START;
 end,
 [805]=function()
 JY.Status=GAME_START;
 end,
 [806]=function()
 JY.Status=GAME_START;
 end,
 [807]=function()
 JY.Status=GAME_START;
 end,
 [808]=function()
 JY.Status=GAME_START;
 end,
 [809]=function()
 JY.Status=GAME_START;
 end,
 [810]=function()
 JY.Status=GAME_START;
 end,
 [811]=function()
 JY.Status=GAME_START;
 end,
 [812]=function()
 JY.Status=GAME_START;
 end,
 [813]=function()
 JY.Status=GAME_START;
 end,
 [814]=function()
 JY.Status=GAME_START;
 end,
 [815]=function()
 JY.Status=GAME_START;
 end,
 [816]=function()
 JY.Status=GAME_START;
 end,
 [817]=function()
 JY.Status=GAME_START;
 end,
 [818]=function()
 JY.Status=GAME_START;
 end,
 [819]=function()
 JY.Status=GAME_START;
 end,
 [820]=function()
 JY.Status=GAME_START;
 end,
 [821]=function()
 JY.Status=GAME_START;
 end,
 [822]=function()
 JY.Status=GAME_START;
 end,
 [823]=function()
 JY.Status=GAME_START;
 end,
 [824]=function()
 JY.Status=GAME_START;
 end,
 [825]=function()
 JY.Status=GAME_START;
 end,
 [826]=function()
 JY.Status=GAME_START;
 end,
 [827]=function()
 JY.Status=GAME_START;
 end,
 [828]=function()
 JY.Status=GAME_START;
 end,
 [829]=function()
 JY.Status=GAME_START;
 end,
 [830]=function()
 JY.Status=GAME_START;
 end,
 [831]=function()
 JY.Status=GAME_START;
 end,
 [832]=function()
 JY.Status=GAME_START;
 end,
 [833]=function()
 JY.Status=GAME_START;
 end,
 [834]=function()
 JY.Status=GAME_START;
 end,
 [835]=function()
 JY.Status=GAME_START;
 end,
 [836]=function()
 JY.Status=GAME_START;
 end,
 [837]=function()
 JY.Status=GAME_START;
 end,
 [838]=function()
 JY.Status=GAME_START;
 end,
 [839]=function()
 JY.Status=GAME_START;
 end,
 [840]=function()
 JY.Status=GAME_START;
 end,
 [841]=function()
 JY.Status=GAME_START;
 end,
 [842]=function()
 JY.Status=GAME_START;
 end,
 [843]=function()
 JY.Status=GAME_START;
 end,
 [844]=function()
 JY.Status=GAME_START;
 end,
 [845]=function()
 JY.Status=GAME_START;
 end,
 [846]=function()
 JY.Status=GAME_START;
 end,
 [847]=function()
 JY.Status=GAME_START;
 end,
 [848]=function()
 JY.Status=GAME_START;
 end,
 [849]=function()
 JY.Status=GAME_START;
 end,
 [850]=function()
 JY.Status=GAME_START;
 end,
 [851]=function()
 JY.Status=GAME_START;
 end,
 [852]=function()
 JY.Status=GAME_START;
 end,
 [853]=function()
 JY.Status=GAME_START;
 end,
 [854]=function()
 JY.Status=GAME_START;
 end,
 [855]=function()
 JY.Status=GAME_START;
 end,
 [856]=function()
 JY.Status=GAME_START;
 end,
 [857]=function()
 JY.Status=GAME_START;
 end,
 [858]=function()
 JY.Status=GAME_START;
 end,
 [859]=function()
 JY.Status=GAME_START;
 end,
 [860]=function()
 JY.Status=GAME_START;
 end,
 [861]=function()
 JY.Status=GAME_START;
 end,
 [862]=function()
 JY.Status=GAME_START;
 end,
 [863]=function()
 JY.Status=GAME_START;
 end,
 [864]=function()
 JY.Status=GAME_START;
 end,
 [865]=function()
 JY.Status=GAME_START;
 end,
 [866]=function()
 JY.Status=GAME_START;
 end,
 [867]=function()
 JY.Status=GAME_START;
 end,
 [868]=function()
 JY.Status=GAME_START;
 end,
 [869]=function()
 JY.Status=GAME_START;
 end,
 [870]=function()
 JY.Status=GAME_START;
 end,
 [871]=function()
 JY.Status=GAME_START;
 end,
 [872]=function()
 JY.Status=GAME_START;
 end,
 [873]=function()
 JY.Status=GAME_START;
 end,
 [874]=function()
 JY.Status=GAME_START;
 end,
 [875]=function()
 JY.Status=GAME_START;
 end,
 [876]=function()
 JY.Status=GAME_START;
 end,
 [877]=function()
 JY.Status=GAME_START;
 end,
 [878]=function()
 JY.Status=GAME_START;
 end,
 [879]=function()
 JY.Status=GAME_START;
 end,
 [880]=function()
 JY.Status=GAME_START;
 end,
 [881]=function()
 JY.Status=GAME_START;
 end,
 [882]=function()
 JY.Status=GAME_START;
 end,
 [883]=function()
 JY.Status=GAME_START;
 end,
 [884]=function()
 JY.Status=GAME_START;
 end,
 [885]=function()
 JY.Status=GAME_START;
 end,
 [886]=function()
 JY.Status=GAME_START;
 end,
 [887]=function()
 JY.Status=GAME_START;
 end,
 [888]=function()
 JY.Status=GAME_START;
 end,
 [889]=function()
 JY.Status=GAME_START;
 end,
 [890]=function()
 JY.Status=GAME_START;
 end,
 [891]=function()
 JY.Status=GAME_START;
 end,
 [892]=function()
 JY.Status=GAME_START;
 end,
 [893]=function()
 JY.Status=GAME_START;
 end,
 [894]=function()
 JY.Status=GAME_START;
 end,
 [895]=function()
 JY.Status=GAME_START;
 end,
 [896]=function()
 JY.Status=GAME_START;
 end,
 [897]=function()
 JY.Status=GAME_START;
 end,
 [898]=function()
 JY.Status=GAME_START;
 end,
 [899]=function()
 JY.Status=GAME_START;
 end,
 [900]=function()
 JY.Status=GAME_START;
 end,
 [901]=function()
 JY.Status=GAME_START;
 end,
 [902]=function()
 JY.Status=GAME_START;
 end,
 [903]=function()
 JY.Status=GAME_START;
 end,
 [904]=function()
 JY.Status=GAME_START;
 end,
 [905]=function()
 JY.Status=GAME_START;
 end,
 [906]=function()
 JY.Status=GAME_START;
 end,
 [907]=function()
 JY.Status=GAME_START;
 end,
 [908]=function()
 JY.Status=GAME_START;
 end,
 [909]=function()
 JY.Status=GAME_START;
 end,
 [910]=function()
 JY.Status=GAME_START;
 end,
 [911]=function()
 JY.Status=GAME_START;
 end,
 [912]=function()
 JY.Status=GAME_START;
 end,
 [913]=function()
 JY.Status=GAME_START;
 end,
 [914]=function()
 JY.Status=GAME_START;
 end,
 [915]=function()
 JY.Status=GAME_START;
 end,
 [916]=function()
 JY.Status=GAME_START;
 end,
 [917]=function()
 JY.Status=GAME_START;
 end,
 [918]=function()
 JY.Status=GAME_START;
 end,
 [919]=function()
 JY.Status=GAME_START;
 end,
 [920]=function()
 JY.Status=GAME_START;
 end,
 [921]=function()
 JY.Status=GAME_START;
 end,
 [922]=function()
 JY.Status=GAME_START;
 end,
 [923]=function()
 JY.Status=GAME_START;
 end,
 [924]=function()
 JY.Status=GAME_START;
 end,
 [925]=function()
 JY.Status=GAME_START;
 end,
 [926]=function()
 JY.Status=GAME_START;
 end,
 [927]=function()
 JY.Status=GAME_START;
 end,
 [928]=function()
 JY.Status=GAME_START;
 end,
 [929]=function()
 JY.Status=GAME_START;
 end,
 [930]=function()
 JY.Status=GAME_START;
 end,
 [931]=function()
 JY.Status=GAME_START;
 end,
 [932]=function()
 JY.Status=GAME_START;
 end,
 [933]=function()
 JY.Status=GAME_START;
 end,
 [934]=function()
 JY.Status=GAME_START;
 end,
 [935]=function()
 JY.Status=GAME_START;
 end,
 [936]=function()
 JY.Status=GAME_START;
 end,
 [937]=function()
 JY.Status=GAME_START;
 end,
 [938]=function()
 JY.Status=GAME_START;
 end,
 [939]=function()
 JY.Status=GAME_START;
 end,
 [940]=function()
 JY.Status=GAME_START;
 end,
 [941]=function()
 JY.Status=GAME_START;
 end,
 [942]=function()
 JY.Status=GAME_START;
 end,
 [943]=function()
 JY.Status=GAME_START;
 end,
 [944]=function()
 JY.Status=GAME_START;
 end,
 [945]=function()
 JY.Status=GAME_START;
 end,
 [946]=function()
 JY.Status=GAME_START;
 end,
 [947]=function()
 JY.Status=GAME_START;
 end,
 [948]=function()
 JY.Status=GAME_START;
 end,
 [949]=function()
 JY.Status=GAME_START;
 end,
 [950]=function()
 JY.Status=GAME_START;
 end,
 [951]=function()
 JY.Status=GAME_START;
 end,
 [952]=function()
 JY.Status=GAME_START;
 end,
 [953]=function()
 JY.Status=GAME_START;
 end,
 [954]=function()
 JY.Status=GAME_START;
 end,
 [955]=function()
 JY.Status=GAME_START;
 end,
 [956]=function()
 JY.Status=GAME_START;
 end,
 [957]=function()
 JY.Status=GAME_START;
 end,
 [958]=function()
 JY.Status=GAME_START;
 end,
 [959]=function()
 JY.Status=GAME_START;
 end,
 [960]=function()
 JY.Status=GAME_START;
 end,
 [961]=function()
 JY.Status=GAME_START;
 end,
 [962]=function()
 JY.Status=GAME_START;
 end,
 [963]=function()
 JY.Status=GAME_START;
 end,
 [964]=function()
 JY.Status=GAME_START;
 end,
 [965]=function()
 JY.Status=GAME_START;
 end,
 [966]=function()
 JY.Status=GAME_START;
 end,
 [967]=function()
 JY.Status=GAME_START;
 end,
 [968]=function()
 JY.Status=GAME_START;
 end,
 [969]=function()
 JY.Status=GAME_START;
 end,
 [970]=function()
 JY.Status=GAME_START;
 end,
 [971]=function()
 JY.Status=GAME_START;
 end,
 [972]=function()
 JY.Status=GAME_START;
 end,
 [973]=function()
 JY.Status=GAME_START;
 end,
 [974]=function()
 JY.Status=GAME_START;
 end,
 [975]=function()
 JY.Status=GAME_START;
 end,
 [976]=function()
 JY.Status=GAME_START;
 end,
 [977]=function()
 JY.Status=GAME_START;
 end,
 [978]=function()
 JY.Status=GAME_START;
 end,
 [979]=function()
 JY.Status=GAME_START;
 end,
 [980]=function()
 JY.Status=GAME_START;
 end,
 [981]=function()
 JY.Status=GAME_START;
 end,
 [982]=function()
 JY.Status=GAME_START;
 end,
 [983]=function()
 JY.Status=GAME_START;
 end,
 [984]=function()
 JY.Status=GAME_START;
 end,
 [985]=function()
 JY.Status=GAME_START;
 end,
 [986]=function()
 JY.Status=GAME_START;
 end,
 [987]=function()
 JY.Status=GAME_START;
 end,
 [988]=function()
 JY.Status=GAME_START;
 end,
 [989]=function()
 JY.Status=GAME_START;
 end,
 [990]=function()
 JY.Status=GAME_START;
 end,
 [991]=function()
 JY.Status=GAME_START;
 end,
 [992]=function()
 JY.Status=GAME_START;
 end,
 [993]=function()
 JY.Status=GAME_START;
 end,
 [994]=function()
 JY.Status=GAME_START;
 end,
 [995]=function()
 JY.Status=GAME_START;
 end,
 [996]=function()
 JY.Status=GAME_START;
 end,
 [997]=function()
 JY.Status=GAME_START;
 end,
 [998]=function()
 JY.Status=GAME_START;
 end,
 [999]=function()
 JY.Status=GAME_START;
 end,
 };
