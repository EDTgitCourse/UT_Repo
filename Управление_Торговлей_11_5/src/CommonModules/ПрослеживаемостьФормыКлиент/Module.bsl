#Область СлужебныйПрограммныйИнтерфейс

// Процедура вызывается при выборе ТНВЭД и номенклатуры в документе
// Уведомление об остатках прослеживаемых товаров
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма из которой вызвана формы выбора
//  Выбранное значение - выбранное значение в форме выбора
//  ИсточникВыбора - ФормаКлиенскогоПриложения - форма в которой выбрали значение
//
Процедура ОбработкаВыбораУведомления(Форма, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если ИсточникВыбора.ИмяФормы = ПрослеживаемостьФормыКлиентПереопределяемый.ФормаВыбораНоменклатуры() Тогда
		
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;

		ТекущиеДанные.Номенклатура = ВыбранноеЗначение;
		
		ДанныеСтрокиТаблицы = Новый Структура(
			"Номенклатура, ЕдиницаИзмерения, Количество, 
			|КодОКПД2, ЕдиницаПрослеживаемости,
			|КоличествоПрослеживаемости,Сумма,СтранаПроисхождения");
		
		ПрослеживаемостьКлиентПереопределяемый.ДанныеСтрокиТаблицыТоварыУведомленияОбОстатках(ДанныеСтрокиТаблицы);
		
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
		
		ДанныеОбъекта = Новый Структура("КодТНВЭД,ЕдиницаПрослеживаемости");
		
		ПрослеживаемостьКлиентПереопределяемый.ДанныеОбъектаУведомленияОбОСтатках(ДанныеОбъекта);
		
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Форма.Объект);
		
		ПрослеживаемостьФормыВызовСервера.ТоварыНоменклатураПриИзмененииНаСервере(
			ДанныеСтрокиТаблицы,
			ДанныеОбъекта);
	
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);
		
		ТоварыКоличествоПриИзмененииУведомления(Форма, ТекущиеДанные);
		
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = ПрослеживаемостьФормыКлиентПереопределяемый.ФормаВыбораТНВЭД() Тогда
		
		ЗаполнитьЗначенияСвойств(Объект, 
			ПрослеживаемостьВызовСервераПереопределяемый.ПараметрыВыбранногоТНВЭД(ВыбранноеЗначение));
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = 
			"Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаДополнительныхСведений" Тогда
		
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение,,"Продавцы");
		
		Объект.Продавцы.Очистить();
		
		Для каждого ТекущаяСтрока Из ВыбранноеЗначение.Продавцы Цикл
			
			НоваяСтрока = Объект.Продавцы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
			
		КонецЦикла;
		
		Форма.Модифицированность = Истина;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = 
			"Документ.УведомлениеОВвозеПрослеживаемыхТоваров.Форма.ФормаДополнительныхСведений" Тогда
		
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение,,);
		
		Форма.Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры 

// Процедура вызывается при начале выбора номенклатуры
// 
// Параметры:
// ФормаВладелец - ФормаКлиентскогоПриложения - Форма, в которой выбрали номенклатуру
Процедура ТоварыНоменклатураНачалоВыбораУведомления(ФормаВладелец) Экспорт
	
	Объект = ФормаВладелец.Объект;
	
	РеквизитыОтбора = Новый Структура("СписокНоменклатуры",
		ПрослеживаемостьФормыВызовСервера.СписокНоменклатуры(Объект.ПервичныйДокумент, Объект.КодТНВЭД, Объект.Дата));
	
	ПрослеживаемостьФормыКлиентПереопределяемый.ОткрытьФормуВыбораНоменклатуры(
		ФормаВладелец, РеквизитыОтбора);
	
КонецПроцедуры

// Процедура вызывается при изменении количества в документе 
// Уведомление об остатках прослеживаемых товаров
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма владелец
//  ТекущиеДанные - ДанныеФормыЭлементКоллекции - текущая строка в таблице товары
//
Процедура ТоварыКоличествоПриИзмененииУведомления(Форма, ТекущиеДанные) Экспорт
	
	Объект = Форма.Объект;
	
	Если Объект.ЕдиницаИзмерения = Объект.ЕдиницаПрослеживаемости Тогда
		
		ВесПоСертификатуТовара = 1;
		
	Иначе
		
		ВесПоСертификатуТовара = 
			ПрослеживаемостьВызовСервераПереопределяемый.ВесТовараПоСертификату(ТекущиеДанные.Номенклатура);
			
	КонецЕсли;
	
	Если Объект.НомерКорректировки = 0 Тогда
		
		ТекущиеДанные.КоличествоПрослеживаемости = ТекущиеДанные.Количество * ВесПоСертификатуТовара;
		
	Иначе
		
		ТекущиеДанные.КоличествоПрослеживаемостиПослеИзменения = 
			ТекущиеДанные.КоличествоПослеИзменения * ВесПоСертификатуТовара;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при начале выбора кода ТНВЭД в документе 
// Уведомление об остатках прослеживаемых товаров
//
// Параметры: 
// ФормаВладелец - ФормаКлиентскогоПриложения - форма владелец
//
Процедура КодТНВЭДНачалоВыбора(ФормаВладелец) Экспорт
	
	Объект = ФормаВладелец.Объект;
	ПервичныйДокумент = Объект.ПервичныйДокумент;
	Период = Объект.Дата;
	
	ПрослеживаемостьФормыКлиентПереопределяемый.ОткрытьФормуВыбораТНВЭД(
		ФормаВладелец, ПрослеживаемостьФормыВызовСервера.СписокТНВЭД(ПервичныйДокумент, Объект.Ссылка, Период));

КонецПроцедуры

// Выполняет команду печати документа Уведомление об остатках прослеживаемых товаров
//
// Параметры:
//  ОписаниеКоманды - структура, содержащая ключ, соответствующие таблице значений
//						создаваемой функций БСП УправлениеПечатью.СоздатьКоллекциюКомандПечати(),
//						и ключ Форма - управляемая форма, из которой вызвана команда печати.
//
Функция ВыполнитьКомандуПечатиУведомленияОбОСтаткахПрослеживаемыхТоваров(ОписаниеКоманды) Экспорт

	ПараметрыПечати = ПрослеживаемостьКлиентПереопределяемый.ПолучитьЗаголовокПечатнойФормы(ОписаниеКоманды.ОбъектыПечати);
	
	Если ОписаниеКоманды.Свойство("ДополнительныеПараметры") 
		И ПараметрыПечати <> Неопределено Тогда
		ПараметрыПечати.Вставить("ДополнительныеПараметры", ОписаниеКоманды.ДополнительныеПараметры);
	КонецЕсли;

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров",
		"УведомлениеОбОстаткахПрослеживаемыхТоваров",
		ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма,
		ПараметрыПечати);
	
КонецФункции

// Выполняет команду печати документа "Уведомление о ввозе прослеживаемых товаров"
//
// Параметры:
//  ОписаниеКоманды - структура,содержащая ключ, соответствующие таблице значений
//						создаваемой функций БСП УправлениеПечатью.СоздатьКоллекциюКомандПечати(),
//						и ключ Форма - управляемая форма, из которой вызвана команда печати.
//
Функция ВыполнитьКомандуПечатиУведомленияОВвозеПрослеживаемыхТоваров(ОписаниеКоманды) Экспорт

	ПараметрыПечати = ПрослеживаемостьКлиентПереопределяемый.ПолучитьЗаголовокПечатнойФормы(ОписаниеКоманды.ОбъектыПечати);
	
	Если ОписаниеКоманды.Свойство("ДополнительныеПараметры") 
		И ПараметрыПечати <> Неопределено Тогда
		ПараметрыПечати.Вставить("ДополнительныеПараметры", ОписаниеКоманды.ДополнительныеПараметры);
	КонецЕсли;

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОВвозеПрослеживаемыхТоваров",
		"УведомлениеОВвозеПрослеживаемыхТоваров",
		ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма,
		ПараметрыПечати);
	
КонецФункции

#Область УведомленияОбОстатках

// Проверяет соответствие реквизитов шапки с реквизитами табличной части
//
// Параметры: 
// ФормаВладелец - ФормаКлиентскогоПриложения - форма владелец
// Отказ - булево - признак отказа
// ПараметрыЗаписи - РежимЗаписиДокумента - режимы записи документа
//
Процедура ПроверитьСоответствиеРеквизитовВШапкеИТабличнойЧасти(Форма, Отказ, ПараметрыЗаписи) Экспорт
	
	ПрослеживаемостьФормыКлиентПереопределяемый.ПроверитьСоответствиеРеквизитовВШапкеИТабличнойЧасти(
		Форма, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область УведомленияОПеремещении

// Выполняет команду печати документа Уведомление о перемещении прослеживаемых товаров
//
// Параметры:
//  ОписаниеКоманды - структура, содержащая ключ, соответствующие таблице значений
//						создаваемой функций БСП УправлениеПечатью.СоздатьКоллекциюКомандПечати(),
//						и ключ Форма - управляемая форма, из которой вызвана команда печати.
//
Функция ВыполнитьКомандуПечатиУведомленияОПеремещенииПрослеживаемыхТоваров(ОписаниеКоманды) Экспорт

	ПараметрыПечати = ПрослеживаемостьКлиентПереопределяемый.ПолучитьЗаголовокПечатнойФормы(ОписаниеКоманды.ОбъектыПечати);
	
	Если ОписаниеКоманды.Свойство("ДополнительныеПараметры") 
		И ПараметрыПечати <> Неопределено Тогда
		ПараметрыПечати.Вставить("ДополнительныеПараметры", ОписаниеКоманды.ДополнительныеПараметры);
	КонецЕсли;

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОПеремещенииПрослеживаемыхТоваров",
		"УведомлениеОПеремещенииПрослеживаемыхТоваров",
		ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма,
		ПараметрыПечати);
	
КонецФункции

#КонецОбласти

#КонецОбласти