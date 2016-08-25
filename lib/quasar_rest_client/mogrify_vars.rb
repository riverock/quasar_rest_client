require 'time'
require 'date'

# Include this module
module QuasarRestClient
  module MogrifyVars

    def mogrify_vars(hash)
      vars = hash[:var]&.map do |k, v|
        new_key = "var.#{k}"

        # This is hacky-hack, at best
        # E.g. given var: { email: "yacht@mail.com"} =>
        #            var.email: '"yacht@mail.com"'
        # i.e. quasar requires the double quotes
        # Note that the documentation says single quotes, but it is WRONG
        new_val = case v
                  when String
                    v.inspect
                  # NOTE: order is important: DateTime must precede Date
                  when DateTime
                    "TIMESTAMP '#{v.strftime("%F %T")}'"
                  when Date
                    "DATE '#{v.strftime("%F")}'"
                  when Time
                    "TIME '#{v.strftime("%T")}'"
                  when Array
                    v.inspect
                  else
                    v
                  end

        [new_key, new_val]
      end.to_h

      hash.delete(:var)
      hash.merge(vars)
    end

  end
end
