
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Параметры.Свойство("ЗначенияЗаполнения") И Параметры.ЗначенияЗаполнения.Свойство("АктивПассив") Тогда
			Объект.АктивПассив = Параметры.ЗначенияЗаполнения.АктивПассив;
		Иначе
			Объект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Актив;
		КонецЕсли;
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	//ЗаполнитьСписокВыбораТиповЗначенийАналитики();
	
	ОпределитьДоступностьНастройкиСчетовУчета();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Аналитика) Тогда
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Аналитика);
		ТекущийОбъект.ТипЗначения = Новый ОписаниеТипов(МассивТипов);
	КонецЕсли;
	Если АктивПассив = "Актив" Тогда
		ТекущийОбъект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Актив;
	ИначеЕсли АктивПассив = "АктивПассив" Тогда
		ТекущийОбъект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.АктивПассив;
	Иначе
		ТекущийОбъект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Пассив;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АктивПассивПриИзменении(Элемент)
	ЗаполнитьСписокВыбораТиповЗначенийАналитики()
КонецПроцедуры

&НаКлиенте
Процедура АналитикаПриИзменении(Элемент)
	
	УправлениеВидимостью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьОборотПриИзменении(Элемент)

	УправлениеВидимостью(ЭтаФорма);

КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗначенияПрочихАктивовПассивов(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = Нстр("ru = 'Данные еще не записаны.
		|Переход к значениям прочих активов и пассивов возможен только после записи данных.
		|Данные будут записаны.'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗначенияПрочихАктивовПассивовЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
		
	КонецЕсли;
	
	ЗначенияПрочихАктивовПассивовФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПрочихАктивовПассивовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;

	Если НЕ Записать() Тогда
		Возврат;
	КонецЕсли;

	ЗначенияПрочихАктивовПассивовФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПрочихАктивовПассивовФрагмент()

	СтруктураОтбора = Новый Структура("Владелец", Объект.Ссылка);
	ПараметрыФормы = Новый структура("Отбор", СтруктураОтбора);
	ОткрытьФорму("Справочник.ПрочиеАктивыПассивы.ФормаСписка", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура НастроитьСчетаУчета(Команда)
	
	Возврат; // не пустой обработчик
	
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	Если Объект.ТипЗначения.Типы().Количество() = 1 Тогда
		Аналитика = Объект.ТипЗначения.Типы()[0];
	КонецЕсли;
	ЗаполнитьСписокВыбораТиповЗначенийАналитики();
	УстановитьПризнакАктивПассив();
	УправлениеВидимостью(ЭтаФорма);
	
КонецПроцедуры

#Область УправлениеЭлементамиФормы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВидимостью(Форма)
	
	Форма.Элементы.ЗначенияПрочихАктивовПассивов.Видимость = (Форма.Аналитика = Тип("СправочникСсылка.ПрочиеАктивыПассивы"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораТиповЗначенийАналитики()
	
	СписокВыбора = Элементы.Аналитика.СписокВыбора;
	СписокВыбора.Очистить();
	Для каждого Тип Из Метаданные.ПланыВидовХарактеристик.СтатьиАктивовПассивов.Тип.Типы() Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда
			СписокВыбора.Добавить(Тип, ОбъектМетаданных.Представление());
		КонецЕсли;
	КонецЦикла;
	СписокВыбора.СортироватьПоПредставлению();
	
	ЭлементыВКонце = Новый Массив;
	ЭлементыВКонце.Добавить(Тип("СправочникСсылка.ПрочиеАктивыПассивы"));
	ЭлементыВКонце.Добавить(Тип("ПеречислениеСсылка.СтатьиБезАналитики"));
	Для каждого Элемент Из ЭлементыВКонце Цикл
		ЭлементСписка = СписокВыбора.НайтиПоЗначению(Элемент);
		ИндесЭлемента = СписокВыбора.Индекс(ЭлементСписка);
		СписокВыбора.Сдвинуть(ЭлементСписка, СписокВыбора.Количество() - ИндесЭлемента - 1);
	КонецЦикла;
	
	Если ПустаяСтрока(АктивПассив) Тогда
		АктивПассив = СтрЗаменить(Строка(Объект.АктивПассив), "/", "");
	КонецЕсли;
	
	// Установить подсказки ввода
	Элементы.ПредставлениеДебетаСтатьи.ПодсказкаВвода = НСтр("ru = 'Увеличение'");
	Элементы.ПредставлениеКредитаСтатьи.ПодсказкаВвода = НСтр("ru = 'Уменьшение'");
	Если АктивПассив = "Пассив" Тогда
		Элементы.ПредставлениеДебетаСтатьи.ПодсказкаВвода = НСтр("ru = 'Уменьшение'");
		Элементы.ПредставлениеКредитаСтатьи.ПодсказкаВвода = НСтр("ru = 'Увеличение'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьНастройкиСчетовУчета()
	
	ВидимостьНастройкиСчетовУчета = Ложь;
	
	
	Элементы.НастроитьСчетаУчета.Видимость = ВидимостьНастройкиСчетовУчета;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьПризнакАктивПассив()
	
	Если Объект.АктивПассив = ПредопределенноеЗначение("Перечисление.ВидыСтатейУправленческогоБаланса.Актив") Тогда
		АктивПассив = "Актив";
	ИначеЕсли Объект.АктивПассив = ПредопределенноеЗначение("Перечисление.ВидыСтатейУправленческогоБаланса.АктивПассив") Тогда
		АктивПассив = "АктивПассив";
	Иначе
		АктивПассив = "Пассив";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ПараметрыФормы = Новый Структура;
		ОткрытьФорму("ПланВидовХарактеристик.СтатьиАктивовПассивов.Форма.РазблокированиеРеквизитов", ПараметрыФормы,,,,, Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
	КонецЕсли;

КонецПроцедуры

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
