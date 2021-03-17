/*
	Created by: Greg Hacic
	Last Update: 4 February 2011 by Greg Hacic
	Questions?: greg@interactiveties.com
	Copyright (c) 2011 Interactive Ties LLC
	
	Notes:
			- controller for the locale_formatted_datetime Visualforce component
*/

public class controller_locale_formatted_datetime {
	
	public DateTime date_time { get; set; } //property that reads the datetime value from the component attribute tag
	
	//returns the properly formatted datetime value
	public String getTimeZoneValue() {
		Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
		mappedValues = MapValues(); //populate the map with all the locale specific datetime formats
		String user_locale = UserInfo.getLocale(); //grab the locale of the user
		String datetime_format = 'M/d/yyyy hh:mm a zz'; //variable for the datetime format defaulted to the US format
		if (mappedValues.containsKey(user_locale)) { //if the map contains the correct datetime format
			datetime_format = mappedValues.get(user_locale); //grab the datetime format for the locale
		}
		String locale_formatted_date_time_value = date_time.format(datetime_format); //create a string with the proper format
		return locale_formatted_date_time_value; //return the string
	}
	
	//populate a map with locale values and corresponding datetime formats
	private Map<String, String> MapValues() {
		Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
		locale_map.put('af_ZA', 'yyyy-MM-dd HH:mm');
		locale_map.put('ar_AE', 'd/M/yyyy h:mm a');
		locale_map.put('ar_BH', 'd/M/yyyy h:mm a');
		locale_map.put('ar_DZ', 'd/M/yyyy h:mm a');
		locale_map.put('ar_EG', 'd/M/yyyy h:mm a');
		locale_map.put('ar_IQ', 'd/M/yyyy h:mm a');
		locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_KW', 'd/M/yyyy h:mm a');
		locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_LY', 'd/M/yyyy h:mm a');
		locale_map.put('ar_MA', 'd/M/yyyy HH:mm');
		locale_map.put('ar_OM', 'd/M/yyyy h:mm a');
		locale_map.put('ar_QA', 'd/M/yyyy h:mm a');
		locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_SD', 'd/M/yyyy h:mm a');
		locale_map.put('ar_SY', 'dd/MM/yyyy hh:mm a');
		locale_map.put('ar_TN', 'd/M/yyyy h:mm a');
		locale_map.put('ar_YE', 'd/M/yyyy h:mm a');
		locale_map.put('az_AZ', 'dd.MM.yyyy HH:mm');
		locale_map.put('be_BY', 'd.M.yyyy H.mm');
		locale_map.put('bg_BG', 'dd.MM.yyyy HH:mm');
		locale_map.put('bn_BD', 'd/M/yyyy h:mm a');
		locale_map.put('bn_IN', 'd/M/yyyy h:mm a');
		locale_map.put('bs_BA', 'd.M.yyyy. HH:mm');
		locale_map.put('ca_ES', 'dd/MM/yyyy HH:mm');
		locale_map.put('ca_ES_EURO', 'dd/MM/yyyy HH:mm');
		locale_map.put('cs_CZ', 'd.M.yyyy H:mm');
		locale_map.put('cy_GB', 'dd/MM/yyyy HH:mm');
		locale_map.put('da_DK', 'dd-MM-yyyy HH:mm');
		locale_map.put('de_AT', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_AT_EURO', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_BE', 'dd.MM.yyyy, HH:mm');
		locale_map.put('de_DE', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_DE_EURO', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_LU', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_LU_EURO', 'dd.MM.yyyy HH:mm');
		locale_map.put('de_CH', 'dd.MM.yyyy HH:mm');
		locale_map.put('dz_BT', 'yyyy-MM-dd ཆུ་ཚོད་ h སྐར་མ་ mm a');
		locale_map.put('el_GR', 'd/M/yyyy h:mm a');
		locale_map.put('en_AG', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_AU', 'd/MM/yyyy h:mm a');
		locale_map.put('en_BB', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_BS', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_BZ', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_BM', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_BW', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_CA', 'dd/MM/yyyy h:mm a');
		locale_map.put('en_CM', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_KY', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_ER', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_FK', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_FJ', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_GM', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_GH', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_GI', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_GY', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_HK', 'd/M/yyyy, h:mm a');
		locale_map.put('en_IN', 'd/M/yyyy h:mm a');
		locale_map.put('en_ID', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_IE', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_IE_EURO', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_JM', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_KE', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_LR', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_MG', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_MW', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_MY', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_MU', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_NA', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_NZ', 'd/MM/yyyy h:mm a');
		locale_map.put('en_NG', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_PK', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_PG', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_PH', 'M/d/yyyy h:mm a');
		locale_map.put('en_RW', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_SH', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_WS', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_SC', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_SL', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_SG', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_SX', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_SB', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_ZA', 'yyyy/MM/dd h:mm a');
		locale_map.put('en_SZ', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_TZ', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_TO', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_TT', 'dd/MM/yyyy, h:mm a');
		locale_map.put('en_UG', 'dd/MM/yyyy, HH:mm');
		locale_map.put('en_GB', 'dd/MM/yyyy HH:mm');
		locale_map.put('en_US', 'MM/dd/yyyy hh:mm a zz');
		locale_map.put('en_VU', 'dd/MM/yyyy, h:mm a');
		locale_map.put('es_AR', 'dd/MM/yyyy HH:mm');
		locale_map.put('es_BO', 'dd-MM-yyyy hh:mm a');
		locale_map.put('es_CL', 'dd-MM-yyyy H:mm');
		locale_map.put('es_CO', 'd/MM/yyyy hh:mm a');
		locale_map.put('es_CR', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_CU', 'd/M/yyyy HH:mm');
		locale_map.put('es_DO', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_EC', 'dd/MM/yyyy H:mm');
		locale_map.put('es_ES', 'd/MM/yyyy H:mm');
		locale_map.put('es_ES_EURO', 'd/MM/yyyy H:mm');
		locale_map.put('es_GT', 'd/MM/yyyy hh:mm a');
		locale_map.put('es_HN', 'MM-dd-yyyy hh:mm a');
		locale_map.put('es_MX', 'd/MM/yyyy hh:mm a');
		locale_map.put('es_NI', 'MM-dd-yyyy hh:mm a');
		locale_map.put('es_PA', 'MM/dd/yyyy hh:mm a');
		locale_map.put('es_PE', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_PR', 'MM-dd-yyyy hh:mm a');
		locale_map.put('es_PY', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_SV', 'MM-dd-yyyy hh:mm a');
		locale_map.put('es_US', 'M/d/yyyy hh:mm a zz');
		locale_map.put('es_UY', 'dd/MM/yyyy hh:mm a');
		locale_map.put('es_VE', 'dd/MM/yyyy hh:mm a');
		locale_map.put('et_EE', 'd.MM.yyyy H:mm');
		locale_map.put('eu_ES', 'yyyy/M/d HH:mm');
		locale_map.put('fa_IR', 'yyyy/M/d،\u200f H:mm');
		locale_map.put('fi_FI', 'd.M.yyyy H:mm');
		locale_map.put('fi_FI_EURO', 'd.M.yyyy H:mm');
		locale_map.put('fr_BE', 'd/MM/yyyy H:mm');
		locale_map.put('fr_CA', 'yyyy-MM-dd HH:mm');
		locale_map.put('fr_KM', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_FR', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_FR_EURO', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_GN', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_HT', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_LU', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_MR', 'dd/MM/yyyy h:mm a');
		locale_map.put('fr_MC', 'dd/MM/yyyy HH:mm');
		locale_map.put('fr_CH', 'dd.MM.yyyy HH:mm');
		locale_map.put('fr_WF', 'dd/MM/yyyy HH:mm');
		locale_map.put('ga_IE', 'dd/MM/yyyy HH:mm');
		locale_map.put('gu_IN', 'd/M/yyyy hh:mm a');
		locale_map.put('hi_IN', 'd/M/yyyy h:mm a');
		locale_map.put('hr_HR', 'dd.MM.yyyy. HH:mm');
		locale_map.put('hu_HU', 'yyyy.MM.dd. H:mm');
		locale_map.put('hy_AM', 'dd.MM.yyyy, HH:mm');
		locale_map.put('in_ID', 'dd/MM/yyyy H:mm');
		locale_map.put('is_IS', 'd.M.yyyy HH:mm');
		locale_map.put('it_CH', 'dd.MM.yyyy HH:mm');
		locale_map.put('it_IT', 'dd/MM/yyyy H.mm');
		locale_map.put('iw_IL', 'HH:mm dd/MM/yyyy');
		locale_map.put('ja_JP', 'yyyy/MM/dd H:mm');
		locale_map.put('ka_GE', 'dd.MM.yyyy, HH:mm');
		locale_map.put('kk_KZ', 'dd.MM.yyyy, HH:mm');
		locale_map.put('km_KH', 'd/M/yyyy, h:mm a');
		locale_map.put('kn_IN', 'd/M/yyyy hh:mm a');
		locale_map.put('ko_KP', 'yyyy. M. d. a h:mm');
		locale_map.put('ko_KR', 'yyyy. M. d a h:mm');
		locale_map.put('ky_KG', 'd/M/yyyy HH:mm');
		locale_map.put('lb_LU', 'dd.MM.yyyy HH:mm');
		locale_map.put('lo_LA', 'd/M/yyyy, H:mm');
		locale_map.put('lt_LT', 'yyyy.M.d HH.mm');
		locale_map.put('lu_CD', 'd/M/yyyy HH:mm');
		locale_map.put('lv_LV', 'dd.MM.yyyy HH:mm');
		locale_map.put('mk_MK', 'd.M.yyyy HH:mm');
		locale_map.put('ml_IN', 'd/M/yyyy h:mm a');
		locale_map.put('mr_IN', 'd/M/yyyy, h:mm a');
		locale_map.put('ms_BN', 'd/MM/yyyy, h:mm a');
		locale_map.put('ms_MY', 'dd/MM/yyyy h:mm a');
		locale_map.put('mt_MT', 'dd/MM/yyyy HH:mm');
		locale_map.put('my_MM', 'dd-MM-yyyy B H:mm');
		locale_map.put('ne_NP', 'yyyy/M/d, HH:mm');
		locale_map.put('nl_AW', 'dd-MM-yyyy HH:mm');
		locale_map.put('nl_BE', 'd/MM/yyyy H:mm');
		locale_map.put('nl_NL', 'd-M-yyyy H:mm');
		locale_map.put('nl_SR', 'dd-MM-yyyy HH:mm');
		locale_map.put('no_NO', 'dd.MM.yyyy HH:mm');
		locale_map.put('pl_PL', 'dd.MM.yyyy HH:mm');
		locale_map.put('ps_AF', 'GGGGG yyyy/M/d H:mm');
		locale_map.put('pt_AO', 'dd/MM/yyyy, HH:mm');
		locale_map.put('pt_BR', 'dd/MM/yyyy HH:mm');
		locale_map.put('pt_CV', 'dd/MM/yyyy, HH:mm');
		locale_map.put('pt_MZ', 'dd/MM/yyyy, HH:mm');
		locale_map.put('pt_PT', 'dd-MM-yyyy H:mm');
		locale_map.put('pt_ST', 'dd/MM/yyyy, HH:mm');
		locale_map.put('rm_CH', 'dd-MM-yyyy HH:mm');
		locale_map.put('rn_BI', 'd/M/yyyy HH:mm');
		locale_map.put('ro_MD', 'dd.MM.yyyy, HH:mm');
		locale_map.put('ro_RO', 'dd.MM.yyyy HH:mm');
		locale_map.put('ru_KZ', 'dd.MM.yyyy, H:mm');
		locale_map.put('ru_RU', 'dd.MM.yyyy H:mm');
		locale_map.put('sh_BA', 'dd.MM.yyyy. HH:mm');
		locale_map.put('sh_CS', 'dd.MM.yyyy. HH:mm');
		locale_map.put('sh_ME', 'dd.MM.yyyy. HH:mm');
		locale_map.put('sk_SK', 'd.M.yyyy H:mm');
		locale_map.put('sl_SI', 'd.M.yyyy H:mm');
		locale_map.put('so_DJ', 'dd/MM/yyyy h:mm a');
		locale_map.put('so_SO', 'dd/MM/yyyy h:mm a');
		locale_map.put('sr_BA', 'yyyy-MM-dd HH:mm');
		locale_map.put('sr_CS', 'd.M.yyyy. HH.mm');
		locale_map.put('sr_RS', 'd.M.yyyy. HH.mm');
		locale_map.put('sq_AL', 'yyyy-MM-dd h.mm.a');
		locale_map.put('sv_SE', 'yyyy-MM-dd HH:mm');
		locale_map.put('sw_KE', 'dd/MM/yyyy, HH:mm');
		locale_map.put('ta_IN', 'd/M/yyyy, a h:mm');
		locale_map.put('ta_LK', 'd/M/yyyy, HH:mm');
		locale_map.put('te_IN', 'dd-MM-yyyy h:mm a');
		locale_map.put('tg_TJ', 'dd/MM/yyyy HH:mm');
		locale_map.put('th_TH', 'd/M/yyyy, H:mm น.');
		locale_map.put('ti_ET', 'dd/MM/yyyy h:mm a');
		locale_map.put('tl_PH', 'M/d/yyyy h:mm a');
		locale_map.put('tr_TR', 'dd.MM.yyyy HH:mm');
		locale_map.put('uk_UA', 'dd.MM.yyyy H:mm');
		locale_map.put('ur_PK', 'd/M/yyyy h:mm a');
		locale_map.put('uz_LATN_UZ', 'dd/MM/yyyy, HH:mm');
		locale_map.put('vi_VN', 'HH:mm dd/MM/yyyy');
		locale_map.put('yo_BJ', 'dd/MM/yyyy HH:mm');
		locale_map.put('xh_ZA', 'M/d/yyyy h:mm a');
		locale_map.put('zh_CN', 'yyyy-M-d ah:mm');
		locale_map.put('zh_CN_PINYIN', 'yyyy/M/d ah:mm');
		locale_map.put('zh_CN_STROKE', 'yyyy/M/d ah:mm');
		locale_map.put('zh_HK', 'yyyy年M月d日 ah:mm');
		locale_map.put('zh_HK_STROKE', 'd/M/yyyy ah:mm');
		locale_map.put('zh_MO', 'd/M/yyyy ah:mm');
		locale_map.put('zh_SG', 'dd/MM/yyyy a hh:mm');
		locale_map.put('zh_TW', 'yyyy/M/d a h:mm');
		locale_map.put('zh_TW_STROKE', 'yyyy/M/d ah:mm');
		locale_map.put('zu_ZA', 'M/d/yyyy HH:mm');
		return locale_map; //return the map
	}
}