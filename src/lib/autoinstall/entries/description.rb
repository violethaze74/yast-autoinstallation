# Copyright (c) [2020] SUSE LLC
#
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, contact SUSE LLC.
#
# To contact SUSE LLC about this file by physical or electronic mail, you may
# find current contact information at www.suse.com.

module Y2Autoinstallation
  # Entries module represents code related to manipulation with implementation
  # that handles each section of autoyast profile. Originally known as
  # Modules or ModuleConfig which is not used to avoid confusion with over
  # using module name.
  module Entries
    # Represents single entry description. It is stored in desktop files.
    class Description

      # Values used in this class. It is needed to pass it to Desktop.Read.
      USED_VALUES = [
        "X-SuSE-YaST-AutoInstResource",
        "X-SuSE-YaST-AutoInstResourceAliases",
        "X-SuSE-YaST-AutoInstMerge",
        "X-SuSE-YaST-AutoInstClonable",
        "X-SuSE-YaST-AutoInstClient",
        "X-SuSE-YaST-AutoInst",
        "Hidden"
      ]

      # creates new description with values passed
      # @param values[Hash] hash from Desktop.Modules
      def initialize(values)
        @values = values
      end

      def mode
        values["X-SuSE-YaST-AutoInst"]
      end

      def resource_name
        values["X-SuSE-YaST-AutoInstResource"]
      end

      def aliases
        val = values["X-SuSE-YaST-AutoInstResourceAliases"]
        return [] unless val

        val.split(",").map(&:strip)
      end

      # which autoyast profile sections are managed by this entry
      # Example of multiple ones is users which manager users and groups keys.
      def managed_keys
        multiple = values["X-SuSE-YaST-AutoInstMerge"]
        if multiple
          multiple.split(",").map(&:strip)
        else
          [resource_name]
        end
      end

      ALWAYS_CLONABLE_MODULES ||= ["software", "partitioning", "bootloader"].freeze
      private_constant :ALWAYS_CLONABLE_MODULES

      def clonable?
        values["X-SuSE-YaST-AutoInstClonable"] == "true" || ALWAYS_CLONABLE_MODULES.include?(resource_name)
      end

      def client_name
        values["X-SuSE-YaST-AutoInstClient"] || (resource_name + "_auto")
      end

      def hidden?
        values["Hidden"] == "true"
      end

    private

      attr_reader :values

    end
  end
end
