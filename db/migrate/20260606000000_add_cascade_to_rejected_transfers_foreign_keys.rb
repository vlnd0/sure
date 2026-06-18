class AddCascadeToRejectedTransfersForeignKeys < ActiveRecord::Migration[7.2]
  def change
    reversible do |dir|
      dir.up do
        # Existing databases may not have these foreign keys at all (schema drift),
        # so only drop them when present before re-adding with ON DELETE CASCADE.
        remove_foreign_key :rejected_transfers, column: :inflow_transaction_id if foreign_key_exists?(:rejected_transfers, column: :inflow_transaction_id)
        remove_foreign_key :rejected_transfers, column: :outflow_transaction_id if foreign_key_exists?(:rejected_transfers, column: :outflow_transaction_id)

        unless foreign_key_exists?(:rejected_transfers, column: :inflow_transaction_id)
          add_foreign_key :rejected_transfers, :transactions, column: :inflow_transaction_id, on_delete: :cascade
        end
        unless foreign_key_exists?(:rejected_transfers, column: :outflow_transaction_id)
          add_foreign_key :rejected_transfers, :transactions, column: :outflow_transaction_id, on_delete: :cascade
        end
      end

      dir.down do
        remove_foreign_key :rejected_transfers, column: :inflow_transaction_id if foreign_key_exists?(:rejected_transfers, column: :inflow_transaction_id)
        remove_foreign_key :rejected_transfers, column: :outflow_transaction_id if foreign_key_exists?(:rejected_transfers, column: :outflow_transaction_id)
      end
    end
  end
end
