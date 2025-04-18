#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияГИСМПереопределяемый.ОбработкаЗаполненияУведомленияОбОтгрузкеГИСМ(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	GLNКонтрагента = ИнтеграцияГИСМ.ПоследнийУказанныйВДокументахGLNКонтрагента(Контрагент);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	РеквизитыКонтрагента = ИнтеграцияГИСМВызовСервера.РеквизитыКонтрагента(Контрагент);
	
	ЭтоВозвратФизическомуЛицуПоКомиссии = ИнтеграцияГИСМ.ДокументОснованиеВозвратПоставщику(Основание)
		И РеквизитыКонтрагента.ЭтоФизическоеЛицо
		И ВидОборотаТовара = Перечисления.ВидОборотаТовараГИСМ.Комиссия;
	
	ЭтоЭкспортЗаПределыЕАЭС = (ВидОборотаТовара = Перечисления.ВидОборотаТовараГИСМ.ЭкспортЗаПределыЕАЭС);
	ЭкспортВСтраныЕАЭС      = (ВидОборотаТовара = Перечисления.ВидОборотаТовараГИСМ.ЭкспортВСтраныЕАЭС);
	
	Если Не ЭтоЭкспортЗаПределыЕАЭС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КодТаможенногоОргана");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаРегистрацииДекларации");
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныйНомерДекларации");
	КонецЕсли;
	
	Если ЭтоЭкспортЗаПределыЕАЭС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
	КонецЕсли;
	
	Если    ЭтоЭкспортЗаПределыЕАЭС
		Или ЭкспортВСтраныЕАЭС
		Или КонтрагентНеЗарегистрированВГИСМ
		Или ЭтоВозвратФизическомуЛицуПоКомиссии Тогда
		МассивНепроверяемыхРеквизитов.Добавить("GLNКонтрагента");
	КонецЕсли;
	
	Если ЭтоНовый() И ЗначениеЗаполнено(Основание) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ТекущееУведомлениеОбОтгрузке
		|ИЗ
		|	РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ КАК СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ
		|ГДЕ
		|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Документ = &Основание
		|	И НЕ СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Статус В (
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОтклоненоКлиентом),
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОтклоненоГИСМ),
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Отсутствует)
		|		)
		|	И НЕ СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ТекущееУведомлениеОбОтгрузке = ЗНАЧЕНИЕ(Документ.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ.ПустаяСсылка)";
		
		Запрос.УстановитьПараметр("Основание", Основание);
		
		Результат = Запрос.Выполнить();
		
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			ТекстОшибки = НСтр("ru='Для документа %1 уже существует текущая %2.'");
				ТекстОшибки =  СтрШаблон(ТекстОшибки, Основание, Выборка.ТекущееУведомлениеОбОтгрузке);
				
				ОбщегоНазначения.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					,
					,
					Отказ);
			
				КонецЕсли;
				
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомераКиЗ.Очистить();
	
	НомерГИСМ = 0;
	Основание = Неопределено;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("ЗаписьНового", Истина);
	КонецЕсли;
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли