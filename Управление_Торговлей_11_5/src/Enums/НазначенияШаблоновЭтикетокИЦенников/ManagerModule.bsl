
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляТоваров);
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЦенникДляТоваров);
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляСкладскихЯчеек);
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляДоставки);
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаСерииНоменклатуры);
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаУпаковочныхЛистов);
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляАкцизныхМарок);
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляШтрихкодовУпаковок);
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаТМЦВЭксплуатацииЛента);
	ДанныеВыбора.Добавить(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаТМЦВЭксплуатацииБумага);

	
КонецПроцедуры

#КонецОбласти
