
#+------------------------------------+------------------------------------------------------------+--------+----------------+
#| Issuing network                    | IIN ranges                                                 | Length | Validation     |
#+------------------------------------+------------------------------------------------------------+--------+----------------+
#| American Express                   | 34, 37                                                     | 15     | Luhn algorithm |
#| China UnionPay                     | 62                                                         | 16-19  | no validation  |
#| Diners Club Carte Blanche          | 300-305                                                    | 14     | Luhn algorithm |
#| Diners Club International          | 36                                                         | 14     | Luhn algorithm |
#| Diners Club United States & Canada | 54, 55                                                     | 16     | Luhn algorithm |
#| Discover Card                      | 6011, 622126-622925, 644-649, 65                           | 16     | Luhn algorithm |
#| InstaPayment                       | 637-639                                                    | 16     | Luhn algorithm |
#| JCB                                | 3528-3589                                                  | 16     | Luhn algorithm |
#| Laser                              | 6304, 6706, 6771, 6709                                     | 16-19  | Luhn algorithm |
#| Maestro                            | 5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763, 0604 | 12-19  | Luhn algorithm |
#| MasterCard                         | 51-55                                                      | 16     | Luhn algorithm |
#| Visa                               | 4                                                          | 13, 16 | Luhn algorithm |
#| Visa Electron                      | 4026, 417500, 4405, 4508, 4844, 4913, 4917                 | 16     | Luhn algorithm |
#+------------------------------------+------------------------------------------------------------+--------+----------------+


CC_MAP = [
  {network: 'American Express',          iin: '34, 37',          length: '15' },
  {network: 'China UnionPay',            iin: '62',              length: '16-19' },
  {network: 'Diners Club Carte Blanche', iin: '300-305',         length: '14'},
  {network: 'Diners Club International', iin: '36',              length: '14' },
  {network: 'Diners Club United States & Canada', iin: '54, 55', length: '16' },
  {network: 'Discover Card',             iin: '6011, 622126-622925, 644-649, 65', length: '16'},
  {network: 'InstaPayment',              iin: '637-639',         length: '16'},
  {network: 'JCB',                       iin: '3528-3589',       length: '16'},
  {network: 'Laser',                     iin: '6304, 6706, 6771, 6709', length: '16-19' },
  {network: 'Maestro',                   iin: '5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763, 0604', length: '12-19'},
  {network: 'MasterCard',                iin: '51-55',           length: '16' },
  {network: 'Visa',                      iin: '4',               length: '13, 16' },
  {network: 'Visa Electron',             iin: '4026, 417500, 4405, 4508, 4844, 4913, 4917', length: '16'}
]

module Card
  class Issuer
    def self.find(digits)
      check(digits)
    end

    def self.check_length(digits)
      digits.length
    end

    def self.process_string(data)
      data_array = split_on_commas(data)
      split_range(data_array)
    end

    def self.split_on_commas(string)
      string.split(', ')
    end

    def self.split_range(array)
      array.map do |element|
        if (/-/ =~ element) == nil
          element
        else
          create_range(element)
        end
      end.flatten
    end

    def self.create_range(range)
      low, high = range.split('-')
      array = []

      low.upto(high) { |number| array << number }
      array
    end

    def self.check(digits)
      CC_MAP.each do |network_hash| 
        new_data = self.process_string(network_hash[:iin])
        new_data.each do |number|      
          if digits[/^#{number}/] 
           return network_hash[:network]
         end
       end
     end
   end
 end
end


require 'minitest/autorun'

describe Card::Issuer do
  describe '.find' do
    TESTS = {
      '346416800707698'  => 'American Express',
      '36035390282568'   => 'Diners Club International',
      '6011694809533437' => 'Discover Card',
      '4539369138573325' => 'Visa',
      '5347429545519193' => 'MasterCard',
      '3528378434502040' => 'JCB'
    }

    TESTS.each do |digits, issuer|
      it "returns #{issuer} for #{digits}" do
        Card::Issuer.find(digits).must_equal issuer
      end
    end
  end
end



























