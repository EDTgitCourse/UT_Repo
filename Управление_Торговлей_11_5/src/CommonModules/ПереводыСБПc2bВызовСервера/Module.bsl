///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.ПереводыСБПc2b".
// ОбщийМодуль.ПереводыСБПc2bВызовСервера.
//
// Серверные процедуры настройки подключения к участникам СБП:
//  - механизмы управления шаблонами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. ПереводыСБПc2bСлужебный.ВсеШаблоныСозданы.
//
Функция ВсеШаблоныСозданы() Экспорт
	
	Возврат ПереводыСБПc2bСлужебный.ВсеШаблоныСозданы();
	
КонецФункции

// См. ПереводыСБПc2bСлужебный.СоздатьПредопределенныеШаблоныСообщенийПроверкаПодсистем.
//
Функция СоздатьПредопределенныеШаблоныСообщенийПроверкаПодсистем() Экспорт
	
	Возврат ПереводыСБПc2bСлужебный.СоздатьПредопределенныеШаблоныСообщенийПроверкаПодсистем();
	
КонецФункции

// См. ПереводыСБПc2bСлужебный.СоздатьПредопределенныеШаблоныСообщенийПроверкаПодсистем.
//
Процедура УстановитьИспользованиеШаблоновСообщенийПроверкаПодсистем() Экспорт
	
	ПереводыСБПc2bСлужебный.УстановитьИспользованиеШаблоновСообщенийПроверкаПодсистем();
	
КонецПроцедуры

// См. ПереводыСБПc2bСлужебный.ПриОпределенииДоступностиПодключенияПоДокументуОперации.
//
Функция ПриОпределенииДоступностиПодключенияПоДокументуОперации(
		Знач ДокументОперации) Экспорт
	
	Возврат ПереводыСБПc2bСлужебный.ПриОпределенииДоступностиПодключенияПоДокументуОперации(
		ДокументОперации);
	
КонецФункции

// См. ПереводыСБПc2bСлужебный.ПриОпределенииПараметровПодключенияДокументаОперации.
//
Функция ПриОпределенииПараметровПодключенияДокументаОперации(
		Знач ДокументОперации) Экспорт
	
	Возврат ПереводыСБПc2bСлужебный.ПриОпределенииПараметровПодключенияДокументаОперации(
		ДокументОперации);
	
КонецФункции

#КонецОбласти
