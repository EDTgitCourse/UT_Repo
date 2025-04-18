#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
// Форма - ФормаКлиентскогоПриложения - Форма отчета.
// КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
// Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;

КонецПроцедуры


// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
// ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета:
// 	 * Параметры - Структура - может содержать свойства:
//				** ПараметрКоманды -
//				** ОписаниеКоманды - Структура -
// Отказ - Булево - Передается из параметров обработчика "как есть".
// СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
// "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс - помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт

	Параметры = ЭтаФорма.Параметры;

	Если Параметры.Свойство("ПараметрКоманды")
		И Параметры.Свойство("ОписаниеКоманды")
		И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда

		ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды;
		Параметры.КлючНазначенияИспользования = Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды;

	КонецЕсли;

КонецПроцедуры


// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
// Форма - ФормаКлиентскогоПриложения - Форма отчета.
// НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//
// См. синтакс - помощник "Расширение управляемой формы для отчета.ПриЗагрузкеВариантаНаСервере" в синтакс - помощнике.
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт

	Отчет = Форма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек; // КомпоновщикНастроекКомпоновкиДанных -

	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры


#КонецОбласти

#КонецЕсли
