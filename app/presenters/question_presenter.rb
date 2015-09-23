class QuestionPresenter < NodePresenter
  def translate_and_render(subkey, html: true)
    markup = translate!(subkey)
    return unless markup
    html ? GovspeakPresenter.new(markup.strip).html : markup
  end

  def translate!(subkey)
    I18n.translate!("#{i18n_node_prefix}.#{subkey}", state_for_interpolation)
  rescue I18n::MissingTranslationData
    nil
  end

  def title
    translate!('title') || @node.name.to_s.humanize
  end

  def error
    if @state.error.present?
      translate!(@state.error.to_sym) || error_message || I18n.translate('flow.defaults.error_message')
    end
  end

  def error_message
    translate!('error_message')
  end

  def has_error_message?
    !!error_message
  end

  def hint
    translate!('hint')
  end

  def has_hint?
    !!hint
  end

  def label
    translate!('label')
  end

  def has_label?
    !!label
  end

  def suffix_label
    translate!('suffix_label')
  end

  def has_suffix_label?
    !!suffix_label
  end

  def has_labels?
    !!label or !!suffix_label
  end

  def body(html: true)
    translate_and_render('body', html: html)
  end

  def options
    @node.options.map do |option|
      OpenStruct.new(label: translate_option(option), value: option)
    end
  end

  def translate_option(option)
    translate!("options.#{option}") ||
    begin
      I18n.translate!("#{@i18n_prefix}.options.#{option}", @state.to_hash)
    rescue I18n::MissingTranslationData
      option
    end
  end

  def to_response(input)
    @node.to_response(input)
  end

  def response_label(value)
    value
  end

  def partial_template_name
    "#{@node.class.name.demodulize.underscore}_question"
  end

  def multiple_responses?
    false
  end
end
