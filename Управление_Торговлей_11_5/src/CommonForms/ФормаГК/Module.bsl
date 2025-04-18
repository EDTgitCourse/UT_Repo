#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	УстановитьУсловноеОформление();
	Если ТипЗнч(Параметры.ДоговорСсылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ДоговорыКонтрагентов);
	ИначеЕсли ТипЗнч(Параметры.ДоговорСсылка) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда 
		ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ДоговорыМеждуОрганизациями);
	ИначеЕсли ТипЗнч(Параметры.ДоговорСсылка) = Тип("СправочникСсылка.ДоговорыКредитовИДепозитов") Тогда 
		ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ДоговорыКредитовИДепозитов);
	КонецЕсли;
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	ДоговорКредитовИДепозитов = ТипЗнч(Параметры.ДоговорСсылка) = Тип("СправочникСсылка.ДоговорыКредитовИДепозитов");
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, ДоговорыКонтрагентовЛокализацияКлиентСервер.ИменаРеквизитовГОЗ());
	
	
	УправлениеЭлементамиГосКонтрактов();
	УстановитьПараметрыВыбораДоговораСЗаказчиком();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл"
			И Параметр.Свойство("ВладелецФайла")
			И Параметр.ВладелецФайла = ДоговорСсылка
			И Параметр.ЭтоНовый
			И ДобавляетсяФайлПодтверждающегоДокумента Тогда
			
		Элементы.ПодтверждающиеДокументы.ТекущиеДанные.Файл = Источник[0];
		ДобавляетсяФайлПодтверждающегоДокумента = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПлатежиПо275ФЗ Тогда
		Если ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
			И ВариантПлатежаГОЗ = 1 И Не ЗначениеЗаполнено(КонтрактСЗаказчиком) Тогда
			
			Текст = НСтр("ru = 'Поле ""Договор с заказчиком"" не заполнено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,,
				"КонтрактСЗаказчиком",,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПлатежиПо275ФЗПриИзменении(Элемент)

	ДоговорСУчастникомГОЗ = ПлатежиПо275ФЗ;
	УправлениеЭлементамиГосКонтрактов();

КонецПроцедуры

&НаКлиенте
Процедура ВариантПлатежаГОЗПриИзменении(Элемент)
	
	
	ПлатежиПо275ФЗ = (ВариантПлатежаГОЗ <> 0);
	ДоговорСУчастникомГОЗ = (ВариантПлатежаГОЗ = 1);
	ОплатаРасходовПоТарифамСГосрегулированием = (ВариантПлатежаГОЗ = 2);
	
	ВариантПлатежаГОЗПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ГосударственныйКонтрактПриИзменении(Элемент)
	ГосударственныйКонтрактПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодтверждающиеДокументы

&НаКлиенте
Процедура ПодтверждающиеДокументыВидДокументаПриИзменении(Элемент)
	
	
	ТекущиеДанные = Элементы.ПодтверждающиеДокументы.ТекущиеДанные;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждающиеДокументыФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодтверждающиеДокументыФайлНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПунктыМеню = Новый СписокЗначений;
	ПунктыМеню.Добавить("ВыборИзПрисоединенныхФайлов",
		НСтр("ru= 'Выбрать из присоединенных файлов ...'"),, БиблиотекаКартинок.ВыбратьЗначение);
	ПунктыМеню.Добавить("ДобавлениеФайлаСДиска",
		НСтр("ru= 'Добавить файл с диска ...'"),, БиблиотекаКартинок.ОткрытьФайл);
	
	ПоказатьВыборИзМеню(ОписаниеОповещения, ПунктыМеню, Элементы.ПодтверждающиеДокументыФайл);

КонецПроцедуры

&НаСервере
Процедура ВариантПлатежаГОЗПриИзмененииНаСервере()
	
	ТипПлатежаФЗ275 = Неопределено;
	
	
	УправлениеЭлементамиГосКонтрактов();
	УстановитьПараметрыВыбораДоговораСЗаказчиком();
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждающиеДокументыФайлНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ДополнительныеПараметрыВыбораВладельца = Новый Структура("Действие", Результат.Значение);
		ВыборВладельцаФайлаЗавершение(Новый Структура("Значение", ДоговорСсылка), ДополнительныеПараметрыВыбораВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура ВыборВладельцаФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ВыбранныйВладелецФайла = Результат.Значение;
		
		Если ДополнительныеПараметры.Действие = "ДобавлениеФайлаСДиска" Тогда
			
			ИдентификаторФайла = Новый УникальныйИдентификатор;
			ДобавляетсяФайлПодтверждающегоДокумента = Истина;
			
			РаботаСФайламиКлиент.ДобавитьФайлы(ВыбранныйВладелецФайла, ИдентификаторФайла);
			
		ИначеЕсли ДополнительныеПараметры.Действие = "ВыборИзПрисоединенныхФайлов" Тогда
			
			РаботаСФайламиКлиент.ОткрытьФормуВыбораФайлов(ВыбранныйВладелецФайла, Элементы.ПодтверждающиеДокументыФайл);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	ОчиститьСообщения();
	Если ПроверитьЗаполнение() Тогда
		ПоместитьДокументыВоВременноеХранилище();
		
		СтруктураРеквизитов = Новый Структура(ДоговорыКонтрагентовЛокализацияКлиентСервер.ИменаРеквизитовГОЗ());
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, ЭтаФорма);
		Закрыть(СтруктураРеквизитов);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьПодтверждающийДокумент(Команда)	
	Если Элементы.ПодтверждающиеДокументы.ТекущаяСтрока <> Неопределено Тогда
		Файл = Элементы.ПодтверждающиеДокументы.ТекущиеДанные.Файл;
		
		Если Файл = Неопределено Или Файл.Пустая() Тогда
			ПоказатьПредупреждение(,НСтр("ru= 'Файл подтверждающего документа не указан.'"));
			Возврат;
		КонецЕсли;
		
		РеквизитыФайла = РеквизитыОбъекта(Файл);
		
		Если РеквизитыФайла.Зашифрован Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеФайла = ПолучитьДанныеФайла(Файл, УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, РеквизитыФайла.ФайлРедактируется);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодтверждающиеДокументы(Команда)
	
	
	Возврат; // В УТ обработчик пустой
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	
КонецПроцедуры

&НаСервере
Функция РеквизитыОбъекта(ПодтверждающийДокумент)
	
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПодтверждающийДокумент, "Зашифрован, Редактирует");
	
	ФайлРедактируется = (ЗначениеЗаполнено(РеквизитыОбъекта.Редактирует) И РеквизитыОбъекта.Редактирует = ТекущийПользователь);
	РеквизитыОбъекта.Вставить("ФайлРедактируется", ФайлРедактируется);
	
	Возврат РеквизитыОбъекта;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайла(Знач ПрисоединенныйФайл, Знач ИдентификаторФормы = Неопределено, Знач ПолучатьСсылкуНаДвоичныеДанные = Истина)
	
	Возврат РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, ИдентификаторФормы, ПолучатьСсылкуНаДвоичныеДанные);
	
КонецФункции


&НаСервере
Процедура УправлениеЭлементамиГосКонтрактов()
	
	СЗаказчиком = (ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем);
	СИсполнителем = (ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком);
	СПереработчиком = 
		ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком2_5
		Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком2_5_ЕАЭС
		//++ Устарело_Переработка24
		Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком
		//-- Устарело_Переработка24
		Или Ложь;
	
	КупляПродажа = (ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа);

	Элементы.ПодтверждающиеДокументы.Видимость =
		ПлатежиПо275ФЗ
		И (СЗаказчиком
		Или СИсполнителем
		Или СПереработчиком
		Или КупляПродажа
		Или ДоговорКредитовИДепозитов);
	
	// Специфика заказчика
	Элементы.ПлатежиПо275ФЗ.Видимость =
		СЗаказчиком
		Или Ложь;
	
	Элементы.ГосударственныйКонтрактЗаказчик.Видимость =
		(СЗаказчиком
			Или Ложь)
		И ПлатежиПо275ФЗ
		И ДоговорСУчастникомГОЗ;
		
	Элементы.ДекорацияОтступВыполненыОбязательстваГОЗ.Видимость =
		(СЗаказчиком
			Или Ложь)
		И ДоговорСУчастникомГОЗ
		И ПоддержкаПлатежей275ФЗ;
	
	Элементы.ВыполненыОбязательстваПоДоговоруГОЗ.Видимость =
		(СЗаказчиком
			Или КупляПродажа)
		И ДоговорСУчастникомГОЗ;
	
	// Специфика исполнителя
	Элементы.ВариантПлатежаПрочемуИсполнителю.Видимость =
		(СИсполнителем
			ИЛИ СПереработчиком
			ИЛИ КупляПродажа)
		И ПоддержкаПлатежей275ФЗ;
	
	Элементы.ВариантПлатежаУчастникуКооперации.Видимость =
		(СИсполнителем
			ИЛИ СПереработчиком
			ИЛИ КупляПродажа)
		И ПоддержкаПлатежей275ФЗ;
	
	Элементы.ВариантПлатежаПоТарифам.Видимость =
		(СИсполнителем
			ИЛИ КупляПродажа)
		И ПоддержкаПлатежей275ФЗ;
	
	Элементы.ГосударственныйКонтракт.Видимость =
		(СИсполнителем
			ИЛИ СПереработчиком
			ИЛИ КупляПродажа)
		И ПлатежиПо275ФЗ
		И ДоговорСУчастникомГОЗ;
	
	Элементы.КонтрактСЗаказчиком.Видимость =
		(СИсполнителем
			ИЛИ СПереработчиком
			ИЛИ КупляПродажа)
		И ВариантПлатежаГОЗ = 1;
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
	
	ОтборОрганизаций = Справочники.Организации.МассивВзаимосвязанныхОрганизаций(Организация);
	ОтборОрганизаций.Добавить(Организация);
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", Новый ФиксированныйМассив(ОтборОрганизаций)));
	
	Элементы.КонтрактСЗаказчиком.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

&НаСервере
Процедура ГосударственныйКонтрактПриИзмененииНаСервере()
	Если ТипЗнч(ДоговорСсылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		КонтрактСЗаказчиком = ДоговорыКонтрагентовЛокализация.ПолучитьКонтрактСЗаказчиком(ГосударственныйКонтракт, Организация);
	ИначеЕсли ТипЗнч(ДоговорСсылка) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда 
		КонтрактСЗаказчиком = ДоговорыМеждуОрганизациямиЛокализация.ПолучитьКонтрактСЗаказчиком(ГосударственныйКонтракт, ОрганизацияПолучатель);
	КонецЕсли;
	УстановитьПараметрыВыбораДоговораСЗаказчиком();
КонецПроцедуры

&НаСервере
Процедура ПоместитьДокументыВоВременноеХранилище()
	ПоместитьВоВременноеХранилище(ПодтверждающиеДокументы.Выгрузить(), АдресПодтверждающихДокументовВоВременномХранилище);
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораДоговораСЗаказчиком()
	
	// Отберем контракты, в которых организация-покупатель является организацией-поставщиком.
	ДополнительныеПараметры = Новый Структура;
	Если ЗначениеЗаполнено(ОрганизацияПолучатель) Тогда
		ДополнительныеПараметры.Вставить("Организация", ОрганизацияПолучатель);
	Иначе
		ДополнительныеПараметры.Вставить("Организация", Организация);
	КонецЕсли;
	Если ВариантПлатежаГОЗ = 1 Тогда
		ДополнительныеПараметры.Вставить("ГосударственныйКонтракт", ГосударственныйКонтракт);
	КонецЕсли;
	
	ДенежныеСредстваСерверЛокализация.УстановитьПараметрыВыбораДоговораСЗаказчиком(Элементы.КонтрактСЗаказчиком, ДополнительныеПараметры);
	
КонецПроцедуры


#КонецОбласти
