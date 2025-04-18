
#Область СлужебныйПрограммныйИнтерфейс

// Процедура заполняет табличную часть документа по полученным сведениям
// 
// Параметры:
//  СтрокаТабличнойЧасти - Структура: Номенклатура, ЕдиницаИзмерения, Количество, 
//										КодОКПД2, ЕдиницаИзмеренияПрослеживаемости,
//										КоличествоПрослеживаемости, Сумма
//  ДанныеОбъекта - Структура: КодТНВЭД
//
Процедура ТоварыНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, ДанныеОбъекта) Экспорт
	
	СведенияОНоменклатуреПрослеживаемогоТовара =
		ПрослеживаемостьВызовСервераПереопределяемый.ПолучитьСведенияПрослеживаемогоТовара(
			СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	
	Если СведенияОНоменклатуреПрослеживаемогоТовара <> Неопределено Тогда
		
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СведенияОНоменклатуреПрослеживаемогоТовара);
		
	КонецЕсли;
	
КонецПроцедуры

// Функция формирует список ТНВЭД, по которым было движение в регистре:
// РегистрацияПрослеживаемыхТоваровСрезПоследних по первичному документу
//
// Параметры:
//  ПервичныйДокумент - ДокументСсылка - ссылка на первичный документ
//  Ссылка - ДокументСсылка - Ссылка на документ в котором необходимо отобрать список ТНВЭД
//  Период - Дата - дата, на которую необходимо получить список актуальных ТНВЭД
// 
// Возвращаемое значение:
//  Массив - массив ТНВЭД
//
Функция СписокТНВЭД(ПервичныйДокумент, Ссылка, Период) Экспорт
	
	Возврат ПрослеживаемостьФормыВызовСервераПереопределяемый.СписокТНВЭД(ПервичныйДокумент, Ссылка, Период);
	
КонецФункции

// Функция формирует список номенклатуры, по которым было движение в регистре:
// РегистрацияПрослеживаемыхТоваровСрезПоследних по первичному документу
//
// Параметры:
//  ПервичныйДокумент - ДокументСсылка - ссылка на первичный документ
//  КодТНВЭД -  - Код ТНВЭД для отбора
//  Период - Дата - дата, на которую необходимо получить список актуальных ТНВЭД
// 
// Возвращаемое значение:
//  Массив - массив Номенклатуры
//
Функция СписокНоменклатуры(ПервичныйДокумент, КодТНВЭД, Период) Экспорт
	
	Возврат ПрослеживаемостьФормыВызовСервераПереопределяемый.СписокНоменклатуры(ПервичныйДокумент, КодТНВЭД, Период);
	
КонецФункции

// Возвращает имя документа по ссылке на документ
// 
// Параметры: 
//  Документ - ДокументСсылка - ссылка на документ
// 
// Возвращемое значение:
//  Строка - имя документа как метаданных
// 
Функция ИмяДокумента(Документ) Экспорт
	
	ДокументИмя = Документ.Метаданные().Имя;
	
	Возврат ДокументИмя;
	
КонецФункции

// Возвращает структуру реквизитов документов 
// Параметры: 
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура
// 
// Возвращемое значение:
//  Структура - КодТНВЭД - СправочникСсылка.КлассификаторТНВЭД
//            - ЕдиницаИзмерения - СправочникСсылка.КлассификаторЕдиницИзмерения
//
Функция ПараметрыНоменклатуры(Номенклатура) Экспорт
	
	Возврат ПрослеживаемостьФормыВызовСервераПереопределяемый.ПараметрыНоменклатуры(Номенклатура);
	
КонецФункции

#Область УведомленияОбОстатках

// Возвращает признак уведомления в виде текста 
// Параметры:
//  ПризнакУведомления - Число - признак уведомления
//
// Возвращаемое значение:
//  Строка - текстовое значение признака уведомления
//
Функция ТекстДополнительныеСведения(ДополнительныеРеквизиты) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДополнительныеРеквизиты.ПризнакУведомления)
		И НЕ ЗначениеЗаполнено(ДополнительныеРеквизиты.КодФормыРеорганизации) Тогда 
		Возврат НСтр("ru = 'Дополнительные сведения: Отсутствуют'")
	КонецЕсли;
		
	ШаблонТекста = НСтр("ru = '%1%2 %3'");
	
	ТекстПоРеорганизации = "";
	ЕстьТочка = ДополнительныеРеквизиты.ПризнакУведомления>0 И ЗначениеЗаполнено(ДополнительныеРеквизиты.КодФормыРеорганизации);
	
	Если ЗначениеЗаполнено(ДополнительныеРеквизиты.КодФормыРеорганизации) Тогда
		
		ШаблонТекстаПоРеорганизации = НСтр("ru = 'Заполняется за организацию после %1'");
		
		ТекстКодаРеорганизации = 
			СклонениеПредставленийОбъектов.ПросклонятьПредставление(
				ОписаниеКодаРеорганизации(ДополнительныеРеквизиты.КодФормыРеорганизации), 2);
		
		ТекстПоРеорганизации = СтрШаблон(ШаблонТекстаПоРеорганизации, 
			НРег(ТекстКодаРеорганизации));
		
	КонецЕсли;
	
	Возврат СтрШаблон(ШаблонТекста, ОписаниеПризнакаУведомления(ДополнительныеРеквизиты.ПризнакУведомления),
			?(ЕстьТочка, ".", ""),
			ТекстПоРеорганизации);
	
КонецФункции

Функция ОписаниеПризнакаУведомления(ПризнакУведомления) Экспорт
	Если ПризнакУведомления = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Если  ПризнакУведомления = 1 Тогда 
		Возврат НСтр("ru='Товары были в собственности физических лиц'");
		
	ИначеЕсли  ПризнакУведомления = 2 Тогда 
		Возврат НСтр("ru='Товары были в собственности плательщиков НПД'");
		
	Иначе
		Возврат НСтр("ru='Товары приобретены у государственных органов'");
	
	КонецЕсли;
	
КонецФункции

// Возвращает текст кода реорганизации
//
// Параметры:
// КодФормыРеорганизации - Строка - Код формы реорганизации
//
// Возвращаемое значение:
// Строка - описание кода реорганизации
//
Функция ОписаниеКодаРеорганизации(КодФормыРеорганизации) Экспорт
	Если НЕ ЗначениеЗаполнено(КодФормыРеорганизации) Тогда
		Возврат "";
	КонецЕсли;
	
	СписокКодовФормыРеорганизации = Новый СписокЗначений;
	ПрослеживаемостьБРУ.СписокКодовФормыРеорганизации(СписокКодовФормыРеорганизации);
	
	ОписаниеТекущегоКода = 
		СписокКодовФормыРеорганизации.НайтиПоЗначению(КодФормыРеорганизации);
		
	Возврат СокрЛП(
				Прав(ОписаниеТекущегоКода.Представление, СтрДлина(ОписаниеТекущегоКода.Представление)-3)
				);

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
