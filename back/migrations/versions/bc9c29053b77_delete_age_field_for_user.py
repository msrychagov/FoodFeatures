"""Delete_age_field_for_user

Revision ID: bc9c29053b77
Revises: a41702c15afc
Create Date: 2025-04-06 22:05:59.628485

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'bc9c29053b77'
down_revision: Union[str, None] = 'a41702c15afc'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('users', 'age')
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('users', sa.Column('age', sa.INTEGER(), autoincrement=False, nullable=True))
    # ### end Alembic commands ###
